# terraform-aws-spa

Modulo de terraform creado con la intencion de facilitar la generacion de una *single-page application (SPA)* junto a sus respectivos recursos.

Listado de recursos:

- S3 BUCKET
- CLOUDFRONT DISTRIBUTION

Se puede decidir crear entre crear una distribucion con *logging* activado o desactivado, de acuerdo a las necesidades.

### Ejemplo #1

Creacion de una SPA asociada al dominio `bucket.sundevs.cloud`, con **logging activado**.

```java
provider "aws" {
  region = "us-east-1"
}

module "spa" {
  source  = "app.terraform.io/sundevs/vpc/spa"
  version = "1.0.0"
  bucket = "bucket-sundevs-cloud"
  document = {
    index = "index.html"
    error = "error.html"
  }
  certificate = "arn:aws:acm:region:account:certificate"
  alias = [
    "bucket.sundevs.cloud"
  ]
  logging = {
    bucket = "logging.s3-region.amazonaws.com"
  }
}
```

### Ejemplo #2

Creacion de una SPA asociada al dominio `spa.sundevs.cloud` con **logging desactivado**, a su vez subimos los archivos `index.html` y `error.html`.

```java
provider "aws" {
  region = "us-east-1"
}

module "spa" {
  source  = "app.terraform.io/sundevs/vpc/spa"
  version = "1.0.0"
  bucket = "spa-sundevs-cloud"
  document = {
    index = "index.html"
    error = "error.html"
  }
  certificate = "arn:aws:acm:region:account:certificate"
  alias = [
    "spa.sundevs.cloud"
  ]
}

resource "aws_s3_bucket_object" "index" {
  bucket       = module.spa.bucket
  key          = "index.html"
  source       = "index.html"
  content_type = "text/html"
  etag         = filemd5("index.html")
}

resource "aws_s3_bucket_object" "error" {
  bucket       = module.spa.bucket
  key          = "error.html"
  source       = "error.html"
  content_type = "text/html"
  etag         = filemd5("error.html")
}
```

### Ejemplo #3

Creacion de una SPA asociada a los dominios `spa0.sundevs.cloud`, `spa1.sundevs.cloud`, `spa2.sundevs.cloud` con **logging desactivado**, a su vez subimos el archivo `index.html`.

```java
provider "aws" {
  region = "us-east-1"
}

module "spa" {
  source  = "app.terraform.io/sundevs/vpc/spa"
  version = "1.0.0"
  bucket = "spa-sundevs-cloud"
  document = {
    index = "index.html"
  }
  certificate = "arn:aws:acm:region:account:certificate"
  alias = [
    "spa0.sundevs.cloud",
    "spa1.sundevs.cloud",
    "spa2.sundevs.cloud"
  ]
}

resource "aws_s3_bucket_object" "index" {
  bucket       = module.spa.bucket
  key          = "index.html"
  source       = "index.html"
  content_type = "text/html"
  etag         = filemd5("index.html")
}
```

### Ejemplo #4

Creacion de una SPA con todas las opciones que se pueden usar en el modulo, la mayoria de estas se encuentran configuradas por defecto para ajustarse a la configuracion estandar.

```java
provider "aws" {
  region = "us-east-1"
}

module "spa" {
  source  = "app.terraform.io/sundevs/vpc/spa"
  version = "1.0.0"
  bucket = "spa-sundevs-cloud"
  document = {
    index = "index.html"
    error = "error.html"
  }
  certificate = "arn:aws:acm:region:account:certificate"  
  protocol_version = "TLSv1.2_2018"
  protocol_policy = "redirect-to-https"
  allowed_methods = [
	"GET", "HEAD"
  ]
  cached_methods = [
	"GET", "HEAD"
  ]
  alias = [
    "spa.sundevs.cloud"
  ]
}

resource "aws_s3_bucket_object" "index" {
  bucket       = module.spa.bucket
  key          = "index.html"
  source       = "index.html"
  content_type = "text/html"
  etag         = filemd5("index.html")
}

resource "aws_s3_bucket_object" "error" {
  bucket       = module.spa.bucket
  key          = "error.html"
  source       = "error.html"
  content_type = "text/html"
  etag         = filemd5("error.html")
}
```
