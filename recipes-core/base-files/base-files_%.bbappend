# Set custom hostname for Astrial H15 board
# System Electronics customization

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

# Force hostname to be set correctly
do_install:append() {
    echo "astrialh15" > ${D}${sysconfdir}/hostname

    # /boot nel fstab: la riga la mette wic, quindi il rootfs grezzo dello .swu ne resta
    # senza e dopo un aggiornamento /boot non e' montato. Per etichetta perche' l'UUID lo
    # genera wic. nofail: un /boot non montabile non deve impedire l'avvio.
    echo "LABEL=boot           /boot                vfat       defaults,nofail       0  0" \
        >> ${D}${sysconfdir}/fstab
}