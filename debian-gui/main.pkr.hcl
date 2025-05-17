packer {
  required_plugins {
    lxd = {
      source  = "github.com/hashicorp/lxd"
      version = ">= 1.0.2"
    }
  }
}

source "lxd" "debian" {
  image        = "images:debian/bookworm/cloud"
  output_image = "debian-gui"
  launch_config = {
    // Run without the default user
    "user.user-data" = "#cloud-config\nusers: []"
  }
  skip_publish = false
  publish_properties = {
    description = "Debian 12 GUI built by Packer"
    os          = "Debian"
    release     = "bookworm"
    variant     = "cloud"
  }
}

build {
  sources = ["lxd.debian"]

  provisioner "shell" {
    scripts = [
      "scripts/fix-cloud.sh",
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
      "scripts/install-rdp.sh"
    ]
  }

  provisioner "shell" {
    inline = [
      "rm -f /etc/apt/apt.conf.d/01proxy"
      "cloud-init clean --logs"
    ]
  }
}
