#!/bin/bash

# update and upgrade
echo "Update and upgrade"
sudo apt -qq  update && sudo apt -qq upgrade -y
echo "-------------------------------------"

# check git infomation
echo "Check git configuration"
echo "git user.name : `git config user.name`"
echo "git user.email: `git config user.email`"
echo "current working directory: `pwd`"
echo "`ls -a`"
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
echo "python: " `which $PYTHON`
echo "-------------------------------------"

# requirements install
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
python3 pytorch_models_benchmark.py
echo "-------------------------------------"

# cat readme.md
echo "cat readme.md"
cat readme.md
echo "-------------------------------------"

# commit file
if [[ -n "${git status -s}" ]]; then
    git add readme.md
    # run pre-commit
    pre-commit run --all-files
    git add readme.md
    git commit -m "update"
fi
