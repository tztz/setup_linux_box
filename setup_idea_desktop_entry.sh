#!/bin/bash

#
# This script creates a .desktop entry for IntelliJ IDEA Ultimate
# so it can be launched from the Ubuntu application menu with its icon.
#

IDEA_HOME=~/myapps/intellij/idea/idea-latest

if [[ ! -d "$IDEA_HOME" ]]; then
    echo "Error: IDEA installation not found at $IDEA_HOME"
    exit 1
fi

DESKTOP_FILE=~/.local/share/applications/intellij-idea.desktop

mkdir -p ~/.local/share/applications

cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Name=IntelliJ IDEA Ultimate
Comment=IntelliJ IDEA Ultimate Edition
Exec=$IDEA_HOME/bin/idea %f
Icon=$IDEA_HOME/bin/idea.svg
Terminal=false
Type=Application
Categories=Development;IDE;
StartupWMClass=jetbrains-idea
EOF

chmod 644 "$DESKTOP_FILE"
