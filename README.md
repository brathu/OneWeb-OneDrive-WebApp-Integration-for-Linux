<p align="center">
  <img src="https://files.catbox.moe/o397se.png" alt="OneWeb Logo" width="160"/>
</p>

<h1 align="center">OneWeb – OneDrive WebApp Integration for Linux</h1>

This project lets you open `.docx`, `.xlsx`, and `.pptx` files directly from your file manager into the **official Microsoft Office WebApps**, using `rclone` and Chrome's app mode. No sync clients, no Wine, no heavy GUI dependencies.

> ⚠️ This tool only works for files located in your OneDrive folder mounted via `rclone`. It **cannot** open local files that are not part of your OneDrive cloud storage.

![OneWeb preview screenshot](https://files.catbox.moe/ji97wl.png)

---

## ✅ Features
- Mount your OneDrive using `rclone`
- Open files directly in Word/Excel/PowerPoint Web with one click
- Works with Thunar, Nautilus, Dolphin, and any xdg-aware file manager
- Full `systemd` integration – auto-mount at login
- Dark mode in Word WebApp (native)

---

## 🧱 Dependencies

| Package               | Purpose                                   | Arch Linux Install Command               |
|-----------------------|-------------------------------------------|------------------------------------------|
| `rclone`              | Mount OneDrive & generate share links     | `sudo pacman -S rclone`                  |
| `google-chrome-stable`| Launch WebApps in app mode                | `yay -S google-chrome`                   |
| `xdg-utils`           | Required for xdg-open & MIME handling     | Usually preinstalled                     |
| `systemd` (user)      | For background mount service              | Usually preinstalled                     |

> You can also use `chromium`, `brave`, or `microsoft-edge-stable` instead of Chrome – just adjust `~/.local/bin/oneweb`.

---

## 📌 Assumptions

This installer was written for a minimal, working setup.  
It assumes that:

1. Your `rclone` remote for OneDrive is named **`onedrive`**  
   (You can check with `rclone listremotes`.)

2. Your OneDrive is mounted at **`$HOME/OneDrive`**  
   (The included systemd unit will mount it there.)

3. You have **`google-chrome-stable`** installed  
   (If you use Chromium, Brave, or Edge, edit `~/.local/bin/oneweb` after install.)

4. Your desktop environment reads `.desktop` files from  
   `~/.local/share/applications` and uses `xdg-mime` defaults.

5. You restart your file manager (e.g. `thunar -q && thunar &`)  
   after installation so the new application is picked up.

---

## 🚀 Quick Install
Save and run the installer:

```bash
curl -O https://raw.githubusercontent.com/brathu/OneWeb-OneDrive-WebApp-Integration-for-Linux/main/install-oneweb.sh
chmod +x install-oneweb.sh
./install-oneweb.sh
```

---

## 🔧 What the Installer Does
- Creates a script: `~/.local/bin/oneweb`
- Registers a `.desktop` file for Office file types
- Sets MIME defaults for `.docx`, `.xlsx`, `.pptx`
- Creates and enables a `systemd` user service to mount OneDrive

---

## 📂 File Structure
```
.local/bin/oneweb                        # Opens OneDrive files in WebApp
.local/share/applications/oneweb.desktop # MIME handler
.config/systemd/user/oneweb.mount.service # rclone mount at login
```

---

## 🧪 Example
```bash
xdg-open ~/OneDrive/Lern.docx     # opens directly in Word WebApp
xdg-open ~/OneDrive/Mappe.xlsx    # opens directly in Excel WebApp
```

---

## 🧼 Uninstall
You can run the included uninstall script:

```bash
curl -O https://raw.githubusercontent.com/brathu/OneWeb-OneDrive-WebApp-Integration-for-Linux/main/uninstall-oneweb.sh
chmod +x uninstall-oneweb.sh
./uninstall-oneweb.sh
```

Or remove manually:

```bash
systemctl --user disable --now oneweb.mount.service
rm -f ~/.local/bin/oneweb
rm -f ~/.local/share/applications/oneweb.desktop
rm -f ~/.local/share/icons/oneweb.png
rm -f ~/.config/systemd/user/oneweb.mount.service

# Restore MIME defaults (to LibreOffice as fallback)
xdg-mime default libreoffice-writer.desktop application/vnd.openxmlformats-officedocument.wordprocessingml.document
xdg-mime default libreoffice-calc.desktop application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
xdg-mime default libreoffice-impress.desktop application/vnd.openxmlformats-officedocument.presentationml.presentation
```

---

## 💡 Inspired by
[Reddit Post (Coming Soon)]() – Full setup & screenshots

---

## 🛡️ License
MIT – do what you want, just don’t abuse it.
