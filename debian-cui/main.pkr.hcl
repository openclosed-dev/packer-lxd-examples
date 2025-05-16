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
  output_image = "debian-cui"
  launch_config = {
    // Run without the default user
    "user.user-data" = "#cloud-config\nusers: []"
  }
  skip_publish = false
  publish_properties = {
    description = "Debian 12 CUI built by Packer"
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
      DEBIAN_FRONTEND = "noninteractive"
    }
    inline = [
      "apt-get update",
      "apt-get upgrade -y",
      "apt-get install -y --no-install-recommends curl openssh-server"
    ]
  }
}
