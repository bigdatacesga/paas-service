#!/bin/bash
CONTAINER_HOSTNAME="fs05-nfs.lan.cesga.es"
CONTAINER_IP=`host $CONTAINER_HOSTNAME | awk '{print $4}'`
PRIVATE_IP="${CONTAINER_IP/117/112}/16"
STORAGE_IP="${CONTAINER_IP}/16"

docker run \
--net="none"  \
--lxc-conf="lxc.network.type = veth" \
--lxc-conf="lxc.network.ipv4 = $PRIVATE_IP" \
--lxc-conf="lxc.network.ipv4.gateway = 10.112.0.1" \
--lxc-conf="lxc.network.link = virbrPRIVATE" \
--lxc-conf="lxc.network.name = eth0" \
--lxc-conf="lxc.network.flags = up" \
--lxc-conf="lxc.network.veth.pair = veth0-${PRIVATE_IP:(-10):7}" \
--lxc-conf="lxc.network.type = veth" \
--lxc-conf="lxc.network.ipv4 = $STORAGE_IP" \
--lxc-conf="lxc.network.link = virbrSTORAGE" \
--lxc-conf="lxc.network.name = eth1" \
--lxc-conf="lxc.network.flags = up" \
--lxc-conf="lxc.network.mtu = 9000" \
--lxc-conf="lxc.network.veth.pair = veth1-${STORAGE_IP:(-10):7}" \
-h $CONTAINER_HOSTNAME \
--name $CONTAINER_HOSTNAME \
-d alcachi/centos66 