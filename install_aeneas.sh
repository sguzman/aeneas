#!/bin/sh

# Aeneas (python3.6+) installation that works only for Debian distros (specifically tested for Ubuntu) and MacOS
# License: GNU GPLv3

platform='unknown'
unamestr=$(uname)
if [ "$unamestr" = 'Linux' ]; then
   platform='linux'
elif [ "$unamestr" = 'Darwin' ]; then
   platform='macos'
fi



echo "Installing git..."
if [ "$platform" = 'linux' ]; then
   os=$(awk -F= '/^NAME/{print $2}' /etc/os-release)
   if [ "$os" = 'Ubuntu']; then
       sudo apt-get install git -y
   fi
elif [ "$platform" = 'Darwin' ]; then
    brew install git

fi

echo "Cloning py3-aeneas..."
git clone https://github.com/akki2825/aeneas

echo "Entering directory..."
cd aeneas/

echo "Checking for python version..."
python_version=$(python -V 2>&1)


version=$(echo $python_version | awk '{print $2}')
# version=$(echo $python_version | cut -d' ' -f1)

if [ "$version" < 3 ]; then
    echo "Installing newest python version..."
    if [ "$platform" = 'linux' ]; then
        os=$(awk -F= '/^NAME/{print $2}' /etc/os-release)
        if [ "$os" = 'Ubuntu' ]; then
            sudo apt update && upgrade
            sudo apt install python3 python3-pip
        fi
    elif [ "$platform" = 'Darwin' ]; then
        brew install python
    fi
fi

echo "Installing dependencies..."
sudo apt-get install -y python3-dev

pip3 install numpy
pip3 install py3-aeneas

sudo python3 setup.py build_ext --inplace

echo "Checking setup..."
python3 aeneas_check_setup.py

