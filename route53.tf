data "aws_caller_identity" "current" {}

resource "aws_kms_key" "kms_key" {
  customer_master_key_spec = "ECC_NIST_P256"
  deletion_window_in_days  = 7
  key_usage                = "SIGN_VERIFY"
  policy = jsonencode({
    Statement = [
      {
        Action = [
          "kms:DescribeKey",
          "kms:GetPublicKey",
          "kms:Sign",
          "kms:Verify",
        ],
        Effect = "Allow"
        Principal = {
          Service = "dnssec-route53.amazonaws.com"
        }
        Resource = "*"
        Sid      = "Allow Route 53 DNSSEC Service",
      },
      {
        Action = "kms:*"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Resource = "*"
        Sid      = "Enable IAM User Permissions"
      },
    ]
    Version = "2012-10-17"
  })
}

# Aws route53 hosted zone
resource "aws_route53_zone" "hosted_zone" {
  name = var.domain_name
}

resource "aws_route53_key_signing_key" "signing_key" {
  hosted_zone_id             = aws_route53_zone.hosted_zone.id
  key_management_service_arn = aws_kms_key.kms_key.arn
  name                       = "signing-key"
}

resource "aws_route53_hosted_zone_dnssec" "hosted_zone_dnssec" {
  depends_on     = [aws_route53_key_signing_key.signing_key]
  hosted_zone_id = aws_route53_zone.hosted_zone.id
}

