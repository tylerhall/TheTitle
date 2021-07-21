#!/bin/bash
find . ! -name '.DS_Store' ! -name 'renameApp.sh' ! -path '*.git*' ! -path '*Pods/*' ! -path '*.swiftpm/*' -type f -exec sed -i "" "s/DefaultApp/$1/g" {} \;
mv "DefaultApp.xcodeproj" "$1.xcodeproj"
mv "macOS/Resources/DefaultApp.sdef" "macOS/Resources/$1.sdef"
