#!/bin/bash

# DEFINING A USAGE FUNCTION
usage() { 
	echo "Insufficient Mandatory Arguments..."
	echo "Usage: $0 [-n <VM NAME PREFIX>] [-p <RDP PORT PREFIX>] [-t <TOTAL NUM OF VMs>]"
	echo "Stopping execution!"
	exit 1
}


# DEFINING A FUNCTION TO CREATE VIRTUAL MACHINES
createvm() {

	VM_NAME_PREFIX=$1
	RDP_PORT_PREFIX=$2
	NUM_OF_VMS=$3
	NUM_VCPUS=$4
	MEMORY_SIZE=$5
	DISK_SIZE=$6

	# ISO IMAGE LOCATION
	ISO_PATH="$(echo $HOME)/Downloads/CentOS-8.3.2011-x86_64-dvd1.iso"
	
	# SETTING UP THE VIRTUAL MACHINES HOME DIRECTORY
	vboxmanage setproperty machinefolder "$VIRTUAL_MACHINES_STORE"
	
	# FOR LOOP TO ITERATE
	for (( i = 1; i <= $NUM_OF_VMS; i++ )); do
		VM_NAME=${VM_NAME_PREFIX}_${i}
		RDP_PORT=${RDP_PORT_PREFIX}${i}
		echo "CREATING VM WITH NAME - ${VM_NAME} WITH BELOW CONFIGURATION..."
		echo "VM_NAME - ${VM_NAME_PREFIX}_${i}"
		echo "NUM_vCPUs - ${NUM_VCPUS}"
		echo "MEMORY (RAM) - ${MEMORY_SIZE}"
		echo "DISK - ${DISK_SIZE}"
		echo "RDP Port - ${RDP_PORT}"
	
		# VIRTUAL MACHINE VIRTUAL DISK (*.vdi) LOCATION
		VM_VDISK=${VIRTUAL_MACHINES_STORE}${VM_NAME}/${VM_NAME}-vdisk01.vdi
	
		# REGISTERING A VM WITH THE GIVEN NAME
		echo "CREATING VM ${VM_NAME}"
		vboxmanage createvm --name "$VM_NAME" --register
	
		# CREATE VDISK WITH THE DISK SIZE
		echo "CREATING VM VDISK - ${VM_VDISK} WITH SIZE ${DISK_SIZE} (in MB)"
		vboxmanage createvdi --filename "$VM_VDISK" --size "$DISK_SIZE"
	
		# SETTING UP THE RESOURCES TO THE VM LIKE MEMORY, CPU, NETWORK AND DISK
		echo "SETTING UP RESOURCES vCPUs - ${NUM_VCPUS}, MEMORY (RAM) - ${MEMORY_SIZE}, DISK_SIZE - ${DISK_SIZE} in (MB)"
		vboxmanage modifyvm "$VM_NAME" --cpus "$NUM_VCPUS" --memory "$MEMORY_SIZE" --acpi on --boot1 dvd --nic1 bridged --bridgeadapter1 eno1 --cableconnected1 on --ostype RedHat_64
	
		# CREATING A SATA CONTROLLER
		echo "CREATING SATA CONTROLLER FOR vDISK"
		vboxmanage storagectl "$VM_NAME" --name "SATA Controller" --add sata
	
		# ATTACHING THE SATA CONTROLLER FOR VIRTUAL DISK
		echo "ATTACHING vDISK (*.vdi) TO VM ${VM_NAME}"
		vboxmanage storageattach "$VM_NAME" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$VM_VDISK"
		
		# ATTACHING THE SATA CONTROLLER FOR ISO (BOOT DRIVE)
		echo "ATTACHING THE ISO IMAGE - ${ISO_PATH} TO SATA AS BOOT DRIVE"
		vboxmanage storageattach "$VM_NAME" --storagectl "SATA Controller" --port 1 --device 0 --type dvddrive --medium "$ISO_PATH"
	
		# SETTING THE BOOT SEQUENCE
		echo "SETTING UP THE BOOT SEQUENCE"
		vboxmanage modifyvm "$VM_NAME" --boot1 dvd --boot2 disk --boot3 none --boot4 none
	
		# ENABLE RDP (REMOTE DESKTOP PROTOCOL)
		echo "ENABLING THE RDP (REMOTE DESKTOP PROTOCOL)"
		vboxmanage modifyvm "$VM_NAME" --vrde on
	
		# SETTING UP THE RDP PORT FOR THE VM
		echo "SETTING UP THE RDP PORT - ${RDP_PORT} FOR VM - ${VM_NAME}"
		vboxmanage modifyvm "$VM_NAME" --vrdemulticon on --vrdeport "$RDP_PORT"
	
		echo "VIRTUAL MACHINE - ${VM_NAME} IS CREATED SUCCESSFULLY...!!!"
	
		sleep 3
	done
}

echo "Starting execution..."

# VIRTUAL MACHINES HOME DIRECTORY PATH
VIRTUAL_MACHINES_STORE="$(echo $HOME)/VirtualBox\ VMs/"


# VIRTUAL MACHINE NAME 
VM_NAME_PREFIX=""

# RDP PORT
RDP_PORT_PREFIX=""

# NUMBER OF VIRTUAL MACHINES
TOTAL_NUM_OF_VMS=""

# NUM_VCPUS, MEMORY_SIZE & DISK_SIZE
NUM_VCPUS=1
MEMORY_SIZE=2048
DISK_SIZE=10000

# Reading runtime arguments
while getopts ":n:p:t:c:m:d:" opt; do
	case "${opt}" in
		n)
			VM_NAME_PREFIX=${OPTARG}
			;;
		p)
			RDP_PORT_PREFIX=${OPTARG}
			;;
		t)
			TOTAL_NUM_OF_VMS=${OPTARG}
			;;
		c)
			NUM_VCPUS=${OPTARG}
			;;
		m)
			MEMORY_SIZE=${OPTARG}
			;;
		d)
			DISK_SIZE=${OPTARG}
			;;
		:)
			echo "UNKNOWN ARGUMENT PASSWORD..."
			usage
			;;
		*)
			echo "Taking default value for variables which are not provided as arguments"	
			;;
	esac
done
shift $((OPTIND-1))


# Checking for Manadatory Arguments
if [[ -z "${VM_NAME_PREFIX}" || -z "${RDP_PORT_PREFIX}" || -z "${TOTAL_NUM_OF_VMS}" ]]; then
	usage
else
	createvm $VM_NAME_PREFIX $RDP_PORT_PREFIX $TOTAL_NUM_OF_VMS $NUM_VCPUS $MEMORY_SIZE $DISK_SIZE
fi
