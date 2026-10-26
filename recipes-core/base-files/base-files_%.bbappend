# Set custom hostname for Astrial H15 board
# System Electronics customization

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

# Force hostname to be set correctly
do_install:append() {
    echo "astrialh15" > ${D}${sysconfdir}/hostname

    # /boot nel fstab. La riga la aggiunge wic, quindi il rootfs grezzo dello SWU ne
    # resta senza e dopo un aggiornamento /boot e' vuoto: la partizione e il fitImage
    # ci sono, ma non sono montati.
    #
    # wic usa l'UUID della partizione, generato a ogni build e quindi non scrivibile
    # qui. L'etichetta la mette il nostro wks (--label boot) ed e' stabile. nofail
    # perche' un /boot non montabile non deve impedire l'avvio.
    echo "LABEL=boot           /boot                vfat       defaults,nofail       0  0" \
        >> ${D}${sysconfdir}/fstab
}