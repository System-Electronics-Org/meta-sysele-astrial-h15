# Lo SWU deve scrivere sulla eMMC. Il valore di Hailo resta mmcblk0 per questa macchina,
# cioe' la SD, e un update in modo singolo scriverebbe li' senza errori.
SWUPDATE_DEFAULT_FILESYSTEM_DEVICE:astrial-h15 = "mmcblk1"
