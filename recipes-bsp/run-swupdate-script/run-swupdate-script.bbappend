# L'aggiornamento remoto non parte dopo un ripiego.
#
# Il SCU ricorda l'indice del descrittore attraverso i reset a caldo. Dopo un ripiego
# l'indice vale 1, e set_sw_image.sh remote_update sostituisce la lista senza azzerarlo:
# il SCU legge allora il descrittore 1 della lista nuova, che e' l'avvio normale, e la
# scheda riparte senza aggiornarsi. Il modo duale non ha il problema perche' manda gia'
# il 99 alla fine.
#
# 99 in boot_success_ap_software e' l'indicazione "swupdate completato", che azzera
# l'indice: la stessa che hailo_linux_init.sh manda dopo un aggiornamento duale.

do_install:append:astrial-h15() {
    [ "${SYSELE_SCU_AB}" = "1" ] || return 0
    sed -i 's|^\(\s*\)echo "Rebooting is about to start..."|\1echo 99 > /sys/devices/soc0/boot_info/boot_success_ap_software 2>/dev/null\n\1echo "Rebooting is about to start..."|' \
        ${D}${targetdir}/run_swupdate.sh
    grep -q 'boot_success_ap_software' ${D}${targetdir}/run_swupdate.sh || \
        bbfatal "run_swupdate.sh: punto di innesto non trovato, l'indice del descrittore non viene azzerato"
}

do_install[vardeps] += "SYSELE_SCU_AB"
