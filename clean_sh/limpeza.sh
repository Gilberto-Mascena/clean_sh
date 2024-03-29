sudo apt autoclean -y && sudo apt autoremove -y
sudo apt update && sudo apt upgrade -y
sudo snap refresh
sudo rm -rf /home/$USER/.local/share/Trash/files/*
sudo rm -rf /home/$USER/.local/share/Trash/files/.*
sudo rm -rf /home/$USER/.local/share/Trash/expunged/*
sudo rm -rf /home/$USER/.local/share/Trash/info/*
sudo /sbin/fstrim --all || true
sudo journalctl --vacuum-time=2d
