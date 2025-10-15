###
# UTILS & VARS
###

GREEN="\033[0;32m"
BLUE="\033[0;34m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
RESET="\033[0m"

log() {
  case "$1" in
    INFO)
      printf "%b[%s]%b %s\n" "$BLUE" "INFO" "$RESET" "$2"
      ;;
    WARNING)
      printf "%b[%s]%b %s\n" "$YELLOW" "WARNING" "$RESET" "$2"
      ;;
    SUCCESS)
      printf "%b[%s]%b %s\n" "$GREEN" "SUCCESS" "$RESET" "$2"
      ;;
    ERROR)
      printf "%b[%s]%b %s\n" "$RED" "ERROR" "$RESET" "$2"
      ;;
  esac
}

log_info() {
  log "INFO" "$1"
}

log_success() {
  log "SUCCESS" "$1"
}

log_warning() {
  log "WARNING" "$1"
}

log_error() {
  log "ERROR" "$1"
}
