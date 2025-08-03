#!/bin/bash

echo "🔧 Installing OneWeb..."

# Directories
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.local/share/applications"
mkdir -p "$HOME/.config/systemd/user"
mkdir -p "$HOME/.local/share/icons"

# Main oneweb script
cat > "$HOME/.local/bin/oneweb" << 'EOF'
#!/bin/bash
FULL_PATH="$1"
REL_PATH="${FULL_PATH#"$HOME/OneDrive/"}"
URL=$(rclone link "onedrive:$REL_PATH")
exec google-chrome-stable --app="$URL"
EOF

chmod +x "$HOME/.local/bin/oneweb"

# .desktop file
cat > "$HOME/.local/share/applications/oneweb.desktop" << EOF
[Desktop Entry]
Name=OneWeb Link-Opener
Exec=$HOME/.local/bin/oneweb %f
MimeType=application/vnd.openxmlformats-officedocument.wordprocessingml.document;application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;application/vnd.openxmlformats-officedocument.presentationml.presentation;
Icon=oneweb
Type=Application
NoDisplay=false
EOF

# systemd mount unit
cat > "$HOME/.config/systemd/user/oneweb.mount.service" << EOF
[Unit]
Description=Mount OneDrive via rclone (manual refresh)
After=network-online.target
Wants=network-online.target

[Service]
Type=notify
ExecStart=/usr/bin/rclone mount onedrive: %h/OneDrive \\
  --vfs-cache-mode writes \\
  --vfs-cache-max-size 100M \\
  --vfs-cache-max-age 30m \\
  --dir-cache-time 999h \\
  --buffer-size 32M \\
  --vfs-read-chunk-size 64M \\
  --vfs-read-chunk-size-limit 512M \\
  --umask 002 \\
  --uid=%U \\
  --gid=%G
ExecStop=/bin/fusermount -u %h/OneDrive
Restart=on-failure
TimeoutSec=30

[Install]
WantedBy=default.target
EOF

# Icon
curl -sL https://files.catbox.moe/o397se.png -o "$HOME/.local/share/icons/oneweb.png"

# MIME bindings
xdg-mime default oneweb.desktop application/vnd.openxmlformats-officedocument.wordprocessingml.document
xdg-mime default oneweb.desktop application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
xdg-mime default oneweb.desktop application/vnd.openxmlformats-officedocument.presentationml.presentation

# Refresh desktop entry cache
update-desktop-database "$HOME/.local/share/applications/"

# Enable systemd user service
systemctl --user enable --now oneweb.mount.service

echo "✅ OneWeb installed successfully."
