### AnyKernel3 Ramdisk Mod Script
## osm0sis @ xda-developers

### AnyKernel setup
# global properties
properties() { '
kernel.string=kernel by shygosh
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=ginkgo
device.name2=willow
supported.versions=12-14
supported.patchlevels=
supported.vendorpatchlevels=
'; } # end properties


### AnyKernel install
## boot files attributes
boot_attributes() {
set_perm_recursive 0 0 755 644 $RAMDISK/*;
set_perm_recursive 0 0 750 750 $RAMDISK/init* $RAMDISK/sbin;
} # end attributes

# boot shell variables
BLOCK=/dev/block/by-name/boot;
IS_SLOT_DEVICE=0;
RAMDISK_COMPRESSION=auto;
PATCH_VBMETA_FLAG=auto;

# import functions/variables and setup patching - see for reference (DO NOT REMOVE)
. tools/ak3-core.sh;

if mountpoint -q /data; then
	[ ! -f /sdcard/backup_boot.img ] && DO_BOOT_BACKUP=1
	[ ! -f /sdcard/backup_dtbo.img ] && DO_DTBO_BACKUP=1

	ui_print " ";
	if [ $DO_BOOT_BACKUP ]; then
		ui_print "[+] Backing up boot...";
		dd if=/dev/block/by-name/boot of=/sdcard/backup_boot.img;
		if [ $? != 0 ]; then
			ui_print "[!] Backup failed; proceeding anyway . . .";
		else
			ui_print "[+] Done";
		fi
	else
		ui_print "[!] Found existing backup_boot.img, skipping backup"
	fi

	ui_print " ";
	if [ $DO_DTBO_BACKUP ]; then
		ui_print "[+] Backing up dtbo...";
		dd if=/dev/block/by-name/dtbo of=/sdcard/backup_dtbo.img;
		if [ $? != 0 ]; then
			ui_print "[!] Backup failed; proceeding anyway . . .";
		else
			ui_print "[+] Done";
		fi
	else
		ui_print "[!] Found existing backup_dtbo.img, skipping backup"
	fi
fi

# boot install
split_boot;
flash_boot;

# dtbo install
flash_dtbo;
