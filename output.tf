output "bucket" {
  description = "Bucket donde se encuentra el contenido."
  value       = var.bucket
}

output "cloudfront" {
  description = "Distribucion de CloudFront."
  value       = var.logging.bucket != null ? aws_cloudfront_distribution.distribution-with-logging : aws_cloudfront_distribution.distribution-without-logging
}
