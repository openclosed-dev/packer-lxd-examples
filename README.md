# packer-lxd-examples

Building LXD images using Packer.

## Prerequisites

Add apt repository.
```
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo tee /etc/apt/keyrings/hashicorp.asc > /dev/null
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/hashicorp.asc] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sou
rces.list.d/hashicorp.list > /dev/null
```

Install Packer as follows.
```
sudo apt-get update
sudo apt-get install packer
```

## Building LXD images

Invoke the following command.
```
cd <path/to/image/directory>
packer build .
```

Images built are registered in the local image cache.
```
lxc image list
```
