#!/bin/bash

# 1. Configuração dos Remotes (Executar apenas se não existirem)
if ! git remote | grep -q "^origin$"; then
    git remote add origin https://github.com/pviniks/htbip-manager.git
fi
if ! git remote | grep -q "^backup$"; then
    git remote add backup https://github.com/pviniks/htbip-manager-backup-private.git
fi

# 2. Pedir o comentário do commit
echo -n "📝 Enter commit message: "
read COMMIT_MSG

if [ -z "$COMMIT_MSG" ]; then
    echo "❌ Error: Commit message cannot be empty."
    exit 1
fi

# --- PARTE 1: REPOSITÓRIO PÚBLICO (LIMPO) ---
echo -e "\n🌐 Preparing Public Repository..."
git add .
git commit -m "$COMMIT_MSG"
git push origin main --force

# --- PARTE 2: REPOSITÓRIO PRIVADO (COMPLETO) ---
echo -e "\n☁️  Preparing Private Backup (Full)..."
# Usamos o 'add -f' para incluir o que o gitignore normalmente barraria
git add . -A -f
# Fazemos um 'amend' ou um novo commit apenas para o backup
git commit --amend -m "$COMMIT_MSG [FULL BACKUP]" --no-edit
# Enviamos para o repositório de backup
git push backup main --force

# --- FINALIZAÇÃO ---
# Voltamos o estado local para "limpo" para não confundir o Git no próximo uso
git rm -r --cached usr/ pkg_build/ *.deb DEBIAN/ 2>/dev/null
git commit -m "Reset state for next sync" --no-edit

echo -e "\n✨ ALL DONE!"
echo "✅ Public: https://github.com/pviniks/htbip-manager (Clean)"
echo "✅ Private: https://github.com/pviniks/htbip-private-backup (Full)"
