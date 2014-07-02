#!/usr/bin/env bash

# TODO: Check for build-essential
# TODO: Check for python-dev

checkReturn() {
  if [ $? -ne 0 ]
  then
    echo -e "\033[31merror\033[0m"
    exit 1
  else
    echo -e "\033[32mok\033[0m"
  fi
}


VPKGDIR="${HOME}/.vim/bundle"

commands="vim git curl"
for comm in ${commands}
do
  echo -n "- Checking for ${comm}..."
  which ${comm} > /dev/null
  checkReturn
done

echo -n "- Basic Setup..."
[ -d ${HOME}/.vim ] && echo "please remove ${HOME}/.vim before continue" && exit 1
mkdir -p ${HOME}/.vim/autoload ${VPKGDIR}
curl -so "${HOME}/.vim/autoload/pathogen.vim" "https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim"
[ ! -d ${HOME}/tmp ] && mkdir ${HOME}/tmp || echo ...
checkReturn

PACKAGES="
moll/vim-node
godlygeek/tabular
pangloss/vim-javascript
digitaltoad/vim-jade
kchmck/vim-coffee-script
wavded/vim-stylus
groenewege/vim-less
tpope/vim-surround
scrooloose/nerdcommenter
scrooloose/nerdtree
tomtom/tlib_vim
MarcWeber/vim-addon-mw-utils
garbas/vim-snipmate
honza/vim-snippets
scrooloose/snipmate-snippets
scrooloose/syntastic
tpope/vim-fugitive
"
echo "- Starting packages clonning:"
for package in $PACKAGES
do
  echo -en "\t$package..."
  git clone https://github.com/${package}.git ${VPKGDIR}/${package#*/} > /dev/null 2>&1
  checkReturn
done

curl -so ${HOME}/.vimrc https://raw.githubusercontent.com/joelzamboni/helper/master/vim/vimrc
checkReturn

echo done
