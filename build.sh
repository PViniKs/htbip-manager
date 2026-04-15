#!/bin/bash

# Build Script for HTBIP Package

# 1. Auto-detect the next version number
# Busca a versão atual registrada no arquivo de controle
CURRENT_VERSION=$(grep "Version:" debian/control | awk '{print $2}')

# Separa a versão em partes (ex: 1.0.4 -> Major=1, Minor=0, Patch=4)
MAJOR=$(echo $CURRENT_VERSION | cut -d. -f1)
MINOR=$(echo $CURRENT_VERSION | cut -d. -f2)
PATCH=$(echo $CURRENT_VERSION | cut -d. -f3)

# Calcula a próxima versão (soma 1 ao último número)
NEXT_PATCH=$((PATCH + 1))
SUGGESTED_VERSION="${MAJOR}.${MINOR}.${NEXT_PATCH}"

# Mostra a sugestão e permite que você apenas dê ENTER ou digite uma nova
echo "Current version detected: $CURRENT_VERSION"
read -p "Enter version number [Default: $SUGGESTED_VERSION]: " VERSION

# Se você apenas apertar ENTER, ele usa a sugerida automaticamente
VERSION=${VERSION:-$SUGGESTED_VERSION}

echo "🚀 Building version: $VERSION"

# 2. Update the version in the debian/control file automatically
sed -i "s/^Version:.*/Version: $VERSION/" debian/control

# 3. Create/Clean the temporary build structure
# We use a temporary folder 'pkg_build' to not mess with your 'usr' folder
rm -rf pkg_build
mkdir -p pkg_build/DEBIAN
mkdir -p pkg_build/usr/bin

# 4. Copying files from your source folders
cp src/htbip pkg_build/usr/bin/
cp debian/* pkg_build/DEBIAN/

# 5. Setting correct permissions (Critical for dpkg-deb)
chmod 755 pkg_build/DEBIAN/postinst
chmod 755 pkg_build/usr/bin/htbip

# 6. Building the .deb package
PACKAGE_NAME="htbip_${VERSION}_all.deb"
dpkg-deb --build pkg_build "$PACKAGE_NAME"

# 7. Cleanup
rm -rf pkg_build

# --- RELEASE SECTION ---
echo -e "\n"
read -p "🚀 Do you want to push this as a GitHub Release? (y/n): " CONFIRM
if [ "$CONFIRM" = "y" ]; then
    # Usa a versão que acabamos de definir para a tag
    V_TAG="$VERSION"
    FILE_NAME="htbip_${V_TAG}_all.deb"

    echo "Uploading v$V_TAG to GitHub..."
    gh release create "v$V_TAG" "$FILE_NAME" --title "Release v$V_TAG" --notes "Automated build for version $V_TAG"
else
    echo "Skipping GitHub release."
fi

echo -e "\n✅ Build complete: $PACKAGE_NAME"
echo "You can install it with: sudo dpkg -i $PACKAGE_NAME"
