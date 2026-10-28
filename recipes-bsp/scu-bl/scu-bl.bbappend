# Ripiego sull'altro slot: predisposto, spento.
#
# Hailo descrive un solo slot e mette boot_max_retries a 0xFF, che disattiva il passaggio
# a un'altra immagine. Qui la forma e' quella del ripiego, i valori di difetto lasciano il
# comportamento di oggi.
#
# Per accenderlo servono tre cose: questi due valori, lo slot B programmato (oggi
# program_spi_flash.sh scrive solo cfg_a, l'offset 0x78000 e' vuoto) e un watchdog che
# resetti quando lo user space non parte, altrimenti i tentativi non si contano.
# Il layer QBAstrial le ha tutte e tre.

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SYSELE_SCU_FALLBACK_OFFSET ?= "0x00000000"
SYSELE_SCU_BOOT_RETRIES ?= "0xFF"

SRC_URI:append:astrial-h15 = " file://scu_bl_cfg_a.json.in"

# do_install, non do_configure: e' li' che il json viene convertito in binario.
do_install:prepend:astrial-h15() {
    sed -e "s|@FALLBACK_OFFSET@|${SYSELE_SCU_FALLBACK_OFFSET}|g" \
        -e "s|@BOOT_RETRIES@|${SYSELE_SCU_BOOT_RETRIES}|g" \
        "${WORKDIR}/scu_bl_cfg_a.json.in" > "${WORKDIR}/scu_bl_cfg_a.json"
}

do_install[vardeps] += "SYSELE_SCU_FALLBACK_OFFSET SYSELE_SCU_BOOT_RETRIES"
