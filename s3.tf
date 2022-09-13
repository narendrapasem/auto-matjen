//role
resource "aws_iam_role" "s3role" {
  name = "s3role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "s3ec2"
  }
}
//policy

resource "aws_iam_policy" "s3poly" {
  name        = "test_s3poly"
  path        = "/"
  description = "My test s3poly"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ropo-attach" {
  role       = aws_iam_role.s3role.name
  policy_arn = aws_iam_policy.s3poly.arn
}


resource "aws_s3_bucket" "b" {
  bucket = "lenin-bucket"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_iam_instance_profile" "test_profile" {
  name = "test_profile"
  role = aws_iam_role.s3role.name
}