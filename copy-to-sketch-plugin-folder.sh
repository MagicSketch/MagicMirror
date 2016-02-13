#!/bin/bash

# Copy As Normal Install
# cp -r MagicMirror2.sketchplugin ~/Library/Application\ Support/com.bohemiancoding.sketch3/Plugins/

# Copy As Sketch Toolbox
rm -rf ~/Library/Application\ Support/com.bohemiancoding.sketch3/Plugins/Magicmirror
mkdir ~/Library/Application\ Support/com.bohemiancoding.sketch3/Plugins/Magicmirror
cp -r MagicMirror2.sketchplugin ~/Library/Application\ Support/com.bohemiancoding.sketch3/Plugins/Magicmirror/