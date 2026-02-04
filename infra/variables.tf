variable "region_aws" {
  type = string
}
variable "key" {
  type = string
}
variable "instance" {
  type    = string
#   default = "t2.micro"
}
variable "security-group" {
  type = string
}
variable "maximo" {
  type = number
}
variable "minimo" {
  type = number
}
variable "nomeGrupo" {
  type = string
}