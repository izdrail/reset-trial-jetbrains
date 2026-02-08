#!/bin/bash

################################################################################
# JetBrains Trial Reset Script v4.0 - STREAMLINED
# Focused cleanup of core JetBrains config locations only
# No unnecessary project folder searching
################################################################################

set -o pipefail

RESET_COUNT=0

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}JetBrains Trial Reset Script v4.0${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

OS="$(uname)"
echo "Detected OS: $OS"
echo ""

# ============================================================================
# HELPER FUNCTIONS
# ============================================================================

# Safely remove files/directories
safe_remove() {
  local path="$1"
  if [ -e "$path" ] 2>/dev/null; then
    rm -rf "$path" 2>/dev/null && ((RESET_COUNT++)) && echo -e "${GREEN}✓${NC} $path"
    return 0
  fi
}

# Clean XML/config files - remove lines matching patterns
clean_config_files() {
  local search_dir="$1"
  
  if [ ! -d "$search_dir" ] 2>/dev/null; then
    return
  fi
  
  while IFS= read -r -d '' file; do
    local modified=0
    # Remove lines containing evaluation/trial markers
    if grep -q "eval\|trial\|expir\|license.*key" "$file" 2>/dev/null; then
      if [[ "$OS" == "Darwin" ]]; then
        sed -i '' '/eval\|trial\|expir\|license.*key/d' "$file" 2>/dev/null && modified=1
      else
        sed -i '/eval\|trial\|expir\|license.*key/d' "$file" 2>/dev/null && modified=1
      fi
    fi
    if [ $modified -eq 1 ]; then
      ((RESET_COUNT++))
      echo -e "${GREEN}✓${NC} Cleaned: $(basename "$file")"
    fi
  done < <(find "$search_dir" -type f \( -name "*.xml" -o -name "*.properties" \) -print0 2>/dev/null)
}

# ============================================================================
# LINUX CLEANUP
# ============================================================================
if [[ "$OS" == "Linux" ]]; then
  echo -e "${YELLOW}[Linux Cleanup]${NC}"
  echo ""
  
  # Core JetBrains config locations
  echo -e "${BLUE}Removing JetBrains config directories:${NC}"
  safe_remove "$HOME/.config/JetBrains"
  safe_remove "$HOME/.cache/JetBrains"
  safe_remove "$HOME/.local/share/JetBrains"
  
  # Hidden IDE directories
  echo -e "${BLUE}Removing hidden IDE directories:${NC}"
  safe_remove "$HOME/.idea"
  safe_remove "$HOME/.jba"
  safe_remove "$HOME/.jetbrains"
  
  # Java preferences
  echo -e "${BLUE}Removing Java/evaluation markers:${NC}"
  safe_remove "$HOME/.java"
  safe_remove "$HOME/.consentOptions"
  
  # Clean any remaining cache
  echo -e "${BLUE}Cleaning remaining caches:${NC}"
  find "$HOME/.cache" -maxdepth 1 -type d -name "*jetbrains*" -o -name "*intellij*" 2>/dev/null | while read -r dir; do
    safe_remove "$dir"
  done

# ============================================================================
# MACOS CLEANUP
# ============================================================================
elif [[ "$OS" == "Darwin" ]]; then
  echo -e "${YELLOW}[macOS Cleanup]${NC}"
  echo ""
  
  # Core JetBrains locations
  echo -e "${BLUE}Removing JetBrains Application Support:${NC}"
  safe_remove "$HOME/Library/Application Support/JetBrains"
  
  # Caches
  echo -e "${BLUE}Removing JetBrains caches:${NC}"
  find "$HOME/Library/Caches" -maxdepth 1 -type d \( -name "*JetBrains*" -o -name "*IntelliJ*" -o -name "*PyCharm*" -o -name "*WebStorm*" -o -name "*DataGrip*" -o -name "*CLion*" -o -name "*PhpStorm*" -o -name "*GoLand*" -o -name "*RubyMine*" -o -name "*Rider*" -o -name "*Fleet*" \) 2>/dev/null | while read -r dir; do
    safe_remove "$dir"
  done
  
  # Preferences/Plist files
  echo -e "${BLUE}Removing JetBrains preferences:${NC}"
  find "$HOME/Library/Preferences" -type f \( -name "com.jetbrains*" -o -name "jetbrains*" \) 2>/dev/null | while read -r plist; do
    safe_remove "$plist"
  done
  safe_remove "$HOME/Library/Preferences/com.apple.java.util.prefs.plist"
  
  # Saved application state
  echo -e "${BLUE}Removing saved application state:${NC}"
  find "$HOME/Library/Saved Application State" -type d -name "com.jetbrains*" 2>/dev/null | while read -r state; do
    safe_remove "$state"
  done
  
  # Cookies
  echo -e "${BLUE}Removing JetBrains cookies:${NC}"
  find "$HOME/Library/Cookies" -type f -name "*jetbrains*" 2>/dev/null | while read -r cookie; do
    safe_remove "$cookie"
  done
  
  # Hidden directories
  echo -e "${BLUE}Removing hidden IDE directories:${NC}"
  safe_remove "$HOME/.idea"
  safe_remove "$HOME/.jba"
  safe_remove "$HOME/.jetbrains"

# ============================================================================
# WINDOWS CLEANUP
# ============================================================================
elif [[ "$OS" == "MINGW64_NT"* ]] || [[ "$OS" == "MSYS"* ]] || [[ "$OS" == "CYGWIN"* ]]; then
  echo -e "${YELLOW}[Windows Cleanup]${NC}"
  echo ""
  
  APPDATA="${APPDATA:-$HOME/AppData/Roaming}"
  LOCALAPPDATA="${LOCALAPPDATA:-$HOME/AppData/Local}"
  
  # Core JetBrains locations
  echo -e "${BLUE}Removing JetBrains from AppData/Roaming:${NC}"
  safe_remove "$APPDATA/JetBrains"
  
  echo -e "${BLUE}Removing JetBrains from AppData/Local:${NC}"
  safe_remove "$LOCALAPPDATA/JetBrains"
  safe_remove "$LOCALAPPDATA/Temp/JetBrains"
  
  # Hidden directories
  echo -e "${BLUE}Removing hidden IDE directories:${NC}"
  safe_remove "$HOME/.idea"
  safe_remove "$HOME/.jba"
  safe_remove "$HOME/.jetbrains"
  
  echo ""
  echo -e "${YELLOW}Registry Cleanup (Windows):${NC}"
  echo "For complete cleanup, run these in PowerShell as Administrator:"
  echo ""
  echo "  reg delete \"HKCU\\Software\\JavaSoft\\Prefs\\jetbrains\" /f /s"
  echo "  reg delete \"HKCU\\Software\\JetBrains\" /f /s"
  echo ""

else
  echo -e "${RED}Unsupported OS: $OS${NC}"
  exit 1
fi

# ============================================================================
# SUMMARY
# ============================================================================
echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}✓ Trial Reset Complete!${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo "Items cleaned: $RESET_COUNT"
echo ""
echo -e "${YELLOW}NEXT STEPS:${NC}"
echo "1. Close ALL JetBrains IDEs completely"
if [[ "$OS" == "Linux" ]]; then
  echo "   killall java 2>/dev/null"
elif [[ "$OS" == "Darwin" ]]; then
  echo "   killall -9 java 2>/dev/null"
elif [[ "$OS" == "MINGW64_NT"* ]] || [[ "$OS" == "MSYS"* ]]; then
  echo "   taskkill /F /IM java.exe 2>/dev/null"
fi
echo ""
echo "2. Restart your IDE"
echo ""
echo "3. You should now see 'Start Trial' instead of 'Trial Expired'"
echo ""
echo -e "${YELLOW}Still not working?${NC}"
echo "• Check: Help → Register → Use offline activation"
echo "• Completely uninstall and reinstall the IDE"
echo "• JetBrains may verify online (requires valid account)"
echo ""