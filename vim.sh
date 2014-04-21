#!/usr/bin/env bash

checkReturn() {
  if [ $? -ne 0 ]
  then
    echo -e "\033[31merror\033[0m"
    exit 1
  else
    echo -e "\033[32mok\033[0m"
  fi
}


COMMANDS="vim git curl"
for comm in ${COMMANDS}
do
  echo -n "- Checking for ${comm}..."
  which ${comm}
  checkReturn
done

echo -n "- Basic Setup..."
mkdir -p ~/.vim/autoload ~/.vim/bundle
curl -so ~/.vim/autoload/pathogen.vim https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim
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
  git clone https://github.com/${package}.git ~/.vim/bundle/${package#*/} > /dev/null 2>&1
  checkReturn
done

curl -so ~/.vimrc https://raw.githubusercontent.com/joelzamboni/helper/master/vimrc
checkReturn


echo done
