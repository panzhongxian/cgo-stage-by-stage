abspath() { 
  cd "$(dirname "${1}")"
  echo "${PWD}"/"$(basename "${1}")"
  cd "${OLDPWD}"
} 
relpath() { 
  local FROM TO UP
  FROM="$(abspath "${1%/}")" TO="$(abspath "${2%/}"/)"
  while test "${TO}"  = "${TO#"${FROM}"/}" \
	-a "${TO}" != "${FROM}"; do
	  FROM="${FROM%/*}" UP="../${UP}"
	done
	TO="${UP%/}${TO#${FROM}}"
	echo "${TO:-.}"
  } 

DOT_GIT_DIR=$(git rev-parse --git-common-dir)
if test ! -d "${DOT_GIT_DIR}"; then
    # If `--git-common-dir` is not available, fall back to older way of doing it.
	  DOT_GIT_DIR=$(git rev-parse --git-dir)
fi

HOOKS_DIR="${DOT_GIT_DIR}/hooks"
HOOKS_DIR_RELPATH=$(relpath "${HOOKS_DIR}" "$(dirname $0)")


if [ ! -e "${HOOKS_DIR}/pre-commit" ]; then
  echo "Installing hook 'pre-commit'"
  ln -sf "${HOOKS_DIR_RELPATH}/hooks/pre-commit" "${HOOKS_DIR}/pre-commit"
fi
