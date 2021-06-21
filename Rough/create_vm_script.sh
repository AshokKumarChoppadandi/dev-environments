#!/bin/bash

# VIRTUAL MACHINES HOME DIRECTORY PATH
VIRTUAL_MACHINES_STORE="$(echo $HOME)/VirtualBox\ VMs/"

# VIRTUAL MACHINE NAME 
VM_NAME=$1

# RDP PORT
RDP_PORT=$2

# ISO IMAGE LOCATION
ISO_PATH="$(echo $HOME)/Downloads/CentOS-8.3.2011-x86_64-dvd1.iso"

# VIRTUAL MACHINE VIRTUAL DISK (*.vdi) LOCATION
VM_VDISK=${VIRTUAL_MACHINES_STORE}${VM_NAME}/${VM_NAME}-vdisk01.vdi 

# SETTING UP THE VIRTUAL MACHINES HOME DIRECTORY
vboxmanage setproperty machinefolder "$VIRTUAL_MACHINES_STORE"

# REGISTERING A VM WITH THE GIVEN NAME
vboxmanage createvm --name "$VM_NAME" --register

# CREATE VDISK WITH THE DISK SIZE
vboxmanage createvdi --filename "$VM_VDISK" --size 20000 

# SETTING UP THE RESOURCES TO THE VM LIKE MEMORY, CPU, NETWORK AND DISK
vboxmanage modifyvm "$VM_NAME" --cpus 2 --memory 4096 --acpi on --boot1 dvd --nic1 bridged --bridgeadapter1 eno1 --cableconnected1 on --ostype RedHat_64

# CREATING A SATA CONTROLLER
vboxmanage storagectl "$VM_NAME" --name "SATA Controller" --add sata

# ATTACHING THE SATA CONTROLLER FOR VIRTUAL DISK
vboxmanage storageattach "$VM_NAME" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$VM_VDISK"

# ATTACHING THE SATA CONTROLLER FOR ISO (BOOT DRIVE)
vboxmanage storageattach "$VM_NAME" --storagectl "SATA Controller" --port 1 --device 0 --type dvddrive --medium "$ISO_PATH"

# SETTING THE BOOT SEQUENCE
vboxmanage modifyvm "$VM_NAME" --boot1 dvd --boot2 disk --boot3 none --boot4 none

# ENABLE RDP (REMOTE DESKTOP PROTOCOL)
vboxmanage modifyvm "$VM_NAME" --vrde on

# SETTING UP THE RDP PORT FOR THE VM
vboxmanage modifyvm "$VM_NAME" --vrdemulticon on --vrdeport "$RDP_PORT"

# STARTING THE VM IN BACKGROUD
vboxheadless --startvm "$VM_NAME" &

