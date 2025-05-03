packer {
  required_plugins {
    lxd = {
      source  = "github.com/hashicorp/lxd"
      version = ">= 1.0.2"
    }
  }
}

source "lxd" "ubuntu" {
  image        = "ubuntu:24.04"
  output_image = "ubuntu-gui"
  skip_publish = false
  publish_properties = {
    description = "Ubuntu 24.04 GUI built by Packer"
  }
}

build {
  sources = ["lxd.ubuntu"]

  provisioner "shell" {
    inline = [
      "printenv | sort",
    ]
  }

  provisioner "shell" {
    env = {
      APT_PROXY = var.apt_proxy
    }
    scripts = [
      "scripts/add-apt-proxy.sh",
    ]
  }

  provisioner "shell" {
    env = {
      DEBIAN_FRONTEND = "noninteractive"
    }
    inline = [
      "apt-get update",
      "apt-get upgrade -y"
    ]
  }

  provisioner "shell" {
    env = {
      DEBIAN_FRONTEND = "noninteractive"
    }
    scripts = [
      "scripts/install-base.sh",
      "scripts/install-desktop.sh",
      "scripts/install-rdp.sh",
      "scripts/fix-rdp.sh",
    ]
  }

  provisioner "file" {
    source      = "files/netplan.yaml"
    destination = "/etc/netplan/10-lxd.yaml"
  }

  provisioner "shell" {
    inline = [
      "useradd -m -s /bin/bash user1"
    ]
  }

  provisioner "shell" {
    inline = [
      "rm -f /etc/apt/apt.conf.d/01proxy"
    ]
  }
}
