# MateriApps LIVE! LXD Editions

## Prerequisites

* Ubuntu 24.04 LTS, or other Linux distro hosting LXD containers, including distributions for WSL
* [LXD](https://canonical.com/lxd) 5.21.3 LTS or higher
* [Packer](https://developer.hashicorp.com/packer/install) 1.12.0 or higher
* [Packer LXD plugin](https://developer.hashicorp.com/packer/integrations/hashicorp/lxd/latest/components/builder/lxd) 1.0.2 or higher
* (optional) APT-Cacher NG

### Installing LXD

Install LXD from Snap.
```shell
sudo snap install lxd
```

Add your account to `lxd` group.
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

Create a profile for testing purpose.
```shell
lxc profile create malive < malive-profile.yaml
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

Change into this directory and invoke the following command to add an LXD plugin under your home directory.
```shell
packer init .
```

## Building LXD images

Generate required files into the parent directory.
```
cd <path/to/this/directory>
./setup.sh
```

Delete the image if already exists.
```shell
lxc image list
lxc image delete <image-alias>
```

The following command starts the build.
```shell
./build-ma5.sh
```

Images built are registered in the local image cache.
```shell
lxc image list
```

## Testing LXD images

A test container can be launched using the built image.
```shell
lxc launch <image-alias> <container-name> -p malive
```

With `malive` profile specified, the container accepts RDP connection. 
The target IP address is that of the machine hosting the container. 

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
export LXD_APT_PROXY='http://_gateway:3142'
# Subsequent builds may receive performance gain
```

* The cached packages are persisted in the local `/var/cache/apt-cacher-ng` directory.
* The packages downloaded over HTTPS are never cached, and will be always downloaded directly from the remote repositories.
