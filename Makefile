# llvm toolchain
# use llvm 10
TARGET=aarch64-unknown-uefi.json

all: efi/kernel.efi efi/loader.efi

efi/rust_uefi_hello_aarch64.efi: FORCE
	cargo xbuild --target $(TARGET) -Z unstable-options --out-dir $(PWD)/efi

efi/kernel.efi: efi/rust_uefi_hello_aarch64.efi
	mv efi/rust_uefi_hello_aarch64.efi efi/kernel.efi

efi/loader.efi: FORCE
	cd uefi_debug_loader/ \
		&& docker-compose run aarch64-uefi-toolchain bash -c "cd ~/work/ && make" \
		&& cp main.efi ../efi/loader.efi

setup:
	curl -sL https://releases.linaro.org/components/kernel/uefi-linaro/latest/release/qemu64/QEMU_EFI.fd -o efi/QEMU_EFI.fd

qemu: efi/loader.efi efi/kernel.efi 
	qemu-system-aarch64 \
		-M virt \
		-cpu cortex-a57 \
		-m 512 \
		-bios ./efi/QEMU_EFI.fd \
		-nographic \
		-hda fat:rw:./efi/ \
		-gdb tcp::1234

qemu_log: efi/loader.efi efi/kernel.efi 
	qemu-system-aarch64 \
		-M virt \
		-cpu cortex-a57 \
		-m 512 \
		-bios ./efi/QEMU_EFI.fd \
		-nographic \
		-hda fat:rw:./efi/ \
		-gdb tcp::1234 \
		-d in_asm \
		2>&1 | tee log.txt

clean:
	cargo clean

FORCE:
.PHONY: all clean FORCE
