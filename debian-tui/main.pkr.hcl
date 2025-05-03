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
  output_image = "debian-tui"
  skip_publish = false
  publish_properties = {
    description = "Debian 12 Text UI built by Packer"
  }
}

build {
  sources = ["lxd.debian"]

  provisioner "shell" {
    inline = [
      "printenv | sort",
    ]
  }

  provisioner "shell" {
    env = {
      DEBIAN_FRONTEND = "noninteractive"
    }
    inline = [
      "apt-get update",
      "apt-get upgrade -y",
      "apt-get install -y --no-install-recommends openssh-server"
    ]
  }

  provisioner "shell" {
    inline = [
      "useradd -m -s /bin/bash user1"
    ]
  }
}
