variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "bucket_versioning" {
  description = "Enable versioning for S3 bucket"
  type        = bool
  default     = true
}