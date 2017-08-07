#!/bin/bash

virsh destroy mirantis
virsh undefine mirantis

virsh destroy controller
virsh undefine controller
virsh destroy compute1
virsh undefine compute1
virsh destroy compute2
virsh undefine compute2

virsh destroy analytics
virsh undefine analytics
virsh destroy contrail_controller
virsh undefine contrail_controller

virsh net-destroy network_admin
virsh net-destroy network_public
virsh net-destroy network_private
virsh net-destroy network_storage
virsh net-destroy network_mgmt


rm -f mirantis.img
rm -f mirantis.iso

rm -f network_admin
rm -f network_public
rm -f network_private
rm -f network_storage
rm -f network_mgmt

rm -f controller.img
rm -f compute1.img
rm -f compute2.img

rm -f analytics.img
rm -f contrail_controller
