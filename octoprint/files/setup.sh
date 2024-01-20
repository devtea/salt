#!/bin/bash

virtualenv3 /home/octo/octoprint/venv
source /home/octo/octoprint/venv/bin/activate
pip2 install --upgrade pip
pip2 install --upgrade setuptools
pip2 install --upgrade distribute
pip2 install OctoPrint
deactivate
