
function easyrsa_pki_path() {
  DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
	source "$DIR/../config.sh"
  echo $("$OPENVPN_CA_DIR/easyrsa" | grep -oP "PKI: \K(.*)")
  return $?
}

function easyrsa_call() {
  DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
	source "$DIR/../config.sh"
  echo $("$OPENVPN_CA_DIR/easyrsa" $@)
  return $?
}