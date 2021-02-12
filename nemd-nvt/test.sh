#!/usr/bin/env bash

sed -n '/Atoms/,/Bonds/p' pdata.lmp | grep '^\s*[0-9]' | grep -v "DP" | grep -i water | awk '!seen[$3]++ {print $3}' | tr '\n' ' ' | sed 's/ $//'


