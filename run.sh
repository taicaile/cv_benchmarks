#!/bin/bash

# update and upgrade
echo "Update and upgrade"
sudo apt -qq  update && sudo apt -qq upgrade -y
echo "-------------------------------------"

# check git infomation
echo "Check git configuration"
echo "git user.name : $(git config user.name)"
echo "git user.email: $(git config user.email)"
echo "current working directory: $(pwd)"
ls -a
echo "-------------------------------------"

# Check system info
echo "Check system info"
sudo apt -qq install neofetch -y
neofetch --off
echo "-------------------------------------"

# PYTHON installation
PYTHON=python3
echo "$PYTHON installation"
sudo apt -qq install $PYTHON -y
echo "python: $(which $PYTHON)"
echo "-------------------------------------"

# requirements install
echo "Requirements installation"
PIP="$PYTHON -m pip"
$PIP install pip wheel -U -q
# install requirements.txt if exists
REQUIREMENTS=requirements.txt
if [ -f "$REQUIREMENTS" ] ; then
    $PIP install -r "$REQUIREMENTS" -q
fi
echo "-------------------------------------"

# run python script
echo "run python script"
$PYTHON cv_benchmarks.py
echo "-------------------------------------"

# set git user name and email
echo "Set git user name, and email"
git config  --global user.name 'github-actions[bot]'
git config  --global user.email 'github-actions[bot]@users.noreply.github.com'

# commit index.html
INDEX=index.html
touch .nojekyll
git checkout -b gh-pages
git add .nojekyll $INDEX
git commit -m "update"

git push blog gh-pages -f

# run pre-commit
pre-commit run --files $INDEX

if [[ -n "$(git status -s | grep $INDEX)" ]]
then
    git commit -m "update at $(date)"
    git push
    echo "updates have been pushed"
else
    echo "no updates"
fi

echo "-------------------------------------"
