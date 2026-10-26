# Lo SWU deve scrivere sulla eMMC, non sulla SD.
#
# La ricetta ha SWUPDATE_DEFAULT_FILESYSTEM_DEVICE = "mmcblk0" e lo corregge a mmcblk1 solo
# per hailo15-sbc e hailo15l-sbc. Per astrial-h15 resta mmcblk0, che e' la SD: uno SWU
# lanciato in modo singolo non passa nessun disco sulla riga di comando del kernel e
# scriverebbe li', senza errori e sul disco sbagliato.
SWUPDATE_DEFAULT_FILESYSTEM_DEVICE:astrial-h15 = "mmcblk1"
