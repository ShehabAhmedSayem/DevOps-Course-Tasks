# Create four namespaces
sudo ip netns add ns1
sudo ip netns add ns2
sudo ip netns add ns3
sudo ip netns add ns4

# List the namespaces
sudo ip netns

# Create linux bridge interface
sudo ip link add v-net-0 type bridge

# List all interfaces of host
sudo ip link

# Up the bridge
sudo ip link set v-net-0 up

# Create four pairs of veth
sudo ip link add veth-ns1 type veth peer name veth-ns1-br
sudo ip link add veth-ns2 type veth peer name veth-ns2-br
sudo ip link add veth-ns3 type veth peer name veth-ns3-br
sudo ip link add veth-ns4 type veth peer name veth-ns4-br

# Set one end of a pair to the respective namespace
sudo ip link set veth-ns1 netns ns1
sudo ip link set veth-ns2 netns ns2
sudo ip link set veth-ns3 netns ns3
sudo ip link set veth-ns4 netns ns4

# Set the other end of a pair to the bridge 
# and specify the master as the bridge interface
sudo ip link set veth-ns1-br master v-net-0
sudo ip link set veth-ns2-br master v-net-0
sudo ip link set veth-ns3-br master v-net-0
sudo ip link set veth-ns4-br master v-net-0

# List the interface of a namespace
sudo ip netns exec ns1 ip link

# Up the loopback interfaces
sudo ip netns exec ns1 ip link set lo up
sudo ip netns exec ns2 ip link set lo up
sudo ip netns exec ns3 ip link set lo up
sudo ip netns exec ns4 ip link set lo up

# Up the veth interfaces
sudo ip netns exec ns1 ip link set veth-ns1 up
sudo ip netns exec ns2 ip link set veth-ns2 up
sudo ip netns exec ns3 ip link set veth-ns3 up
sudo ip netns exec ns4 ip link set veth-ns4 up

# Up the veth interfaces connected to the bridge
sudo ip link set veth-ns1-br up
sudo ip link set veth-ns2-br up
sudo ip link set veth-ns3-br up
sudo ip link set veth-ns4-br up

# Assign ip address
sudo ip netns exec ns1 ip addr add 192.168.0.1/24 dev veth-ns1
sudo ip netns exec ns2 ip addr add 192.168.0.2/24 dev veth-ns2
sudo ip netns exec ns3 ip addr add 192.168.0.3/24 dev veth-ns3
sudo ip netns exec ns4 ip addr add 192.168.0.4/24 dev veth-ns4

# Assign an ip to the bridge
sudo ip address add 192.168.0.5/24 dev v-net-0

# Set default routes
sudo ip netns exec ns1 ip route add default via 192.168.0.5
sudo ip netns exec ns2 ip route add default via 192.168.0.5
sudo ip netns exec ns3 ip route add default via 192.168.0.5
sudo ip netns exec ns4 ip route add default via 192.168.0.5

# Create firewall rules
sudo iptables --append FORWARD --in-interface v-net-0 --jump ACCEPT
sudo iptables --append FORWARD --out-interface v-net-0 --jump ACCEPT

# Ping from one ns to another
sudo ip netns exec ns1 ping -c 2 192.168.0.2
sudo ip netns exec ns2 ping -c 2 192.168.0.3
sudo ip netns exec ns3 ping -c 2 192.168.0.4
sudo ip netns exec ns4 ping -c 2 192.168.0.1
