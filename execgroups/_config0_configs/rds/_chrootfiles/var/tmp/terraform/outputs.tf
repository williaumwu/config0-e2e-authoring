output "db_subnet_group_name" {
  description = "The name of the DB subnet group"
  value       = aws_db_instance.default.db_subnet_group_name
}

output "arn" {
  description = "The ARN of the RDS instance"
  value       = aws_db_instance.default.arn
}

output "publicly_accessible" {
  description = "Whether the DB instance is publicly accessible"
  value       = aws_db_instance.default.publicly_accessible
}

output "availability_zone" {
  description = "The availability zone of the RDS instance"
  value       = aws_db_instance.default.availability_zone
}

output "allocated_storage" {
  description = "The amount of allocated storage for the RDS instance"
  value       = aws_db_instance.default.allocated_storage
}

output "instance_class" {
  description = "The instance class of the RDS instance"
  value       = aws_db_instance.default.instance_class
}

output "performance_insights_enabled" {
  description = "Whether Performance Insights are enabled on the RDS instance"
  value       = aws_db_instance.default.performance_insights_enabled
}

output "storage_type" {
  description = "The storage type of the RDS instance"
  value       = aws_db_instance.default.storage_type
}

output "multi_az" {
  description = "Whether the RDS instance is multi-AZ"
  value       = aws_db_instance.default.multi_az
}

output "engine" {
  description = "The database engine of the RDS instance"
  value       = aws_db_instance.default.engine
}

output "engine_version" {
  description = "The database engine version of the RDS instance"
  value       = aws_db_instance.default.engine_version
}