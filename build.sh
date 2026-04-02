#!/bin/bash

# Build Script for HTBIP Package

# 1. Ask for the version number
read -p "Enter the version number (e.g., 1.0.1): " VERSION

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

echo -e "\n✅ Build complete: $PACKAGE_NAME"
echo "You can install it with: sudo dpkg -i $PACKAGE_NAME"
