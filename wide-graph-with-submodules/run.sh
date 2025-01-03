mkdir -p ./generated
for i in $(seq 1 1000); do echo module \"module-$i\" \{ source = \"../submodule\" \}; done > ./generated/main.tf

tofu init
time tofu plan -out out.tfplan
time tofu show -json out.tfplan > /dev/null
