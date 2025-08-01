set -Eeuo pipefail

before() {
  echo "noop"
}

after() {

  sleep 5
  
  
  num_pods=$(kubectl -n pss  get pod -o json | jq -r '.items | length'  )
  
  if [[ $num_pods != 0 ]]; then
    >&2 echo "There should not be any pods created in the pss namespace after adding additional security permissions"
    exit 1
  fi
}

"$@"
