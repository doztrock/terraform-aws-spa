variable "bucket" {
  description = "Bucket"
}

variable "content_default" {
  description = "Configuracion por defecto para el parametro website."
  type = object({
    index = string
    error = string
  })
  default = {
    index = "index.html"
    error = null
  }
}

variable "content" {
  description = "Configuracion personalizada para el parametro website."
}

variable "cdn" {
  default = []
}

variable "certificate_arn" {
}

variable "protocol_version" {
  default = "TLSv1.2_2018"
}

variable "protocol_policy" {
  default = "redirect-to-https"
}

variable "allowed_methods" {
  default = ["GET", "HEAD"]
}

variable "cached_methods" {
  default = ["GET", "HEAD"]
}

variable "logging" {
  type = object({
    bucket = string
  })
}
