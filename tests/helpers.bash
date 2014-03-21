run_dir() {
  pushd $1
  local cmd=$2
  if [[ "$3" -eq 1 ]]; then
    eval ${cmd} &
  else
    eval ${cmd}
  fi
  popd
}

run_dir_bkg() {
  run_dir "$1" "$2" 1
}

