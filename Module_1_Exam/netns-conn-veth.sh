# Create two namespaces
sudo ip netns add ns1
sudo ip netns add ns2

# List the namespaces
sudo ip netns

# List the interface of a namespace
sudo ip netns exec ns1 ip link

# Create veth pair
sudo ip link add veth-ns1 type veth peer name veth-ns2

# Connect veth to namespaces
sudo ip link set veth-ns1 netns ns1
sudo ip link set veth-ns2 netns ns2

# Assign ip address
sudo ip netns exec ns1 ip addr add 192.168.0.1/24 dev veth-ns1
sudo ip netns exec ns2 ip addr add 192.168.0.2/24 dev veth-ns2

# Up the loopback interfaces of namespaces
sudo ip netns exec ns1 ip link set lo up
sudo ip netns exec ns2 ip link set lo up

# Up the veth interfaces of namespaces
sudo ip netns exec ns1 ip link set veth-ns1 up
sudo ip netns exec ns2 ip link set veth-ns2 up

# Ping from one ns to another
sudo ip netns exec ns1 ping -c 2 192.168.0.2
sudo ip netns exec ns2 ping -c 2 192.168.0.1
