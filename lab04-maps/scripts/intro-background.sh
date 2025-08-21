#!/bin/bash

groupadd cassandra
useradd -m -s /bin/bash -g cassandra cassandra-user

cat <<'EOF' > /home/cassandra-user/.bash_profile
export PATH="/home/cassandra-user/cassandra/bin:$PATH"
cd /home/cassandra-user
export PS1="\w \$ "
EOF

chown cassandra-user:cassandra /home/cassandra-user/.bash_profile


# Detect the primary non-loopback interface (excluding docker0 and loopback)
NET_IFACE=$(ip -4 -o addr show scope global | grep -v docker | awk '{print $2}' | head -n 1)

# List of virtual IPs to assign
IP_LIST=("172.30.1.10" "172.30.1.11" "172.30.1.12")

# Assign each IP to the detected interface
for ip in "${IP_LIST[@]}"; do
  ip addr add "$ip/24" dev "$NET_IFACE"
done


apt-get update

sudo apt-get install -y openjdk-11-jdk-headless < /dev/null > /dev/null 

# Downgrade Python to v3.11
# Download prebuilt Python 3.11 binary from GitHub release
wget https://github.com/indygreg/python-build-standalone/releases/download/20240107/cpython-3.11.7+20240107-x86_64-unknown-linux-gnu-install_only.tar.gz

# Extract it
mkdir -p /opt/python3.11
tar -xzf cpython-3.11.7+20240107-x86_64-unknown-linux-gnu-install_only.tar.gz -C /opt/python3.11 --strip-components=1

sudo ln -sf /opt/python3.11/bin/python3.11 /usr/bin/python
sudo ln -sf /opt/python3.11/bin/pip3.11 /usr/bin/pip
sudo ln -sf /usr/local/bin/python3.11 /usr/bin/python3

#
# Download and extract Cassandra
#

su - cassandra-user -c '
  cd ~
  wget https://archive.apache.org/dist/cassandra/5.0.4/apache-cassandra-5.0.4-bin.tar.gz
  tar -xzf apache-cassandra-5.0.4-bin.tar.gz
  rm apache-cassandra-5.0.4-bin.tar.gz
  mv apache-cassandra-5.0.4 nodeA
  cp -r nodeA nodeB
  cp -r nodeA nodeC
'
#
# configure the yaml files
#

/

# Base IPs and ports
declare -A IPS=( [nodeA]=172.30.1.10 [nodeB]=172.30.1.11 [nodeC]=172.30.1.12 )
declare -A STORAGE_PORTS=( [nodeA]=7000 [nodeB]=7001 [nodeC]=7002 )
declare -A NATIVE_PORTS=( [nodeA]=9042 [nodeB]=9043 [nodeC]=9044 )
declare -A JMX_PORTS=( [nodeA]=7199 [nodeB]=7200 [nodeC]=7201 )

# Common settings
HOME_DIR="/home/cassandra-user"
CLUSTER_NAME="Academy Cluster"
SEED_IP="172.30.1.10:7000,172.30.1.11:7001,172.30.1.12:7002" 

for NODE in nodeA; do

  CONF_DIR="$HOME_DIR/$NODE/conf"
  YAML="$CONF_DIR/cassandra.yaml"
  ENV_SH="$CONF_DIR/cassandra-env.sh"

  # Set listen_address, rpc_address, ports, directories
  sed -i "s/^cluster_name:.*/cluster_name: '$CLUSTER_NAME'/" "$YAML"
  sed -i "s/^listen_address:.*/listen_address: ${IPS[$NODE]}/" "$YAML"
  sed -i "s/^rpc_address:.*/rpc_address: ${IPS[$NODE]}/" "$YAML"
  sed -i "s/^storage_port:.*/storage_port: ${STORAGE_PORTS[$NODE]}/" "$YAML"
  sed -i "s/^native_transport_port:.*/native_transport_port: ${NATIVE_PORTS[$NODE]}/" "$YAML"

  # Replace seed list block
  sed -i "/- seeds:/c\      - seeds: \"$SEED_IP\"" "$YAML"

  # Set data/log/cache directories
  sed -i "/^data_file_directories:/,/^ *[^-]/c\data_file_directories:\n    - .\/data" "$YAML"
  sed -i "s|^commitlog_directory:.*|commitlog_directory: ./commitlog|" "$YAML"
  sed -i "s|^saved_caches_directory:.*|saved_caches_directory: ./saved_caches|" "$YAML"

   # Set JMX_PORT value directly
  sed -i "s/^JMX_PORT=.*/JMX_PORT=\"${JMX_PORTS[$NODE]}\"/" "$ENV_SH"

  # Add unique PID file path
  # echo "JVM_OPTS=\"\$JVM_OPTS -Dcassandra-pidfile=$HOME_DIR/$NODE/cassandra.pid\"" >> "$ENV_SH"
  echo "CASSANDRA_PIDFILE=\"$HOME_DIR/$NODE/cassandra.pid\"" >> "$ENV_SH"

  # Add JVM_OPTS for logdir
  grep -q "Dcassandra.logdir" "$ENV_SH" || \
    echo "JVM_OPTS=\"\$JVM_OPTS -Dcassandra.logdir=$HOME_DIR/$NODE/logs\"" >> "$ENV_SH"

  # Add JVM_OPTS for storagedir
  grep -q "Dcassandra.storagedir" "$ENV_SH" || \
    echo "JVM_OPTS=\"\$JVM_OPTS -Dcassandra.storagedir=$HOME_DIR/$NODE\"" >> "$ENV_SH"

  echo "JVM_OPTS=\"\$JVM_OPTS -Xms512M -Xmx512M\"" >> "$ENV_SH"

  # Create data directories
  
  mkdir -p "$HOME_DIR/$NODE/logs"
  mkdir -p "$HOME_DIR/$NODE/saved_caches"

done

chown -R cassandra-user:cassandra "$HOME_DIR"

#
# Start the nodes in the background
#

su - cassandra-user -c '~/nodeA/bin/cassandra -R > ~/nodeA/logs/cassandra.log 2>&1 &'
