# L'init di swupdate-image e' PID 1: qualunque sua uscita e' un kernel panic.
#
# Una patch e non una copia del file: se Hailo cambia rcS.swupdate la build si ferma e
# ce ne accorgiamo, invece di sovrascrivere in silenzio una loro correzione.

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append:astrial-h15 = " file://0001-robust-swupdate-init.patch"
