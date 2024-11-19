#!/usr/bin/env bash

for resource in $(tofu state list | rg "$1");
do
    tofu state show "$resource"
done
