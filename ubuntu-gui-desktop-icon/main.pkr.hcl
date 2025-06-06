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
  output_image = "ubuntu-gui-desktop-icon"
  launch_config = {
    // Run without the default user
    "user.user-data" = "#cloud-config\nusers: []"
  }
  skip_publish = false
  publish_properties = {
    description = "Ubuntu 24.04 GUI built by Packer"
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
      "scripts/root/install-rdp.sh",
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

  provisioner "shell" {
    inline = [
      "chown root:root /etc/netplan/10-lxd.yaml",
      "chown root:root /etc/skel/.xsessionrc",
    ]
  }

  provisioner "shell" {
    inline = [
      "groupadd ${var.group_name}",
      "useradd -m -s /bin/bash -g ${var.group_name} ${var.user_name}"
    ]
  }

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -u ${var.user_name} bash '{{ .Path }}'"
    scripts = [
      "scripts/user/add-desktop-icons.sh"
    ]
  }

  provisioner "shell" {
    inline = [
      "rm -f /etc/apt/apt.conf.d/01proxy",
      "cloud-init clean --logs"
    ]
  }
}
