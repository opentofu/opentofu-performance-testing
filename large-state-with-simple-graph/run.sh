dd if=/dev/urandom of=./rdata.raw count=1k
cat rdata.raw | base64 -w 0 > rdata.b64
rm rdata.raw

tofu plan -no-color -refresh=false -out=tfplan -input=false -parallelism=100
time tofu apply -auto-approve -no-color -parallelism=100 tfplan
