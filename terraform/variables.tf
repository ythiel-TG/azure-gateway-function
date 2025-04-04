#variable "project" {
#  type    = string
#  default = "ythieltfauthcheck"
#}

variable "location" {
  type    = string
  default = "East US 2"
}

#variable "prefix" {
#  type    = string
#  default = "dev"
#}

variable "tags" {
  type = map(string)
  default = {
    owner = "maintainer@organization.com"
  }
}
