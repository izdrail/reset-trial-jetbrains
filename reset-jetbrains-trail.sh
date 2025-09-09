#!/bin/bash
# Reset JetBrains trial script — mix English / Русский / 中文 vibes

echo "🚀 Starting JetBrains trial reset... 启动重置… начинаем..."

# List of JetBrains products
PRODUCTS=(IntelliJIdea WebStorm DataGrip PhpStorm CLion PyCharm GoLand RubyMine)

# Detect OS
OS="$(uname)"
echo "OS detected: $OS"

if [[ "$OS" == "Linux" ]]; then
  echo "Deleting eval dirs and properties on Linux… Удаляем eval и свойства…"
  for product in "${PRODUCTS[@]}"; do
    echo "[+] Processing $product"
    rm -rf ~/.config/"$product"*/eval 2>/dev/null
    rm -rf ~/.config/JetBrains/"$product"*/eval 2>/dev/null
    sed -i 's/evlsprt//' ~/.config/"$product"*/options/other.xml 2>/dev/null
    sed -i 's/evlsprt//' ~/.config/JetBrains/"$product"*/options/other.xml 2>/dev/null
  done
  echo "Removing user prefs… 删除用户偏好… Удаляем userPrefs…"
  rm -rf ~/.java/.userPrefs 2>/dev/null

elif [[ "$OS" == "Darwin" ]]; then
  echo "On macOS — removing plist… 在 macOS 上删除 plist… на macOS удаляем plist…"
  rm -rf ~/Library/Preferences/com.apple.java.util.prefs.plist
  # Optionally attempt XML edits similar to Linux:
  for product in "${PRODUCTS[@]}"; do
    echo "[+] macOS: Cleaning $product"
    sed -i '' 's/evlsprt//' ~/Library/Application\ Support/JetBrains/"$product"*/options/other.xml 2>/dev/null
  done

else
  echo "Unsupported OS: $OS. Only Linux or macOS supported. Только Linux или macOS. 仅支持 Linux 或 macOS."
  exit 1
fi

echo "Done! You can now click 'Start Trial'. 工作完成. Пробный запуск снова доступен. 🎉"
