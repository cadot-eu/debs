if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  echo -e "\nLance Ultimaker Cura avec prise en charge Nvidia."
  echo "Usage: ultimaker-cura.sh"
  echo "Exemple: ./ultimaker-cura.sh"
  exit 0
fi
 __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia ./Ultimaker-Cura-5.2.1-linux-modern.AppImage
