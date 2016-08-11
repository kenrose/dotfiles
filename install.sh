#!/bin/bash

# Bash Files
for file in .{path,bash_prompt,bashrc,bash_profile,exports,aliases,functions,extra}; do
  [ -r "$file" ] && [ -f "$file" ] && ln -sv "$PWD/$file" "$HOME/"
done;
unset file;
