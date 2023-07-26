#!/bin/sh

cd "$(dirname "$0")"
pod deintegrate && pod cache clean --all
pod update
