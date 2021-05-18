
_help() {
cat <<EOF
USAGE: watch-namespace -n <NAMESPACE> -r <REGION>

OPTIONS:
  -n|--namespace NAMESPACE Namespace to watch
  -r|--region    REGION    Datacenter region
EOF
}

if [ $# -eq 0 ]; then
  _help
  exit
fi

# Parse arguments
positional_args=()
USE_SUDO=''
while [ $# -gt 0 ]; do
key="$1"
  case "$key" in
    -r|--root)
    USE_SUDO=true
    shift
    ;;

    -d|--dir)
    DIR="$2"
    shift 2
    ;;

    -h|--help)
    _help
    exit 0
    ;;

    *) # unknown option
    positional_args+=("$1") # save in an array for later
    shift
    ;;
  esac
done
set -- "${positional_args[@]}"

