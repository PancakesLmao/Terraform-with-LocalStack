output "instance_id" {
  value = aws_instance.backend.id
}

output "arn" {
  description = "ARN of the bucket"
  value       = aws_s3_bucket.frontend.arn
}

output "bucket_name" {
  description = "Name (id) of the bucket"
  value = aws_s3_bucket.frontend.bucket
}

output "website_url" {
  value = "http://${aws_s3_bucket.frontend.bucket}.localhost.localstack.cloud:4566"
}
output "direct_index_url" {
  value = "http://${aws_s3_bucket.frontend.bucket}.localhost:4566/index.html"
}

output "uploaded_files_count" {
  value = length(aws_s3_object.frontend_files)
}
