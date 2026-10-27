# La wic mette swupdate-image nella partizione di boot senza dichiararlo.
#
# meta-hailo-bsp-examples/conf/layer.conf fa
#   IMAGE_BOOT_FILES += "swupdate-image-${MACHINE}.ext4.gz"
# ma nessuno dice a bitbake che quel file va prodotto prima. Regge perche' la CI lancia
# due target nello stesso comando, e si rompe il giorno che qualcuno ne lancia uno solo:
# "bitbake core-image-hailo-dev" da solo fallisce su un albero pulito.
#
# Non e' circolare: swupdate-image non installa questa immagine, e produce solo ext4.gz,
# quindi non passa da do_image_wic.
do_image_wic[depends] += "swupdate-image:do_image_complete"
