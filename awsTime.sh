#!/bin/bash

export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"
alias tf="terraform"

sudo hwclock -s
sudo service ntpsec restart
