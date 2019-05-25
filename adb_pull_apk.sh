#!/usr/bin/env bash

pkg_name="$(~/Android/Sdk/platform-tools/adb shell pm list packages | grep "$@" | head -n1 | sed 's#package:##g' | tr '\r' '\n' | sed 's#\n##g')"
echo "package name:$pkg_name"

pkg_path="$(~/Android/Sdk/platform-tools/adb shell pm path $pkg_name | head -n1 | sed 's#package:##g' | tr '\r' '\n' | sed 's#\n##g')"
echo "package path: $pkg_path"

#~/Android/Sdk/platform-tools/adb shell cat "$pkg_path" > base.apk
~/Android/Sdk/platform-tools/adb pull "$pkg_path"

