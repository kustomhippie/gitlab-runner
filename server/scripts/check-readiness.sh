#!/bin/bash

if /usr/bin/pgrep gitlab.*runner; then
    exit 0
else
    exit 1
fi
