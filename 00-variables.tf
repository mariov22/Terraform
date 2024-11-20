
variable "server_names" {
  type = set(string)
  default = ["server1", "server2", "server3"]
}

# Imagen base para las máquinas virtuales
variable "server_image" {
  type    = string
  default = "focal-server-clouding-amd64-vnx"
}

variable "dns_ip" {
  type    = string
  default = "8.8.8.8"
}

# Flavours de los diferentes servicios

variable "flavor_db" {
  type    = string
  default = "m1.smaller"
}

variable "flavor_admin" {
  type    = string
  default = "m1.smaller"
}

# Nombre de las redes y subredes
variable "Net_1" {
    description = "Nombre de la red 1"
    type = string
}

variable "Net_2" {
    description = "Nombre de la red 2"
    type = string
}

#### Servers parameters ####

variable "flavor_server" {
  type    = string
  default = "m1.smaller"
}

