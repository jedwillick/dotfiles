go install mvdan.cc/sh/v3/cmd/shfmt@latest

python3 -m pip install --upgrade pip
pip install --upgrade -r pip-packages.txt pynvim

source "$NVM_DIR/nvm.sh"
nvm install 17
nvm use 17

npm install --location=global tree-sitter-cli prettier neovim markdownlint markdownlint-cli
