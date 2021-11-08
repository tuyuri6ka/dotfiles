echo "deno install"

cargo=`which cargo`
sudo snap install deno ||
if [ -z $cargo ]; then
	cargo install deno --locked
else
	#curl -fsSL https://deno.land/x/install/install.sh | sh
	echo "hoge"
fi
