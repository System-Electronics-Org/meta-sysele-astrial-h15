# Ripiego sull'altro slot: predisposto, spento.
#
# La configurazione di Hailo descrive un solo slot e mette boot_max_retries a 0xFF, che
# disattiva il passaggio a un'altra immagine (OS User Guide 1.12.0, capitolo 8). Una
# scheda il cui slot parte e non arriva mai in user space resta li' per sempre.
#
# Qui la forma e' quella giusta per il ripiego, ma i valori lasciano il comportamento di
# oggi: il secondo descrittore punta allo stesso slot e i tentativi restano 0xFF.
#
# ⚠️ Non accendere senza aver prima popolato lo slot B. Su una Astrial standard
# program_spi_flash.sh scrive solo scu_bl_cfg_a: l'offset 0x00078000 e' vuoto, e un
# ripiego li' sarebbe solo un modo nuovo di non avviarsi.
#
# Per accenderlo servono tre cose insieme, non solo questa:
#   1. SYSELE_SCU_FALLBACK_OFFSET = "0x00078000" e SYSELE_SCU_BOOT_RETRIES = "0x03"
#   2. lo slot B davvero programmato
#   3. un watchdog che resetti quando lo user space non parte, altrimenti i tentativi
#      non vengono mai contati e il ripiego non scatta
# Vedi il layer QBAstrial, che li ha tutti e tre piu' qba-slot-sync per tenere la
# configurazione dello SCU allineata allo slot attivo dopo un aggiornamento.

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SYSELE_SCU_FALLBACK_OFFSET ?= "0x00000000"
SYSELE_SCU_BOOT_RETRIES ?= "0xFF"

SRC_URI:append:astrial-h15 = " file://scu_bl_cfg_a.json.in"

# do_install converte ${WORKDIR}/scu_bl_cfg_a.json in binario con
# scu_bootloader_config_manager.py: il json va riscritto prima di quel task, non prima di
# do_configure. Il file di Hailo arriva comunque in WORKDIR da SRC_URI e viene sostituito qui.
do_install:prepend:astrial-h15() {
    sed -e "s|@FALLBACK_OFFSET@|${SYSELE_SCU_FALLBACK_OFFSET}|g" \
        -e "s|@BOOT_RETRIES@|${SYSELE_SCU_BOOT_RETRIES}|g" \
        "${WORKDIR}/scu_bl_cfg_a.json.in" > "${WORKDIR}/scu_bl_cfg_a.json"
}

# Il json dipende dai due valori: senza questo, cambiarli non rifa' il binario.
do_install[vardeps] += "SYSELE_SCU_FALLBACK_OFFSET SYSELE_SCU_BOOT_RETRIES"
