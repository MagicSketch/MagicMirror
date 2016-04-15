#!/bin/sh

rm -rf MagicMirror*
rm -rf Pods
git merge --no-ff "$1"
git checkout "$1" MagicMirror2.sketchplugin 
rm -rf MagicMirrorTest*
rm -rf MagicMirror/*
git add .
