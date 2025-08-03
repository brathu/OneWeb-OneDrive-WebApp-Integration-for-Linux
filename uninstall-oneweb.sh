#!/bin/bash

echo "🧼 Uninstalling OneWeb..."

# Stop systemd service
systemctl --user disable --now oneweb.mount.service

# Remove files
rm -f ~/.local/bin/oneweb
rm -f ~/.local/share/applications/oneweb.desktop
rm -f ~/.local/share/icons/oneweb.png
rm -f ~/.config/systemd/user/oneweb.mount.service

# Restore MIME defaults (to LibreOffice as fallback)
xdg-mime default libreoffice-writer.desktop application/vnd.openxmlformats-officedocument.wordprocessingml.document
xdg-mime default libreoffice-calc.desktop application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
xdg-mime default libreoffice-impress.desktop application/vnd.openxmlformats-officedocument.presentationml.presentation

# Update databases
update-desktop-database ~/.local/share/applications/

echo "✅ OneWeb has been completely removed."

