# AWS RDS Module

This OpenTofu module creates and configures an AWS RDS instance with a dedicated subnet group.

## Features

- Creates an AWS RDS instance with configurable parameters
- Sets up a dedicated subnet group for the RDS instance
- Supports multiple database engines (MySQL, PostgreSQL, etc.)
- Configurable security settings, storage, and backup options

## Usage

```hcl
module "rds" {
  source = "./path/to/module"

  db_name          = "mydb"
  rds_name         = "my-rds-instance"
  master_username  = "admin"
  master_password  = "SecurePassword123"
  
  subnet_ids        = ["subnet-1234abcd", "subnet-5678efgh"]
  security_group_ids = ["sg-1234abcd"]
  
  allocated_storage = 20
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.small"
  
  cloud_tags = {
    Environment = "production"
    Owner       = "data-team"
  }
}
```

## Requirements

- OpenTofu >= 1.8.8
- AWS Provider

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| db_name | The name of the database to create when the DB instance is created | `string` | `"test"` | no |
| aws_default_region | The AWS region where resources will be created | `string` | `"us-east-1"` | no |
| rds_name | The name of the RDS instance | `string` | `"test-rds"` | no |
| db_subnet_name | The name of the DB subnet group | `string` | `"db_subnet_name"` | no |
| master_username | Username for the master DB user | `string` | `"admin101"` | no |
| master_password | Password for the master DB user | `string` | `"password101"` | no |
| security_group_ids | List of VPC security group IDs to associate with the RDS instance | `list(string)` | n/a | yes |
| subnet_ids | List of subnet IDs to include in the DB subnet group | `list(string)` | n/a | yes |
| allocated_storage | The allocated storage size in gibibytes (GiB) | `number` | `10` | no |
| engine | The database engine to use for the RDS instance | `string` | `"mysql"` | no |
| engine_version | The version of the database engine to use | `string` | `"5.7"` | no |
| instance_class | The instance type of the RDS instance | `string` | `"db.t2.micro"` | no |
| multi_az | Specifies if the RDS instance is multi-AZ | `bool` | `false` | no |
| storage_encrypted | Specifies whether the DB instance is encrypted | `bool` | `false` | no |
| port | The port on which the DB accepts connections | `number` | `3306` | no |
| publicly_accessible | Controls if the instance is publicly accessible | `bool` | `false` | no |
| storage_type | The type of storage to be used by the RDS instance (gp2, gp3, io1, standard) | `string` | `"gp2"` | no |
| skip_final_snapshot | Determines whether a final DB snapshot is created before the DB instance is deleted | `bool` | `true` | no |
| allow_major_version_upgrade | Indicates that major version upgrades are allowed | `bool` | `true` | no |
| auto_minor_version_upgrade | Indicates that minor engine upgrades will be applied automatically | `bool` | `true` | no |
| backup_retention_period | The days to retain backups for | `number` | `1` | no |
| maintenance_window | The window to perform maintenance in | `string` | `"Mon:00:00-Mon:03:00"` | no |
| backup_window | The daily time range during which automated backups are created | `string` | `"10:46-11:16"` | no |
| cloud_tags | Additional tags as a map to apply to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| db_subnet_group_name | The name of the DB subnet group |
| arn | The ARN of the RDS instance |
| publicly_accessible | Whether the DB instance is publicly accessible |
| availability_zone | The availability zone of the RDS instance |
| allocated_storage | The amount of allocated storage for the RDS instance |
| instance_class | The instance class of the RDS instance |
| performance_insights_enabled | Whether Performance Insights are enabled on the RDS instance |
| storage_type | The storage type of the RDS instance |
| multi_az | Whether the RDS instance is multi-AZ |
| engine | The database engine of the RDS instance |
| engine_version | The database engine version of the RDS instance |

## Security Considerations

- By default, the module creates an RDS instance that is not publicly accessible
- Remember to use strong passwords for the master user
- Consider enabling storage encryption for production environments
- For critical workloads, enable Multi-AZ deployment for high availability

## License

Copyright (C) 2025 Gary Leong <gary@config0.com>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, version 3 of the License.