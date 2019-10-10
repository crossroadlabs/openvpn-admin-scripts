function run_bin_command() {
  DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  source "$DIR/../config.sh"

  cmd="$1"
  shift

  sudo -H -u $OPENVPN_USER "$DIR/../binsudo/$cmd" $@
  return $?
}