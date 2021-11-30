#!/bin/sh

# Aeneas (python3.6+) installation that works only for Debian distros (specifically tested for Ubuntu) and MacOS

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
desired_py_version=3

if [[ $version_split -lt $desired_py_version ]]; then
    echo "Installing newest python version..."
    if [ "$platform" = 'linux' ]; then
        os=$(awk -F= '/^NAME/{print $2}' /etc/os-release)
        if [ "$os" = 'Ubuntu' ]; then
            sudo apt update && upgrade
            sudo apt install python3 python3-pip
        fi
    elif [ "$platform" = 'Darwin' ]; then
        brew install python3
    fi
fi

echo "Installing dependencies..."
if [ "$platform" = 'linux' ]; then
        os=$(awk -F= '/^NAME/{print $2}' /etc/os-release)
        if [ "$os" = 'Ubuntu' ]; then
            echo "Installing Python dev dependencies..."
            sudo apt-get install -y python3-dev
            echo "Installing ffmpeg..."
            sudo apt install ffmpeg
            echo "Installing espeak..."
            sudo apt install espeak && espeak-datA
        fi
    elif [ "$platform" = 'Darwin' ]; then
        echo "Installing Python dev dependencies..."
        brew install python3-dev
        echo "Installing ffmpeg..."
        brew install ffmpeg
        echo "Installing espeak..."
        brew install espeak
fi

echo "Installing python packages..."
pip3 install numpy
pip3 install py3-aeneas

echo "Compiling Python C/C++ extensions..."
sudo python3 setup.py build_ext --inplace

echo "Checking setup..."
python3 aeneas_check_setup.py
