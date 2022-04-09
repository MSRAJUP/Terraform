variable "secret_key" {
  default = "yPNR90bo1SqsTTjiqFVT1RT1VDbvmn8npM0Y2z7k"
}
variable "access_key" {
  default = "AKIAZQRFDCXWZ6BCO6X3"
}
variable "vpc_name" {
  default = "test_vpc"
}
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
variable "public_subnet" {
  default = "10.0.1.0/24"
}
variable "private_subnet" {
  default = "10.0.2.0/24"
}
variable "internet_gateway" {
    default = "IGW"
}
