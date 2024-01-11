git clone --depth=1 https://github.com/JaKooLit/Arch-Hyprland.git downloaded/Arch-Hyprland
chmod +x downloaded/Arch-Hyprland/install.sh
cp files/Arch-Hyprland/preset.sh downloaded/Arch-Hyprland/preset.sh

printf "${NOTE} Downloading the latest Hyprland source code release...\n"

# Fetch the tag name for the latest release using the GitHub API
latest_tag=$(curl -s https://api.github.com/repos/JaKooLit/Hyprland-Dots/releases/latest | grep "tag_name" | cut -d '"' -f 4)

# Check if the tag is obtained successfully
if [ -z "$latest_tag" ]; then
  echo -e "${ERROR} Unable to fetch the latest tag information." 2>&1 | tee -a "../Install-Logs/install-$(date +'%d-%H%M%S')_dotfiles.log"
  exit 1
fi

# Fetch the tarball URL for the latest release using the GitHub API
latest_tarball_url=$(curl -s https://api.github.com/repos/JaKooLit/Hyprland-Dots/releases/latest | grep "tarball_url" | cut -d '"' -f 4)

# Check if the URL is obtained successfully
if [ -z "$latest_tarball_url" ]; then
  echo -e "${ERROR} Unable to fetch the tarball URL for the latest release." 2>&1 | tee -a "../Install-Logs/install-$(date +'%d-%H%M%S')_dotfiles.log"
  exit 1
fi

# Get the filename from the URL and include the tag name in the file name
file_name="Hyprland-Dots-${latest_tag}.tar.gz"

# Download the latest release source code tarball to the current directory
if curl -L "$latest_tarball_url" -o "$file_name"; then
  # Extract the contents of the tarball
  tar -xzf "$file_name" || exit 1

  # delete existing Hyprland-Dots
  rm -rf JaKooLit-Hyprland-Dots

  # Identify the extracted directory
  extracted_directory=$(tar -tf "$file_name" | grep -o '^[^/]\+' | uniq)

  # Rename the extracted directory to JaKooLit-Hyprland-Dots
  mv "$extracted_directory" "downloaded/JaKooLit-Hyprland-Dots" || exit 1

  rm $file_name

  cd "downloaded/JaKooLit-Hyprland-Dots" || exit 1

  # Set execute permission for copy.sh and execute it
  chmod +x copy.sh

  echo -e "${OK} Latest Dotfiles release downloaded and extracted successfully." 2>&1
else
  echo -e "${ERROR} Failed to download the latest Dotfiles release." 2>&1
  exit 1
fi

