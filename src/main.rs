#![no_std]
#![no_main]


use uefi::prelude::*;
use uefi::table::boot::MemoryDescriptor;
use log::{info};

#[no_mangle]
pub extern "C" fn efi_main(handle: uefi::Handle, system_table: SystemTable<Boot>) -> Status {
    uefi_services::init(&system_table);
    info!("hello world!");
    return uefi::Status::SUCCESS;
}

