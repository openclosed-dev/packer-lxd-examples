variable "apt_proxy" {
  type    = string
  default = env("LXD_APT_PROXY")
}

variable "user_name" {
  type = string
}

variable "group_name" {
  type = string
}
