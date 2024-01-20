#!/bin/bash

python3 -m venv /home/octo/octoprint/venv
source /home/octo/octoprint/venv/bin/activate
python3 -m pip install --upgrade pip
python3 -m pip install --upgrade setuptools
python3 -m pip install --upgrade distribute
python3 -m pip install OctoPrint
deactivate
