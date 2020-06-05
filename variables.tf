variable "bucket" {
  description = "Bucket donde se encuentra el contenido."
}

variable "document_default" {
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

variable "document" {
  description = "Configuracion personalizada para el parametro website."
}

variable "alias" {
  description = "Listado de registros CNAME asociados al CloudFront."
}

variable "certificate" {
  description = "ARN del certificado SSL."
}

variable "protocol_version" {
  description = "Version de TLS."
  default     = "TLSv1.2_2018"
}

variable "protocol_policy" {
  description = "Politica de manejo de HTTPS, puede ser allow-all, https-only o redirect-to-https"
  default     = "redirect-to-https"
}

variable "allowed_methods" {
  description = "Listado de metodos que seran procesados por CloudFront."
  default     = ["GET", "HEAD"]
}

variable "cached_methods" {
  description = "Listado de metodos que seran cacheados por CloudFront."
  default     = ["GET", "HEAD"]
}

variable "logging" {
  description = "Bucket donde se almacenaran los logs."
  type = object({
    bucket = string
  })
  default = {
    bucket = null
  }
}
