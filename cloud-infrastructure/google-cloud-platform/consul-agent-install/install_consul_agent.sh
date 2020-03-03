#!/bin/bash -e
consul_version=1.5.2

sudo apt install -y unzip


# Install Consul
wget -O /tmp/consul.zip "https://releases.hashicorp.com/consul/${consul_version}/consul_${consul_version}_linux_amd64.zip"
cd /tmp
unzip -o ./consul.zip
sudo mv -f ./consul /usr/local/bin/
sudo mkdir -p /etc/consul.d
sudo mkdir -p /etc/consul.d/data

sudo tee /etc/systemd/system/consul.service > /dev/null <<"EOF"
  [Unit]
  Description = "Consul"

  [Service]
  KillSignal=INT
  ExecStart=/usr/local/bin/consul agent -retry-join 'provider=k8s label_selector="app=consul,component=server" kubeconfig=/home/nkrause/.kube/config' -data-dir=/etc/consul.d/data -config-dir=/etc/consul.d
  Restart=always
  Environment=GOOGLE_APPLICATION_CREDENTIALS=/home/nkrause/.kube/creds.json
EOF

sudo systemctl enable consul.service
sudo systemctl add-wants multi-user.target consul.service

sudo systemctl daemon-reload
sudo service consul restart

echo '{"service": {"name": "shopfront", "tags": ["springboot"], "address":"$(hostname -I)", "port": 80}}' > /etc/consul.d/shopfront.json
sudo service consul restart