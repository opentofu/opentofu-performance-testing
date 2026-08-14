#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

CHAIN_LENGTH="${CHAIN_LENGTH:-10}"
DEPTH="${DEPTH:-4}"

echo "Chain length: ${CHAIN_LENGTH}, Module depth: ${DEPTH}, Instances per step: 10"

rm -rf generated
mkdir -p generated

# Generate nested service module tree
prev_dir=""
for level in $(seq "$DEPTH" -1 1); do
  if [ "$level" -eq "$DEPTH" ]; then
    dir="generated/service$(printf '/l%s' $(seq 2 "$level") | tr -d '\n')"
  elif [ "$level" -eq 1 ]; then
    dir="generated/service"
  else
    dir="generated/service$(printf '/l%s' $(seq 2 "$level") | tr -d '\n')"
  fi
  mkdir -p "$dir"

  if [ "$level" -eq "$DEPTH" ]; then
    # Leaf module
    cat > "$dir/main.tf" <<EOF
variable "name" {
  type = string
}

resource "tfcoremock_simple_resource" "main" {
  string = "\${var.name}-l${level}"
}

data "tfcoremock_simple_resource" "lookup" {
  id = "\${var.name}-l${level}-data"
}

output "id" {
  value = tfcoremock_simple_resource.main.string
}
EOF
  else
    # Intermediate module - calls next level
    next=$((level + 1))
    cat > "$dir/main.tf" <<EOF
variable "name" {
  type = string
}

resource "tfcoremock_simple_resource" "main" {
  string = "\${var.name}-l${level}"
}

data "tfcoremock_simple_resource" "lookup" {
  id = "\${var.name}-l${level}-data"
}

module "l${next}" {
  source = "./l${next}"
  name   = var.name
}

output "id" {
  value = module.l${next}.id
}
EOF
  fi
done

# Generate main.tf with chain
cat > generated/main.tf <<'HEADER'
terraform {
  required_providers {
    tfcoremock = {
      source  = "hashicorp/tfcoremock"
      version = "0.2.0"
    }
  }
}

provider "tfcoremock" {}

locals {
  instances = toset([for i in range(10) : tostring(i)])
}

HEADER

for step in $(seq 1 "$CHAIN_LENGTH"); do
  {
    echo "module \"step${step}\" {"
    echo '  source   = "./service"'
    echo '  for_each = local.instances'
    echo "  name     = \"step${step}-\${each.key}\""
    if [ "$step" -gt 1 ]; then
      prev=$((step - 1))
      echo "  depends_on = [module.step${prev}]"
    fi
    echo '}'
    echo
  } >> generated/main.tf
done

tofu -chdir=generated init
time tofu -chdir=generated plan
