#!/bin/bash
set -e

make maccat-debug

MACOSX_SDK_DIR=$(xcrun --show-sdk-path)
clang++ -o libMoltenVK.dylib \
  -dynamiclib \
  -g \
  -isysroot $MACOSX_SDK_DIR\
  -isystem $MACOSX_SDK_DIR/System/iOSSupport/usr/include \
  -iframework $MACOSX_SDK_DIR/System/iOSSupport/System/Library/Frameworks \
  -target arm64-apple-ios14.0-macabi \
  -framework Metal \
  -framework UIKit \
  -framework IOSurface \
  -framework QuartzCore \
  -framework CoreGraphics \
  -framework Foundation \
  -framework IOKit \
  -Wl,-all_load \
  Package/Latest/MoltenVK/MoltenVK.xcframework/ios-arm64_x86_64-maccatalyst/libMoltenVK.a

out=/Applications/PojavLauncher.app/Frameworks/
dsymutil libMoltenVK.dylib
sudo mv libMoltenVK.dylib $out
sudo ldid -S $out/libMoltenVK.dylib
