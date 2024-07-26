tofu=~/go/bin/tofu

echo "Cleaning out old generated files"
rm -r ./generated
mkdir ./generated
mkdir ./generated/small
mkdir ./generated/medium
mkdir ./generated/large

echo "Creating generated test scenario"

for i in {0..100}; do
	id="${i}"
	#echo -e "output \"o_${id}\" {\n    value = \"val-${id}\"\n}" > ./generated/small/${id}.tofu
	#echo -e "locals {\n    o_${id} = \"val-${id}\"\n}" > ./generated/small/${id}.tofu
	echo -e "provider \"null\" {}" > ./generated/small/${id}.tofu
	for j in {0..10}; do
		id="${i}_${j}"
		#echo -e "output \"o_${id}\" {\n    value = \"val-${id}\"\n}" > ./generated/medium/${id}.tofu
		#echo -e "locals {\n    o_${id} = \"val-${id}\"\n}" > ./generated/medium/${id}.tofu
		echo -e "provider \"null\" {}" > ./generated/medium/${id}.tofu
		for k in {0..10}; do
			id="${i}_${j}_${k}"
			#echo -e "output \"o_${id}\" {\n    value = \"val-${id}\"\n}" > ./generated/large/${id}.tofu
			#echo -e "locals {\n    o_${id} = \"val-${id}\"\n}" > ./generated/large/${id}.tofu
			echo -e "provider \"null\" {}" > ./generated/large/${id}.tofu
		done
	done
done

echo "Running small scenario"
cd ./generated/small
$tofu init &>/dev/null
time $tofu plan &>/dev/null
cd -

echo "Running medium scenario"
cd ./generated/medium
$tofu init &>/dev/null
time $tofu plan &>/dev/null
cd -

echo "Running large scenario"
cd ./generated/large
$tofu init &>/dev/null
time $tofu plan &>/dev/null
cd -
