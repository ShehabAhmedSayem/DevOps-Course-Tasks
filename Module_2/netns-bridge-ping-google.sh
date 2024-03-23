# Create two namespaces
sudo ip netns add ns1
sudo ip netns add ns2

# List the namespaces
sudo ip netns list

# Create linux bridge interface
sudo ip link add br0 type bridge

# List all interfaces of host
sudo ip link list

# Up the bridge
sudo ip link set br0 up

# Create two pairs of veth
sudo ip link add veth-ns1 type veth peer name veth-ns1-br
sudo ip link add veth-ns2 type veth peer name veth-ns2-br

# Set one end of a pair to the respective namespace
sudo ip link set veth-ns1 netns ns1
sudo ip link set veth-ns2 netns ns2

# Set the other end of a pair to the bridge 
# and specify the master as the bridge interface
sudo ip link set veth-ns1-br master br0
sudo ip link set veth-ns2-br master br0

# List the interface of a namespace
sudo ip netns exec ns1 ip link list

# Up the loopback interfaces of the namespaces
sudo ip netns exec ns1 ip link set lo up
sudo ip netns exec ns2 ip link set lo up

# Up the veth interfaces connected to the namespaces
sudo ip netns exec ns1 ip link set veth-ns1 up
sudo ip netns exec ns2 ip link set veth-ns2 up

# Up the veth interfaces connected to the bridge
sudo ip link set veth-ns1-br up
sudo ip link set veth-ns2-br up

# Assign ip address
sudo ip netns exec ns1 ip addr add 192.168.0.1/24 dev veth-ns1
sudo ip netns exec ns2 ip addr add 192.168.0.2/24 dev veth-ns2

# Assign an ip to the bridge
sudo ip address add 192.168.0.3/24 dev br0

# Set default routes
sudo ip netns exec ns1 ip route add default via 192.168.0.3
sudo ip netns exec ns2 ip route add default via 192.168.0.3

# Create firewall rules
sudo iptables --append FORWARD --in-interface br0 --jump ACCEPT
sudo iptables --append FORWARD --out-interface br0 --jump ACCEPT

# Ping from one ns to another
sudo ip netns exec ns1 ping -c 2 192.168.0.2
sudo ip netns exec ns2 ping -c 2 192.168.0.1

# Add nat iptables rule in host
sudo iptables -t nat -A POSTROUTING -s 192.168.0.0/24 -j MASQUERADE 

# ping to google's public ip from namespaces
sudo ip netns exec ns1 ping -c 2 8.8.8.8
sudo ip netns exec ns2 ping -c 2 8.8.8.8