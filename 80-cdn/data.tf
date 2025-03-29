data "aws_cloudfront_cache_policy" "noCache" {
  name = "Managed-CachingDisabled"
}

data "aws_cloudfront_cache_policy" "cacheOptmised" {
  name = "Managed-CachingOptimized"
}

data "aws_ssm_parameter" "certificate_arn" {
  name  = "${local.ssm_prefix}/certificate/arn"
}