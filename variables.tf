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


variable "certificate" {
}

variable "tls-version" {
  default = "TLSv1.2_2018"
}

variable "protocol-policy" {
  default = "redirect-to-https"
}



