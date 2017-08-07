#!/bin/bash


./clean.sh


export MIRANTIS_IMAGE_NAME=MirantisOpenStack-9.0.iso


#************************************************
# Get Ubuntu 16.04 as base image
#************************************************

if [ ! -e ${MIRANTIS_IMAGE_NAME} ]; then

      echo "No Mirantis Iso file found. Aborting..."
      exit -1
fi
cp ${MIRANTIS_IMAGE_NAME} mirantis.iso


#************************************************
# Start VM and install additional stuff
#************************************************
qemu-img create -f raw mirantis.img 64G

cat >network_admin<<EOF
<network>
  <name>network_admin</name>
  <forward mode='nat'>
    <nat>
      <port start='1024' end='65535'/>
    </nat>
  </forward>
  <bridge name='virbr_admin' stp='on' delay='0'/>
  <mac address='52:54:00:b6:52:10'/>
  <ip address='10.20.0.1' netmask='255.255.255.0'>
  </ip>
</network>
EOF

cat >network_public <<EOF
<network>
  <name>network_public</name>
  <forward mode='nat'>
    <nat>
      <port start='1024' end='65535'/>
    </nat>
  </forward>
  <bridge name='virbr_public' stp='on' delay='0'/>
  <mac address='52:54:00:b6:52:11'/>
  <ip address='10.20.1.1' netmask='255.255.255.0'>
  </ip>
</network>
EOF

cat >network_private <<EOF
<network>
  <name>network_private</name>
  <forward mode='nat'>
    <nat>
      <port start='1024' end='65535'/>
    </nat>
  </forward>
  <bridge name='virbr_private' stp='on' delay='0'/>
  <mac address='52:54:00:b6:52:12'/>
  <ip address='10.20.2.1' netmask='255.255.255.0'>
  </ip>
</network>
EOF

cat >network_storage <<EOF
<network>
  <name>network_storage</name>
  <forward mode='nat'>
    <nat>
      <port start='1024' end='65535'/>
    </nat>
  </forward>
  <bridge name='virbr_storage' stp='on' delay='0'/>
  <mac address='52:54:00:b6:52:13'/>
  <ip address='10.20.3.1' netmask='255.255.255.0'>
  </ip>
</network>
EOF

cat >network_mgmt <<EOF
<network>
  <name>network_mgmt</name>
  <forward mode='nat'>
    <nat>
      <port start='1024' end='65535'/>
    </nat>
  </forward>
  <bridge name='virbr_mgmt' stp='on' delay='0'/>
  <mac address='52:54:00:b6:52:14'/>
  <ip address='10.20.4.1' netmask='255.255.255.0'>
  </ip>
</network>
EOF

virsh net-create network_admin
virsh net-create network_public
virsh net-create network_private
virsh net-create network_storage
virsh net-create network_mgmt



virt-install --connect qemu:///system --noautoconsole --filesystem ${PWD},shared_dir --import --name mirantis --ram 2048 --vcpus 1 --disk mirantis.img,size=64 --boot hd,cdrom,network --disk mirantis.iso,device=cdrom --network network=network_admin,mac="08:00:28:af:10:10" --network network=network_public,mac="08:00:28:af:10:11" --network network=network_private,mac="08:00:28:af:10:12" --network network=network_storage,mac="08:00:28:af:10:13" --network network=network_mgmt,mac="08:00:28:af:10:14" 

exit 0


#Create controller

#Controller
virt-install --connect qemu:///system --noautoconsole --filesystem ${PWD},shared_dir --import --name controller --ram 2048 --vcpus 2 --disk controller.img,size=68 --boot cdrom,hd,network  --network network=network_admin,mac="08:00:28:af:10:20" --network network=network_public,mac="08:00:28:af:10:21" --network network=network_private,mac="08:00:28:af:10:22" --network network=network_storage,mac="08:00:28:af:10:23" --network network=network_mgmt,mac="08:00:28:af:10:24" 

#Compute1
virt-install --connect qemu:///system --noautoconsole --filesystem ${PWD},shared_dir --import --name compute1 --ram 2048 --vcpus 2 --disk compute1.img,size=25 --boot cdrom,hd,network  --network network=network_admin,mac="08:00:28:af:10:30" --network network=network_public,mac="08:00:28:af:10:31" --network network=network_private,mac="08:00:28:af:10:32" --network network=network_storage,mac="08:00:28:af:10:33" --network network=network_mgmt,mac="08:00:28:af:10:34" 

#Compute2
virt-install --connect qemu:///system --noautoconsole --filesystem ${PWD},shared_dir --import --name compute2 --ram 2048 --vcpus 2 --disk compute2.img,size=25 --boot cdrom,hd,network  --network network=network_admin,mac="08:00:28:af:10:40" --network network=network_public,mac="08:00:28:af:10:41" --network network=network_private,mac="08:00:28:af:10:42" --network network=network_storage,mac="08:00:28:af:10:43" --network network=network_mgmt,mac="08:00:28:af:10:44" 


#Contrail nodes

#Controller
virt-install --connect qemu:///system --noautoconsole --filesystem ${PWD},shared_dir --import --name contrail_controller --ram 2048 --vcpus 2 --disk contrail_controller.img,size=320 --boot cdrom,hd,network  --network network=network_admin,mac="08:00:28:af:10:50" --network network=network_public,mac="08:00:28:af:10:51" --network network=network_private,mac="08:00:28:af:10:52" --network network=network_storage,mac="08:00:28:af:10:53" --network network=network_mgmt,mac="08:00:28:af:10:54" 

#Analytics
virt-install --connect qemu:///system --noautoconsole --filesystem ${PWD},shared_dir --import --name analytics --ram 2048 --vcpus 2 --disk analytics.img,size=321 --boot cdrom,hd,network  --network network=network_admin,mac="08:00:28:af:10:60" --network network=network_public,mac="08:00:28:af:10:61" --network network=network_private,mac="08:00:28:af:10:62" --network network=network_storage,mac="08:00:28:af:10:63" --network network=network_mgmt,mac="08:00:28:af:10:64" 



