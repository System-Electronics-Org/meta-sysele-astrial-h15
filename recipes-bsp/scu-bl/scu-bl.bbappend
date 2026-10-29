# Ripiego sull'altro slot: predisposto, spento.
#
# Hailo descrive un solo slot e mette boot_max_retries a 0xFF, che disattiva il passaggio
# a un'altra immagine. Qui la forma e' quella del ripiego, i valori di difetto lasciano il
# comportamento di oggi: con 0x00000000, 0xFF e 0 i due json generati sono identici a
# quelli di Hailo.
#
# Accenderlo vuol dire dare un valore a queste tre variabili, per esempio 0x00078000,
# 0x02 e 2: cosi' le liste diventano A,B,A e B,A,B, le stesse collaudate su QBAstrial.
# Il resto segue da solo (sysele-slot-sync, watchdog, ordine di hailo_linux_init).
# Resta da fare a mano una cosa: programmare davvero lo slot B, perche'
# program_spi_flash.sh scrive solo l'immagine su 0x0.

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# I valori di difetto stanno in conf/machine/astrial-h15.conf, cosi' li vede
# anche l'immagine e l'interruttore resta uno solo.

SRC_URI:append:astrial-h15 = " file://scu_bl_cfg_a.json.in file://scu_bl_cfg_b.json.in"

# do_install, non do_configure: e' li' che il json viene convertito in binario.
do_install:prepend:astrial-h15() {
    for slot in a b; do
        sed -e "s|@FALLBACK_OFFSET@|${SYSELE_SCU_FALLBACK_OFFSET}|g" \
            -e "s|@BOOT_RETRIES@|${SYSELE_SCU_BOOT_RETRIES}|g" \
            -e "s|@LAST_VALID_DESC@|${SYSELE_SCU_LAST_VALID_DESC}|g" \
            "${WORKDIR}/scu_bl_cfg_$slot.json.in" > "${WORKDIR}/scu_bl_cfg_$slot.json"
    done
}

do_install[vardeps] += "SYSELE_SCU_FALLBACK_OFFSET SYSELE_SCU_BOOT_RETRIES SYSELE_SCU_LAST_VALID_DESC"
