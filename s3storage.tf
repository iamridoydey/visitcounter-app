locals {
  webapp_path = "${path.module}/${var.webapp_path}"
}

resource "aws_s3_bucket" "storage" {
  bucket = "${var.app_name}-storage"
  region = var.default_region
  tags   = var.tag
}

resource "aws_s3_object" "static-object" {
  for_each = fileset(local.webapp_path, "**")
  bucket   = aws_s3_bucket.storage.bucket
  key      = "${local.webapp_path}/${each.value}"
  source   = "${local.webapp_path}/${each.value}"
  etag     = filemd5("${local.webapp_path}/${each.value}")

  # Explicitly set Content-Type based on extension
  content_type = lookup(
    {
      "html" = "text/html"
      "css"  = "text/css"
      "js"   = "application/javascript"
      "json" = "application/json"
      "png"  = "image/png"
      "jpg"  = "image/jpeg"
      "jpeg" = "image/jpeg"
      "svg"  = "image/svg+xml"
    },
    regex("\\.(\\w+)$", each.value)[0],
    "application/octet-stream"
  )
}
