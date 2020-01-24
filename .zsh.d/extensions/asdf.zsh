if which asdf >/dev/null 2>&1 && which brew >/dev/null 2>&1; then
  . $(brew --prefix asdf)/asdf.sh
  . $(brew --prefix asdf)/etc/bash_completion.d/asdf.bash
elif [[ -n "${ASDF_DATA_DIR}" ]]; then
  . "${ASDF_DATA_DIR}/completions/asdf.bash"
fi
