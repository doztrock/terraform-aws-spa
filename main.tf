provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "bucket" {
  bucket = "bucket.sundevs.cloud"
  acl    = "private"
  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    sid       = "0"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
    }
  }

}

resource "aws_s3_bucket_policy" "example" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

resource "aws_s3_bucket_object" "file" {
  bucket       = aws_s3_bucket.bucket.id
  key          = "index.html"
  source       = "index.html"
  content_type = "text/html"
  acl          = "private"
  etag         = filemd5("index.html")
}

resource "aws_s3_bucket_object" "image" {
  bucket       = aws_s3_bucket.bucket.id
  key          = "image.png"
  source       = "image.png"
  content_type = "image/png"
  acl          = "private"
  etag         = filemd5("image.png")
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = "PriceClass_All"
  default_root_object = "index.html"
  aliases = [
    "bucket.sundevs.cloud"
  ]
  origin {
    domain_name = aws_s3_bucket.bucket.bucket_domain_name
    origin_id   = format("S3-%s", aws_s3_bucket.bucket.bucket)
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = format("S3-%s", aws_s3_bucket.bucket.bucket)
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
    viewer_protocol_policy = "redirect-to-https"
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
    acm_certificate_arn      = "arn:aws:acm:us-east-1:766242209032:certificate/d3abcbcd-3add-4f1e-9c36-c011a23df8b3"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2018"
  }
  logging_config {
    bucket          = "sundevsrepositories.s3-us-west-2.amazonaws.com"
    prefix          = "bucket.sundevs.cloud"
    include_cookies = false
  }
}
