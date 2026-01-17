resource "aws_dynamodb_table" "visitcounter-db-table" {
  name           = "${var.app_name}-db-table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = var.tag
}


# IAM policy for DynamoDB access
data "aws_iam_policy_document" "dynamodb_policy" {
  statement {
    effect = "Allow"

    actions = [
      "dynamodb:UpdateItem",
      "dynamodb:GetItem"
    ]

    resources = [
      aws_dynamodb_table.visitcounter-db-table.arn
    ]
  }
}

resource "aws_iam_policy" "lambda_dynamodb_policy" {
  name   = "lambda-dynamodb-policy"
  policy = data.aws_iam_policy_document.dynamodb_policy.json
}