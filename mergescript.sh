#!/usr/bin/env bash

git checkout maintenance
git pull
git checkout promotion-1610
git pull
git merge remotes/origin/maintenance


