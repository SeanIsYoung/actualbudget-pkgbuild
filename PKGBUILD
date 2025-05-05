# Based off of: https://daveparrish.net/posts/2019-11-16-Better-AppImage-PKGBUILD-template.html
# Maintainer: Paul Sauve <paul@technove.co>

_pkgname=actual
_Pkgname=Actual

pkgname=${_pkgname}-appimage
pkgver=v25.5.0
pkgrel=1
pkgdesc="Actual Budget is a local-first personal finance tool. It is 100% free and open-source, written in NodeJS, it has a synchronization element so that all your changes can move between devices without any heavy lifting."
arch=('x86_64')
url="https://actualbudget.org/"
license=('MIT')
depends=('zlib' 'hicolor-icon-theme')
options=(!strip)
_appimage="${_Pkgname}-linux-${arch}.AppImage"
source_x86_64=("${_appimage}::https://github.com/actualbudget/${_pkgname}/releases/download/${pkgver}/${_appimage}")
noextract=("${_appimage}")
sha256sums_x86_64=('3450bb2b19a32ea7f07e72d19037387acb8064cc1b1595626ff7bfe99f65d3bc')

prepare() {
    chmod +x "${_appimage}"
    ./"${_appimage}" --appimage-extract

    # Fix desktop entry to use a unique icon name
    sed -i -E \
        -e "s|Exec=AppRun|Exec=env DESKTOPINTEGRATION=false /usr/bin/${_pkgname}|" \
        -e "s|Icon=desktop-electron|Icon=actual-budget|" \
        "squashfs-root/desktop-electron.desktop"

    # Rename all 'desktop-electron.png' icons to 'actual-budget.png' across all sizes
    find squashfs-root/usr/share/icons/hicolor -type f -name 'desktop-electron.png' | while read -r icon_path; do
        dir=$(dirname "$icon_path")
        mv "$icon_path" "$dir/actual-budget.png"
    done

    # Fix permissions
    chmod -R a-x+rX squashfs-root/usr
}

build() {
    true
#     # Adjust .desktop so it will work outside of AppImage container
#     sed -i -E "s|Exec=AppRun|Exec=env DESKTOPINTEGRATION=false /usr/bin/${_pkgname}|"\
#         "squashfs-root/desktop-electron.desktop"
#     # Fix permissions; .AppImage permissions are 700 for all directories
#     chmod -R a-x+rX squashfs-root/usr
}

package() {
    # AppImage
    install -Dm755 "${srcdir}/${_appimage}" "${pkgdir}/opt/${_pkgname}/${_Pkgname}.AppImage"

    # Desktop file
    install -Dm644 "${srcdir}/squashfs-root/desktop-electron.desktop"\
            "${pkgdir}/usr/share/applications/${_pkgname}.desktop"

    # Icon images
    install -dm755 "${pkgdir}/usr/share/"
    cp -a "${srcdir}/squashfs-root/usr/share/icons" "${pkgdir}/usr/share/"

    # Symlink executable
    install -dm755 "${pkgdir}/usr/bin"
    ln -s "/opt/${_pkgname}/${_Pkgname}.AppImage" "${pkgdir}/usr/bin/${_pkgname}"
}
