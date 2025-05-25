# packer-lxd-examples

Building LXD images using Packer.

## Prerequisites

* Ubuntu 24.04 LTS (may run on WSL)
* [LXD](https://canonical.com/lxd) 5.21.3 LTS or higher
* [Packer](https://developer.hashicorp.com/packer/install) 1.12.0 or higher
* [Packer LXD plugin](https://developer.hashicorp.com/packer/integrations/hashicorp/lxd/latest/components/builder/lxd) 1.0.2 or higher
* (optional) APT-Cacher NG

### Installing LXD

Install LXD from Snap.
```shell
sudo snap install lxd
```

Add your account to `lxd` gorup.
```shell
sudo usermod -aG lxd $USER
newgrp lxd
# Checks your groups
groups
```

Initialize the LXD service using default configuration.
```shell
lxd init --auto
```

Create a profile predefined for testing purpose.
```shell
lxc profile create develop < develop-profile.yaml
# Checks the created profile
lxc profile list
```

### Installing Packer

Add an apt repository managed by HashiCorp.
```shell
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo tee /etc/apt/keyrings/hashicorp.asc > /dev/null
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/hashicorp.asc] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list > /dev/null
```

Install Packer from the newly added repository.
```shell
sudo apt-get update
sudo apt-get install packer
```

And the following command adds an LXD plugin under your home directory.
```shell
cd <path/to/image/directory>
packer init .
```

## Building LXD images

Delete the image if already exists.
```shell
lxd image delete <image-alias>
```


Invoke the following command.
```shell
cd <path/to/image/directory>
packer build .
```

Images built are registered in the local image cache.
```shell
lxc image list
```

## Running LXD containers

The built images can be run with the following command.
```shell
lxc launch <image-alias> <container-name> -p develop
```

With `develop` profile specified, the containers equipped with GUI accept RDP connection. 
The target IP address is that of the Ubuntu machine hosting the container. 

The login credentials provided by these examples are `user1`/`secret`, which must be changed in production environment.

The password hash is generated with the following command and specified with `hashed_passwd` property in the profile.

```shell
openssl passwd -6 <password>
```

## Advanced settings

### Caching apt packages for faster build

Install _apt-cacher-ng_ for locally caching the packages downloaded from the apt repositories over HTTP protocol.

```shell
# Installs apt-cacher-ng 
sudo apt install apt-cacher-ng
# Checks the service is up and running
systemctl status apt-cacher-ng
```

```shell
export LXD_APT_PROXY=http://_gateway:3142
# Subsequent builds may get performance gain
```

* The cached packages are persisted in the local `/var/cache/apt-cacher-ng` directory.
* The packages fetched over HTTPS are not cached, and will be always downloaded directly from the remote repositories.
