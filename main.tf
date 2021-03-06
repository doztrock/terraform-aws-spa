locals {
  document = merge(var.document_default, var.document)
}

resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket
  acl    = "private"
  website {
    index_document = local.document.index
    error_document = local.document.error
  }
}

resource "aws_cloudfront_origin_access_identity" "identity" {
}

data "aws_iam_policy_document" "policy" {
  statement {
    sid = "0"
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "${aws_s3_bucket.bucket.arn}/*"
    ]
    principals {
      type = "AWS"
      identifiers = [
        aws_cloudfront_origin_access_identity.identity.iam_arn
      ]
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.policy.json
}

resource "aws_cloudfront_distribution" "distribution-with-logging" {
  count               = var.logging.bucket == null ? 0 : 1
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = "PriceClass_All"
  default_root_object = local.document.index
  aliases             = var.alias
  origin {
    domain_name = aws_s3_bucket.bucket.bucket_domain_name
    origin_id   = format("S3-%s", aws_s3_bucket.bucket.bucket)
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.identity.cloudfront_access_identity_path
    }
  }
  default_cache_behavior {
    allowed_methods  = var.allowed_methods
    cached_methods   = var.cached_methods
    target_origin_id = format("S3-%s", aws_s3_bucket.bucket.bucket)
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
    viewer_protocol_policy = var.protocol_policy
  }
  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    acm_certificate_arn      = var.certificate
    ssl_support_method       = "sni-only"
    minimum_protocol_version = var.protocol_version
  }
  logging_config {
    bucket = var.logging.bucket
    prefix = aws_s3_bucket.bucket.bucket
  }
}

resource "aws_cloudfront_distribution" "distribution-without-logging" {
  count               = var.logging.bucket == null ? 1 : 0
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = "PriceClass_All"
  default_root_object = local.document.index
  aliases             = var.alias
  origin {
    domain_name = aws_s3_bucket.bucket.bucket_domain_name
    origin_id   = format("S3-%s", aws_s3_bucket.bucket.bucket)
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.identity.cloudfront_access_identity_path
    }
  }
  default_cache_behavior {
    allowed_methods  = var.allowed_methods
    cached_methods   = var.cached_methods
    target_origin_id = format("S3-%s", aws_s3_bucket.bucket.bucket)
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
    viewer_protocol_policy = var.protocol_policy
  }
  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    acm_certificate_arn      = var.certificate
    ssl_support_method       = "sni-only"
    minimum_protocol_version = var.protocol_version
  }
}
