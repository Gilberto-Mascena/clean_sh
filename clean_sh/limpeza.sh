#!/bin/bash

# Limpeza de pacotes
sudo apt autoclean -y && sudo apt autoremove -y

# Atualização de pacotes
sudo apt update && sudo apt upgrade -y

# Atualização de pacotes Snap
sudo snap refresh

# Limpeza da lixeira do usuário
sudo rm -rf /home/$USER/.local/share/Trash/files/*
sudo rm -rf /home/$USER/.local/share/Trash/expunged/*
sudo rm -rf /home/$USER/.local/share/Trash/info/*

# Desfragmentação do sistema de arquivos
sudo /sbin/fstrim --all || true

# Limpeza dos logs do sistema
sudo journalctl --vacuum-time=2d

# Contagem regressiva para reiniciar o sistema
for i in {30..0}; do
    clear
    echo "Limpeza e atualização concluída!"
    echo "O sistema será reiniciado em ${i} segundos..."
    sleep 1
done

# Reiniciar o sistema
sudo shutdown -r now

