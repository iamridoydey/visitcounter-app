variable "app_name" {
  description = "Application Name"
  type = string
  default = "visitcounter"
}

variable "default_region" {
  description = "Default region"
  type = string
  default = "us-east-1"
}

variable "webapp_path" {
  description = "Webapp files path"
  type = string
  default = "webapp"
}

variable "tag" {
  description = "Tag"
  type = map(string)
  default = {
    "App" = "visitcounter"
  }
}

variable "domain_name" {
  description = "Domain name"
  type = string
  default = "visitcounter.foo"
}