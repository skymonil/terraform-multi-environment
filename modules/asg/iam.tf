# Get AWS account details
data "aws_caller_identity" "current" {}

#######################################
# IAM Role for EC2 SSM Access
#######################################
resource "aws_iam_role" "ec2_ssm_role" {
  name = "EC2SSMAccessRole-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

#######################################
# KMS Key for decrypting SSM secrets
#######################################


resource "aws_kms_key_policy" "ssm_kms_policy" {
  key_id = aws_kms_key.ssm_kms_key.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowRootAccountFullAccess",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action   = "kms:*",
        Resource = "*"
      },
      {
  Sid    = "AllowEC2SSMDecryptAccess",
  Effect = "Allow",
  Principal = {
    AWS = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/EC2SSMAccessRole-prod",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/EC2SSMAccessRole-staging"
    ]
  },
  Action   = ["kms:Decrypt"],
  Resource = "*"
}

    ]
  })
}

#######################################
# IAM Policy to allow EC2 role to decrypt KMS
#######################################
resource "aws_iam_policy" "kms_decrypt_policy" {
  name        = "KMSDecryptPolicy-${var.environment}"
  description = "Allow EC2 role to decrypt with KMS key"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["kms:Decrypt"],
        Resource = aws_kms_key.ssm_kms_key.arn
      }
    ]
  })
}

#######################################
# Attach KMS Decrypt Policy to EC2 Role
#######################################
resource "aws_iam_policy_attachment" "kms_decrypt_attach" {
  name       = "AttachKMSDecryptPolicy-${var.environment}"
  roles      = [aws_iam_role.ec2_ssm_role.name]
  policy_arn = aws_iam_policy.kms_decrypt_policy.arn
}

#######################################
# Attach SSM Managed Policy to EC2 Role
#######################################
resource "aws_iam_policy_attachment" "ssm_access" {
  name       = "SSMAccess-${var.environment}"
  roles      = [aws_iam_role.ec2_ssm_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

#######################################
# IAM Instance Profile for EC2
#######################################
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "EC2InstanceProfile-${var.environment}"
  role = aws_iam_role.ec2_ssm_role.name
}
