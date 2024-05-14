#!/bin/bash

find . -type f -name ".terraform.lock.hcl" -prune -exec rm -rf {} \;
find . -type d -name ".terragrunt-cache" -prune -exec rm -rf {} \;
find . -type f -name "terragrunt-debug.tfvars.json" -prune -exec rm -rf {} \;