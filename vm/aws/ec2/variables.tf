variable "subnet_name" {
  type        = string
  description = "(optional) describe your variable"
}
variable "sg_names" {
  type        = list(string)
  description = "(optional) describe your variable"
}
variable "env" {
  type        = string
  description = "(optional) describe your variable"
}
variable "tier" {
  type        = string
  description = "(optional) describe your variable"
}
variable "create_key_pair" {
  type        = bool
  description = "(optional) describe your variable"
  default     = false
}
variable "user_data_path" {
  type        = string
  description = "(optional) describe your variable"
}
