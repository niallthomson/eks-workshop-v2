set -Eeuo pipefail

before() {
  echo "noop"
}

after() {
  sleep 30
  #TODO
}

"$@"
