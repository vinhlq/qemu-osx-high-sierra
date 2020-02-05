#!/bin/bash

# See https://www.mail-archive.com/qemu-devel@nongnu.org/msg471657.html thread.
#
# The "pc-q35-2.4" machine type was changed to "pc-q35-2.9" on 06-August-2017.
#
# The "media=cdrom" part is needed to make Clover recognize the bootable ISO
# image.

##################################################################################
# NOTE: Comment out the "MY_OPTIONS" line in case you are having booting problems!
##################################################################################

MY_OPTIONS="+aes,+xsave,+avx,+xsaveopt,avx2,+smep"

qemu-system-x86_64 -enable-kvm -m 3072 -cpu Penryn,kvm=on,vendor=GenuineIntel,+invtsc,vmware-cpuid-freq=on,$MY_OPTIONS\
	  -machine pc-q35-2.9 \
	  -smp 4,cores=2 \
	  -usb -device usb-kbd -device usb-tablet \
	  -device isa-applesmc,osk="ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc" \
	  -drive if=pflash,format=raw,readonly,file=OVMF_CODE.fd \
	  -drive if=pflash,format=raw,file=OVMF_VARS-1920x1080.fd \
	  -smbios type=2 \
	  -device ich9-intel-hda -device hda-duplex \
	  -device ide-hd,bus=ide.2,drive=Clover \
	  -drive id=Clover,if=none,snapshot=on,format=qcow2,file=./'HighSierra/Clover-1920x1080.qcow2' \
	  -device ide-hd,bus=ide.1,drive=MacHDD \
	  -drive id=MacHDD,if=none,file=./mac_hdd.img,format=raw \
	  -device ide-cd,bus=ide.0,drive=MacDVD \
	  -drive id=MacDVD,if=none,snapshot=on,media=cdrom,file='../../@iso/HighSierra-10.13.3.iso' \
	  \
	  -netdev tap,id=net0,ifname=tap0,script=tap0_ifup,downscript=tap0_ifdown,vhost=on \
	  -device vmxnet3,netdev=net0,addr=19.0,mac=52:54:BE:EF:12:66    \
	  \
	  -netdev tap,id=net1,ifname=tap1,script=tap1_ifup,downscript=tap1_ifdown  \
	  -device vmxnet3,netdev=net1,mac=52:54:00:c9:18:27 \
	  \
	  -spice port=5900,addr=127.0.0.1,disable-ticketing \
	  -chardev spicevmc,name=usbredir,id=usbredirchardev1 -device usb-redir,chardev=usbredirchardev1 \
	  -chardev spicevmc,name=usbredir,id=usbredirchardev2 -device usb-redir,chardev=usbredirchardev2 \
	  -chardev spicevmc,name=usbredir,id=usbredirchardev3 -device usb-redir,chardev=usbredirchardev3 \
	  -chardev spicevmc,name=usbredir,id=usbredirchardev4 -device usb-redir,chardev=usbredirchardev4 \
	  \
	  -monitor stdio
