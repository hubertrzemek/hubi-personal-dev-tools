#!/bin/bash

EXTENSIONS_FILE="../vscode/extensions.txt"

if [ ! -f "$EXTENSIONS_FILE" ]; then
  echo "extensions.txt not found!"
  exit 1
fi

while IFS= read -r extension
do
  if [ ! -z "$extension" ]; then
    echo "Installing: $extension"
    code --install-extension "$extension"
  fi
done < "$EXTENSIONS_FILE"

echo "Done."
