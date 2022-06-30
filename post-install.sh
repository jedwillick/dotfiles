go install mvdan.cc/sh/v3/cmd/shfmt@latest

python3 -m pip install --upgrade pip
pip install --upgrade -r pip-packages.txt

source "$NVM_DIR/nvm.sh"
nvm install node

npm install -g tree-sitter-cli prettier neovim
