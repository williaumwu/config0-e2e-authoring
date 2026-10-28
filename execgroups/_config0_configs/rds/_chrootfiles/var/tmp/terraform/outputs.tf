# The module does not output publicly_accessible, allocated_storage,
# instance_class, storage_type or multi_az; those are the values this
# execgroup hands it.

output "db_subnet_group_name" {
  description = "The name of the DB subnet group"
  value       = module.db.db_subnet_group_id
}

output "arn" {
  description = "The ARN of the RDS instance"
  value       = module.db.db_instance_arn
}

output "publicly_accessible" {
  description = "Whether the DB instance is publicly accessible"
  value       = var.publicly_accessible
}

output "availability_zone" {
  description = "The availability zone of the RDS instance"
  value       = module.db.db_instance_availability_zone
}

output "allocated_storage" {
  description = "The amount of allocated storage for the RDS instance"
  value       = var.allocated_storage
}

output "instance_class" {
  description = "The instance class of the RDS instance"
  value       = var.instance_class
}

output "performance_insights_enabled" {
  description = "Whether Performance Insights are enabled on the RDS instance"
  # The module's default: this execgroup never turns Performance Insights on.
  value = false
}

output "storage_type" {
  description = "The storage type of the RDS instance"
  value       = var.storage_type
}

output "multi_az" {
  description = "Whether the RDS instance is multi-AZ"
  value       = var.multi_az
}

output "engine" {
  description = "The database engine of the RDS instance"
  value       = module.db.db_instance_engine
}

output "engine_version" {
  description = "The database engine version of the RDS instance"
  value       = module.db.db_instance_engine_version_actual
}

output "endpoint" {
  description = "The connection endpoint of the RDS instance, address:port"
  value       = module.db.db_instance_endpoint
}

output "address" {
  description = "The host name of the RDS instance"
  value       = module.db.db_instance_address
}

output "port" {
  description = "The port the RDS instance listens on"
  value       = module.db.db_instance_port
}

output "master_user_secret_arn" {
  description = "The ARN of the Secrets Manager secret that holds the master user name and password"
  value       = module.db.db_instance_master_user_secret_arn
}
