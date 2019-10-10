
function easyrsa_pki_path() {
  path="$(easyrsa_call | grep -oP "PKI: \K(.*)")"
  result=$?
  echo "$path"
  return $result
}

function easyrsa_call() {
  DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
	source "$DIR/../config.sh"
  cur_dir=$(pwd)
  cd "$OPENVPN_CA_DIR"
  ./easyrsa $@
  result=$?
  cd "$cur_dir"
  return $result
}