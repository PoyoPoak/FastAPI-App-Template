#!/bin/bash

# Create virtual environment
python -m venv venv

# Activate virtual environment
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    source venv/Scripts/activate
else
    source venv/bin/activate
fi

# Upgrade pip
pip install --upgrade pip

# Install wheel and setuptools
pip install wheel setuptools

echo "Virtual environment setup complete!"
echo "To activate the environment, run: source venv/Scripts/activate (Windows) or source venv/bin/activate (Unix)"