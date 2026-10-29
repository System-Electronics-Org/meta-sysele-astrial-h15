# Il demone apre /dev/watchdog e lo nutre. Entra nell'immagine solo con il ripiego A/B
# acceso (vedi core-image-hailo-dev.bbappend); senza di lui watchdog.open_timeout
# resetterebbe anche uno slot sano.
#
# Parte a S98, hailo_linux_init.sh a S99: lo slot si dichiara buono quando il demone c'e'.
INITSCRIPT_PARAMS:${PN} = "start 98 2 3 4 5 . stop 85 0 6 ."
