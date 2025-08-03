#!/bin/bash

set -e

echo "[+] Installing OneWeb..."

# 1. Prepare directories
mkdir -p ~/.local/bin
mkdir -p ~/.local/share/applications
mkdir -p ~/.config/systemd/user
mkdir -p ~/.local/share/icons

# 2. Install OneWeb script
cat > ~/.local/bin/oneweb <<'EOF'
#!/bin/bash
FULL_PATH="$1"
REL_PATH="${FULL_PATH#"$HOME/OneDrive/"}"
URL=$(rclone link "onedrive:$REL_PATH")
exec google-chrome-stable --app="$URL"
EOF

chmod +x ~/.local/bin/oneweb

# 3. Download OneWeb icon
echo "[+] Downloading icon..."
curl -L https://files.catbox.moe/o397se.png -o ~/.local/share/icons/oneweb.png

# 4. Create .desktop entry
cat > ~/.local/share/applications/oneweb.desktop <<'EOF'
[Desktop Entry]
Name=OneWeb Link-Opener
Exec=/home/$USER/.local/bin/oneweb %f
MimeType=application/vnd.openxmlformats-officedocument.wordprocessingml.document;
        application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;
        application/vnd.openxmlformats-officedocument.presentationml.presentation;
Icon=oneweb
Type=Application
NoDisplay=true
EOF

# 5. Set MIME type defaults
xdg-mime default oneweb.desktop application/vnd.openxmlformats-officedocument.wordprocessingml.document
xdg-mime default oneweb.desktop application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
xdg-mime default oneweb.desktop application/vnd.openxmlformats-officedocument.presentationml.presentation

# 6. Create systemd service for rclone mount
cat > ~/.config/systemd/user/oneweb.mount.service <<'EOF'
[Unit]
Description=Mount OneDrive via rclone (manual refresh)
After=network-online.target
Wants=network-online.target

[Service]
Type=notify
ExecStart=/usr/bin/rclone mount onedrive: %h/OneDrive \
  --vfs-cache-mode writes \
  --vfs-cache-max-size 100M \
  --vfs-cache-max-age 30m \
  --dir-cache-time 999h \
  --buffer-size 32M \
  --vfs-read-chunk-size 64M \
  --vfs-read-chunk-size-limit 512M \
  --umask 002 \
  --uid=%U \
  --gid=%G
ExecStop=/bin/fusermount -u %h/OneDrive
Restart=on-failure
TimeoutSec=30

[Install]
WantedBy=default.target
EOF

# 7. Enable and start systemd service
systemctl --user daemon-reload
systemctl --user enable --now oneweb.mount.service

# 8. (Optional) GTK icon cache update
if command -v gtk-update-icon-cache &> /dev/null; then
  gtk-update-icon-cache ~/.local/share/icons &> /dev/null || true
fi

echo "[✓] OneWeb installed successfully!"
echo "➡️  Open a .docx/.xlsx/.pptx file in ~/OneDrive to launch it in the WebApp."

