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
  output_image = "ubuntu-tui"
  skip_publish = false
  publish_properties = {
    description = "Ubuntu 24.04 Text UI built by Packer"
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
      DEBIAN_FRONTEND = "noninteractive"
    }
    inline = [
      "apt-get update",
      "apt-get upgrade -y"
    ]
  }

  provisioner "shell" {
    inline = [
      "useradd -m -s /bin/bash user1"
    ]
  }
}
