#!/bin/sh
imageFolder="$1"  #stores the output directory of the image folder
[ -n "$1" ] || { echo "usage: $0 <images-dir>" >&2; exit 1; }
echo "writing to $imageFolder" #prints the message to the console
cat > "$imageFolder/start-qemu.sh" <<EOF
#!/bin/sh
cd "\${0%/*}"
exec qemu-system-arm -M vexpress-a9 -smp 1 -m 256 -kernel zImage -dtb vexpress-v2p-ca9.dtb -drive file=rootfs.ext2,if=sd,format=raw -append "console=ttyAMA0,115200 rootwait root=/dev/mmcblk0" -net nic,model=lan9118 -net user -nographic "\$@"
EOF
chmod +x "$imageFolder/start-qemu.sh"
