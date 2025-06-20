resource "aws_kms_key" "ssm_kms_key" {
  description             = "KMS key for SSM parameters"
  enable_key_rotation     = true
  deletion_window_in_days = 30
}

resource "aws_ssm_parameter" "HCP_CLIENT_ID" {
  name   = "/app/${var.environment}/HCP_CLIENT_ID"
  type   = "SecureString"
  value  = var.HCP_CLIENT_ID
  key_id = aws_kms_key.ssm_kms_key.arn
}

resource "aws_ssm_parameter" "HCP_CLIENT_SECRET" {
  name   = "/app/${var.environment}/HCP_CLIENT_SECRET"
  type   = "SecureString"
  value  = var.HCP_CLIENT_SECRET
  key_id = aws_kms_key.ssm_kms_key.arn
}
