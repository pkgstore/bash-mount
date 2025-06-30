#!/usr/bin/env -S bash -euo pipefail
# -------------------------------------------------------------------------------------------------------------------- #
# MOUNT
# Mounting a file system using a script.
# -------------------------------------------------------------------------------------------------------------------- #
# @package    Bash
# @author     Kai Kimera <mail@kai.kim>
# @license    MIT
# @version    0.1.0
# @link
# -------------------------------------------------------------------------------------------------------------------- #

(( EUID != 0 )) && { echo >&2 'This script should be run as root!'; exit 1; }

# -------------------------------------------------------------------------------------------------------------------- #
# CONFIGURATION
# -------------------------------------------------------------------------------------------------------------------- #

# Sources.
SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd -P )"; readonly SRC_DIR
SRC_NAME="$( basename "$( readlink -f "${BASH_SOURCE[0]}" )" )"; readonly SRC_NAME
# shellcheck source=/dev/null
. "${SRC_DIR}/${SRC_NAME%.*}.conf"

# Parameters.
MNT=("${MNT[@]:?}"); readonly MNT

# Variables.
LOG="${SRC_DIR}/log.mount"

# -------------------------------------------------------------------------------------------------------------------- #
# -----------------------------------------------------< SCRIPT >----------------------------------------------------- #
# -------------------------------------------------------------------------------------------------------------------- #

function _msg() {
  local type; type="${1}"
  local msg; msg="$( date '+%FT%T%:z' ) $( hostname -f ) ${SRC_NAME}: ${2}"

  case "${type}" in
    'error') echo "${msg}" >&2; exit 1 ;;
    'success') echo "${msg}" ;;
    *) return 1 ;;
  esac
}

function mnt() {
  for i in "${!MNT[@]}"; do
    findmnt -M "${MNT[${i}]}" && continue
    mount "${i}" "${MNT[${i}]}"
  done
}

function main() {
  mnt 2>&1 | tee "${LOG}"
}; main "$@"
