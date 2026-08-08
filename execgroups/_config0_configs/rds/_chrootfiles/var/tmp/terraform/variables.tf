variable "db_name" {
  description = "The name of the database to create when the DB instance is created"
  type        = string
  default     = "test"
}

variable "aws_default_region" {
  description = "The AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "rds_name" {
  description = "The name of the RDS instance"
  type        = string
  default     = "test-rds"
}

variable "db_subnet_name" {
  description = "The name of the DB subnet group"
  type        = string
  default     = "db_subnet_name"
}

variable "master_username" {
  description = "Username for the master DB user"
  type        = string
  default     = "admin101"
  sensitive   = true
}

variable "master_password" {
  description = "Password for the master DB user"
  type        = string
  default     = "password101"
  sensitive   = true
}

variable "security_group_ids" {
  type        = list(string)
  description = "List of VPC security group IDs to associate with the RDS instance"
}

variable "subnet_ids" {
  description = "List of subnet IDs to include in the DB subnet group"
  type        = list(string)
}

variable "allocated_storage" {
  description = "The allocated storage size in gibibytes (GiB)"
  type        = number
  default     = 10
}

variable "engine" {
  description = "The database engine to use for the RDS instance"
  type        = string
  default     = "mysql"
}

variable "engine_version" {
  description = "The version of the database engine to use"
  type        = string
  default     = "5.7"
}

variable "instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
  default     = "db.t2.micro"
}

variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = bool
  default     = false
}

variable "storage_encrypted" {
  description = "Specifies whether the DB instance is encrypted"
  type        = bool
  default     = false
}

variable "port" {
  description = "The port on which the DB accepts connections"
  type        = number
  default     = 3306
}

variable "publicly_accessible" {
  description = "Controls if the instance is publicly accessible"
  type        = bool
  default     = false
}

variable "storage_type" {
  description = "The type of storage to be used by the RDS instance (gp2, gp3, io1, standard)"
  type        = string
  default     = "gp2"
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted"
  type        = bool
  default     = true
}

variable "allow_major_version_upgrade" {
  description = "Indicates that major version upgrades are allowed"
  type        = bool
  default     = true
}

variable "auto_minor_version_upgrade" {
  description = "Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window"
  type        = bool
  default     = true
}

variable "cloud_tags" {
  description = "Additional tags as a map to apply to all resources"
  type        = map(string)
  default     = {}
}

/*
variable "backup_retention_period" {
  description = "The days to retain backups for"
  type        = number
  default     = 1
}

variable "backup_window" {
  description = "The daily time range during which automated backups are created"
  type        = string
  default     = "10:46-11:16"
}

variable "maintenance_window" {
  description = "The window to perform maintenance in"
  type        = string
  default     = "Mon:00:00-Mon:03:00"
}
*/

