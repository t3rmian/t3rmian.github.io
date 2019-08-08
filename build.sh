#!/bin/bash

npm -v || read -p "Node not found. Do you want to auto install from https://install-node.now.sh? [Yy]" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    curl -sL https://install-node.now.sh | bash -s --
fi

npm init -y
npm install html-minifier
npm install cssnano
npm install cssnano-cli
npm install uglify-js
rm -rf dist/ 
mkdir dist dist/css dist/img

html-minifier --collapse-whitespace --remove-comments --remove-optional-tags --remove-redundant-attributes --remove-script-type-attributes --remove-tag-whitespace --minify-css true --minify-js true --input-dir ./ --output-dir dist/ --file-ext html
cssnano css/main.css > dist/css/main.css
cp img/* dist/img

export GIT_DEPLOY_DIR=dist
export GIT_DEPLOY_BRANCH=master

curl -sL https://github.com/X1011/git-directory-deploy/raw/master/deploy.sh | bash -s --