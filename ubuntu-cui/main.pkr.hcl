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
  output_image = "ubuntu-cui"
  launch_config = {
    // Run without the default user
    "user.user-data" = "#cloud-config\nusers: []"
  }
  skip_publish = false
  publish_properties = {
    description = "Ubuntu 24.04 CUI built by Packer"
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
      DEBIAN_FRONTEND = "noninteractive"
    }
    inline = [
      "apt-get update",
      "apt-get upgrade -y"
    ]
  }
}
