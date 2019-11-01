#!/bin/bash

npm -v || read -p "Node not found. Do you want to auto install from https://install-node.now.sh? [Yy]" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    curl -sL https://install-node.now.sh | bash -s --
fi

sudo npm install -g html-minifier
sudo npm install -g cssnano
sudo npm install -g cssnano-cli
sudo npm install -g uglify-js
rm -rf dist/ 
mkdir dist dist/css dist/img

html-minifier --collapse-whitespace --remove-comments --remove-optional-tags --remove-redundant-attributes --remove-script-type-attributes --minify-css true --minify-js true --input-dir ./ --output-dir dist/ --file-ext html || exit 2
cssnano css/main.css > dist/css/main.css || exit 3
cp img/* dist/img
cp _redirects dist/
cp CNAME dist/
cp brave-rewards-verification.txt dist/

export GIT_DEPLOY_DIR=dist
export GIT_DEPLOY_BRANCH=master

curl -L https://github.com/X1011/git-directory-deploy/raw/master/deploy.sh > deploy.sh
MD5=($(md5sum deploy.sh))
originalMD5=${git_directory_deploy_MD5:-ce930643d4b40f9afc54b91a890d9802}
if [[ "$MD5" == "$originalMD5" ]]
then
    sudo chmod +x deploy.sh
    bash deploy.sh -m "publish `git rev-parse HEAD` [ci skip]" || exit 4
else
    echo "Error: The MD5 hash for the deployment script did not match!"
    exit 1
fi
