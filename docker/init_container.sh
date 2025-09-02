#!/bin/bash
# DevMob - React Native Development Environment (https://github.com/JMVilomet/devmob)
echo "Installing global dependencies..."
sudo npm install -g expo expo-cli eas-cli @react-native-community/cli

echo "Verifying installations..."
echo "✓ Expo CLI: $(expo --version 2>/dev/null || echo 'Failed')"
echo "✓ React Native CLI: $(npx react-native --version 2>/dev/null || echo 'Failed')"

echo "Container Started and ready for development."
tail -f /dev/null
