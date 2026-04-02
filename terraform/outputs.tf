output "instance_id" {
  value = aws_instance.demo.id
}

output "bucket_name" {
  value = aws_s3_bucket.frontend.bucket
}

output "uploaded_files_count" {
  value = length(aws_s3_object.frontend_files)
}