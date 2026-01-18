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
  output_image = "ubuntu-gui-kde-ja"
  launch_config = {
    // Run without the default user
    "user.user-data" = "#cloud-config\nusers: []"
  }
  skip_publish = false
  publish_properties = {
    description = "Ubuntu 24.04 KDE built by Packer"
    os          = "ubuntu"
    release     = "noble"
    version     = "24.04"
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
      "scripts/root/add-apt-proxy.sh",
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
      "scripts/root/install-base.sh",
      "scripts/root/install-desktop.sh",
      "scripts/root/install-language-ja.sh",
      "scripts/root/install-rdp.sh",
    ]
  }

  // Creates destination directories
  provisioner "shell" {
    inline = [
      "mkdir -p /etc/skel/.config",
    ]
  }

  provisioner "file" {
    source      = "files/netplan.yaml"
    destination = "/etc/netplan/10-lxd.yaml"
  }

  provisioner "file" {
    sources = [
      "files/.xsessionrc"
    ]
    destination = "/etc/skel/"
  }

  provisioner "file" {
    sources = [
      "files/.config/plasma-localerc"
    ]
    destination = "/etc/skel/.config/"
  }

  provisioner "shell" {
    inline = [
      "chown root:root /etc/netplan/10-lxd.yaml",
      "chown root:root /etc/skel/.xsessionrc",
      "chown root:root /etc/skel/.config/plasma-localerc",
    ]
  }

  provisioner "shell" {
    inline = [
      "rm -f /etc/apt/apt.conf.d/01proxy",
      "cloud-init clean --logs"
    ]
  }
}
