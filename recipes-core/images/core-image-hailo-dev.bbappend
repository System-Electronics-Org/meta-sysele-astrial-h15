# Astrial H15 customizations
# System Electronics

# System Electronics board tools. Development image only: a production image
# leaves this line out and the whole /opt/sysele tree disappears with it.
IMAGE_INSTALL:append = " sysele-tools evtest sysele-dsi-detection sysele-dsi-touch-test"

# IMAGE_BOOT_FILES mette swupdate-image nella partizione di boot senza dichiararlo:
# "bitbake core-image-hailo-dev" da solo fallisce su un albero pulito. Non e' circolare,
# swupdate-image produce solo ext4.gz e non passa da do_image_wic.
do_image_wic[depends] += "swupdate-image:do_image_complete"

# Con il ripiego A/B acceso servono due cose in piu', e vengono da sole: lo
# slot-sync, che rimette in ordine la lista dopo una caduta, e un demone che
# apra /dev/watchdog. Senza il demone nessun avvio fallito viene contato e il
# ripiego non scatta mai. Spento, questa riga non aggiunge niente.
IMAGE_INSTALL:append = " ${@bb.utils.contains('SYSELE_SCU_AB', '1', 'sysele-slot-sync watchdog', '', d)}"
