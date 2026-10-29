# hailo_linux_init.sh scrive boot_success_ap_software, che dice al SCU bootloader che
# l'avvio e' riuscito. Con il ripiego A/B acceso va per ultimo, dopo il demone watchdog:
# a S50 dichiarerebbe riuscito un avvio che non ha ancora uno user space, e un reset
# successivo non verrebbe piu' contato come fallimento.
INITSCRIPT_PARAMS = "${@bb.utils.contains('SYSELE_SCU_AB', '1', 'start 99 5 .', 'start 50 5 .', d)}"
