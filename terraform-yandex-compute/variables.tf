variable "instance_count" {
  description = "Yandex Cloud Compute instance count"
  type        = number
  default     = 1
}

variable "platform_id" {
  description = "The type of virtual machine to create"
  type        = string
  default     = "standard-v3"
}

variable "image_family" {
  description = "Yandex Cloud Compute Image family"
  type        = string
}

variable "zone" {
  description = "Yandex Cloud Zone for provision resources"
  type        = string
}

variable "name" {
  description = "Yandex Cloud Compute instance name"
  type        = string
}

# The hostname must be unique within the network and region
# If not specified, the host name will be equal to id of the instance and fqdn will be <id>.auto.internal
# Otherwise FQDN will be <hostname>.<region_id>.internal
variable "hostname" {
  description = "Host name for the instance. This field is used to generate the instance fqdn value"
  type        = string
}

# Preemtible VM: https://cloud.yandex.ru/docs/compute/concepts/preemptible-vm
variable "preemptible" {
  description = "Specifies if the instance is preemptible"
  type        = bool
  default     = false
}

variable "allow_stopping_for_update" {
  description = "If true, allows Terraform to stop the instance in order to update its properties. If you try to update a property that requires stopping the instance without setting this field, the update will fail."
  type        = bool
  default     = false
}

variable "is_nat" {
  description = "Provide a public address for instance to access the internet over NAT"
  type        = bool
  default     = false
}

variable "size" {
  description = "Size of the boot disk in GB"
  type        = string
  default     = "10"
}

variable "type" {
  description = "Type of the boot disk"
  type        = string
  default     = "network-ssd"
}

variable "cores" {
  description = "CPU cores for the instance"
  type        = number
  default     = 2
}

variable "memory" {
  description = "Memory size for the instance in GB"
  type        = number
  default     = 2
}

variable "core_fraction" {
  description = "Baseline performance for a core as a percent"
  type        = number
  default     = 100
}

variable "subnet_id" {
  description = "Yandex VPC subnet_id"
  type        = string
}

# IP address should be already reserved in web UI
variable "nat_ip_address" {
  description = "Public IP address for instance to access the internet over NAT"
  type        = string
  default     = ""
}

variable "description" {
  description = "Description of instance"
  type        = string
  default     = ""
}

variable "ip_address" {
  description = "The private IP address to assign to the instance. If empty, the address will be automatically assigned from the specified subnet"
  type        = string
  default     = ""
}

variable "folder_id" {
  description = "The ID of the folder that the resource belongs to. If it is not provided, the default provider folder is used."
  type        = string
  default     = ""
}

variable "service_account_id" {
  description = "ID of the service account authorized for this instance."
  type        = string
  default     = ""
}

variable "user" {
  description = "User for access to the instance"
  type        = string
  default     = "ubuntu"
}

variable "ssh_pubkey" {
  description = "SSH public key for access to the instance"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "private_key" {
  description = "SSH private key for access to the instance"
  type        = string
  default     = "~/.ssh/id_rsa"
}

variable "type_remote_exec" {
  description = "Type connection for remote-exec"
  type        = string
  default     = "ssh"
}

variable "password" {
  description = "Password parameter for remote-exec"
  type        = string
  default     = ""
}

variable "https" {
  description = "HTTPS parameter for remote-exec"
  type        = string
  default     = ""
}

variable "port" {
  description = "Port parameter for remote-exec"
  type        = string
  default     = "22"
}

variable "insecure" {
  description = "Insecure parameter for remote-exec"
  type        = string
  default     = ""
}

variable "timeout" {
  description = "Timeout parameter for remote-exec"
  type        = string
  default     = ""
}

variable "user-data" {
  description = "User-data parameter for metadata"
  type        = string
  default     = ""
}

variable "serial-port-enable" {
  description = "Serial-port-enable parameter for metadata"
  type        = number
  default     = null
}

variable "labels" {
  description = "A set of key/value label pairs to assign to the instance."
  type        = map(string)
  default     = {}
}

variable "secondary_disk" {
  description = "Additional secondary disk to attach to the instance"
  type        = map(map(string))
  default     = {}
}
