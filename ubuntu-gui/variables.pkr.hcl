variable "apt_proxy" {
  type    = string
  default = env("LXD_APT_PROXY")
}
