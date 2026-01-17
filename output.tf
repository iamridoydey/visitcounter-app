output "name_servers" {
  description = "Name servers for the hosted zone"
  value = aws_route53_zone.hosted_zone.name_servers
}


output "lambda_function_url" {
  description = "Public HTTPS endpoint for the visit counter Lambda"
  value       = aws_lambda_function_url.visitcounter_url.function_url
}


output "cloudfront_dns" {
  description = "Cloudfront dns"
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}