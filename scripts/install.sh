#!/bin/bash

# Install XDS exec

DESTDIR=${DESTDIR:-/opt/AGL/xds/exec}

ROOT_SRCDIR=$(cd $(dirname "$0")/.. && pwd)

install() {
    mkdir -p ${DESTDIR} && cp ${ROOT_SRCDIR}/bin/* ${DESTDIR} || exit 1

    cp ${ROOT_SRCDIR}/conf.d/etc/xds-exec /etc/ || exit 1
    cp ${ROOT_SRCDIR}/conf.d/etc/default/xds-exec /etc/default/ || exit 1

    FILE=/etc/profile.d/xds-exec.sh
    sed -e "s;%%XDS_INSTALL_BIN_DIR%%;${DESTDIR};g" ${ROOT_SRCDIR}/conf.d/${FILE} > ${FILE} || exit 1
}

uninstall() {
    rm -rf "${DESTDIR}"
    rm -f /etc/profile.d/xds-exec.sh
}

if [ "$1" == "uninstall" ]; then
    echo -n "Are-you sure you want to remove ${DESTDIR} [y/n]? "
    read answer
    if [ "${answer}" = "y" ]; then
        uninstall
        echo "xds-exec sucessfully uninstalled."
    else
        echo "Uninstall canceled."
    fi
else
    install
fi
