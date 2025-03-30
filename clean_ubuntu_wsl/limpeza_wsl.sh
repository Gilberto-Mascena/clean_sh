#!/bin/bash

# Habilita modo seguro: interrompe a execução em erros críticos
set -e

# Verifica se o script está sendo executado como root
if [[ "$EUID" -ne 0 ]]; then 
    echo "❌ Este script precisa ser executado como root. Use sudo!"
    exit 1
fi

echo "🛠️ Iniciando a limpeza e atualização do sistema..."
echo "💾 Certifique-se de salvar seu trabalho antes de continuar!"

# Aguarda 5 segundos para permitir o cancelamento
sleep 5

# Limpeza de pacotes obsoletos
echo "🗑️ Removendo pacotes desnecessários..."
apt autoclean -y && apt autoremove -y

# Atualização de pacotes
echo "⬆️ Atualizando pacotes do sistema..."
apt update && apt upgrade -y

# Atualização de pacotes Snap
if command -v snap &> /dev/null; then 
    echo "📦 Atualizando pacotes Snap..."
    snap refresh
else 
    echo "⚠️ Snap não encontrado. Pulando atualização do Snap..."   
fi

# Limpeza da lixeira do usuário
echo "🗑️ Esvaziando a lixeira..."
TRASH_PATHS=( 
    "/home/$SUDO_USER/.local/share/Trash/files/*"
    "/home/$SUDO_USER/.local/share/Trash/expunged/*"
    "/home/$SUDO_USER/.local/share/Trash/info/*"
)
for path in "${TRASH_PATHS[@]}"; do 
    rm -rf "$path" || true
done

# Desfragmentação do sistema de arquivos (SSD-friendly)
echo "\n⚡ Otimizando o sistema de arquivos..."
fstrim --all || true 

# Limpeza de logs antigos (mantém os últimos 2 dias)
echo "📝 Removendo logs antigos..."
journalctl --vacuum-time=2d 

echo -e "\n✅ Limpeza e atualização concluídas com sucesso!"
