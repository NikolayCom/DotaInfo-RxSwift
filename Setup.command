#!/bin/sh

cd "$(dirname "$0")"

#generation
xcodegen generate

#pods
sh PodInstall.command

#resorces
swiftgen config lint
swiftgen

pod install --repo-update
