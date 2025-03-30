# Autor: GibertoDev

#!/bin/bash

# Habilita modo seguro: para execução em caso de erro crítico
set -e

# Verifica se o script está sendo executado como root
if [[ "$EUID" -ne 0 ]]; then
    echo "❌ Este script precisa ser executado como root. Use sudo!"
    exit 1
fi

echo -e "\n🛠️ Iniciando a limpeza e atualização do sistema...\n"
echo "💾 Certifique-se de salvar seu trabalho antes de continuar!"

# Aguarda 5 segundos para permitir o cancelamento
sleep 5

# Limpeza de pacotes obsoletos
echo -e "\n🗑️ Removendo pacotes desnecessários..."
apt autoclean -y && apt autoremove -y

# Atualização de pacotes do sistema
echo -e "\n⬆️ Atualizando pacotes do sistema..."
apt update && apt upgrade -y

# Atualização de pacotes Snap, se instalado
if command -v snap &> /dev/null; then
    echo -e "\n📦 Atualizando pacotes Snap..."
    snap refresh
else
    echo -e "\n⚠️ Snap não encontrado. Pulando atualização do Snap..."
fi

# Limpeza da lixeira do usuário
echo -e "\n🗑️ Esvaziando a lixeira..."
TRASH_PATHS=(
    "/home/$SUDO_USER/.local/share/Trash/files/*"
    "/home/$SUDO_USER/.local/share/Trash/files/.*"
    "/home/$SUDO_USER/.local/share/Trash/expunged/*"
    "/home/$SUDO_USER/.local/share/Trash/info/*"
)
for path in "${TRASH_PATHS[@]}"; do
    rm -rf "$path" 2>/dev/null || true
done

# Desfragmentação do sistema de arquivos (para SSDs)
echo -e "\n⚡ Otimizando o sistema de arquivos..."
fstrim --all || true

# Limpeza dos logs antigos (mantém os últimos 2 dias)
echo -e "\n📝 Removendo logs antigos..."
journalctl --vacuum-time=2d

# Mensagem final
echo -e "\n✅ Limpeza e atualização concluídas com sucesso!"

# Contagem regressiva antes de reiniciar
echo -e "\n⏳ O sistema será reiniciado em 30 segundos. Pressione Ctrl+C para cancelar."

for i in {30..1}; do
    echo -ne "\rReiniciando em ${i}s... " 
    sleep 1
done

# Reiniciar o sistema
echo -e "\n🔄 Reiniciando o sistema agora..."
shutdown -r now


