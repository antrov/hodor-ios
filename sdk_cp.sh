#!/bin/bash

sudo cp -r /Volumes/Xcode/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/DeviceSupport/7.* /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/DeviceSupport/
sudo cp -r /Volumes/Xcode/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/* /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/
sudo /usr/libexec/PlistBuddy -c "Set :MinimumSDKVersion 8.0" /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Info.plist