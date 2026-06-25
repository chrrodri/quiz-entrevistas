#!/bin/bash

sudo hwclock -s
sudo service ntpsec restart
export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"
alias tf="terraform"