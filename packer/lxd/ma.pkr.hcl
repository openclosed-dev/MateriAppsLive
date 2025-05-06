packer {
  required_plugins {
    lxd = {
      source  = "github.com/hashicorp/lxd"
      version = ">= 1.0.2"
    }
  }
}

variable "username" {
  type    = string
  default = "user"
}

variable "group_name" {
  type    = string
  default = "user"
}

variable "password" {
  type = string
  // encrypted 'live'
  default = "$6$AgoqWQ70I/ots39M$wJaCLlJ5XEKAiQRbzMPB1Ulerg3e2IY3K21R3jVsaWT1ChUgEIHeKSSYEqIJE7BKHP0TZuEV/cYAs6FSKIAWK0"
}

variable "user_id" {
  type    = number
  default = 1000
}

variable "group_id" {
  type    = number
  default = 1000
}

variable "ma_version" {
  type    = string
  default = "5.0"
}

variable "ma_version_major" {
  type    = string
  default = "5"
}

variable "debian_codename" {
  type    = string
  default = "bookworm"
}

variable "architecture" {
  type    = string
  default = "amd64"
}

variable "apt_proxy" {
  type    = string
  default = env("LXD_APT_PROXY")
}

source "lxd" "debian" {
  image        = "images:debian/${var.debian_codename}/cloud"
  output_image = "MateriAppsLive-${var.ma_version}"
  launch_config = {
    // Run without the default user
    "user.user-data" = "#cloud-config\nusers: []"
  }
  skip_publish = false
  publish_properties = {
    architecture = var.architecture,
    description  = "MateriApps LIVE! ${var.ma_version}",
    os           = "Debian",
    release      = "bookworm",
    variant      = "cloud"
  }
}

build {
  sources = ["lxd.debian"]

  provisioner "shell" {
    env = {
      APT_PROXY = var.apt_proxy
    }
    scripts = [
      "script/fix-cloud.sh",
      "script/prepare-apt.sh",
      "script/add-apt-proxy.sh",
    ]
  }

  provisioner "shell" {
    inline = [
      "mkdir -p /tmp/files"
    ]
  }

  provisioner "file" {
    source      = "../files/"
    destination = "/tmp/files/"
  }

  provisioner "shell" {
    inline = [
      "chown -R root:root /tmp/files",
      "ls -l /tmp/files"
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
      "groupadd -g ${var.group_id} ${var.group_name}",
      "useradd -m -u ${var.user_id} -g ${var.group_id} -s /bin/bash -c 'MateriApps LIVE! User' -p '${var.password}' ${var.username}"
    ]
  }

  provisioner "shell" {
    env = {
      DEBIAN_FRONTEND = "noninteractive"
    }
    scripts = [
      "script/install-base.sh",
      "script/install-rdp.sh"
    ]
  }

  provisioner "shell" {
    env = {
      DEBIAN_FRONTEND = "noninteractive",
      HOME            = "/home/${var.username}"
    }
    scripts = [
      "../script/ldconfig.sh",
      "../script/bashrc.sh",
      "../script/emacs.sh",
      "../script/file.sh",
      "../script/firefox.sh",
      "../script/keyboard.sh",
      "../script/menu.sh",
      "../script/openssl.sh",
      "../script/xterm.sh",
      "../script/materiapps-ma${var.ma_version_major}.sh",
      "../script/96_check.sh",
      "../script/97_check-ma.sh",
      "../script/98_minimize.sh",
      // Skip 99_cleanup.sh
    ]
  }

  provisioner "shell" {
    scripts = [
      "script/fix-materiapps.sh",
      "script/cleanup.sh",
    ]
  }
}
