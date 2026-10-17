# The RDS instance and its subnet group, through the community module.
module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "7.2.2"

  identifier = var.rds_name

  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  storage_type      = var.storage_type
  storage_encrypted = var.storage_encrypted
  port              = var.port

  db_name  = var.db_name
  username = var.rds_master_username

  # RDS makes the master password, keeps it in AWS Secrets Manager and deletes
  # it with the instance. Config0 never makes, sees or stores it. Rotation is
  # what RDS does by default for this secret, every seven days: the module's
  # manage_master_user_password_rotation stays false and adds no schedule.
  manage_master_user_password = true

  vpc_security_group_ids = var.security_group_ids
  multi_az               = var.multi_az
  publicly_accessible    = var.publicly_accessible

  iam_database_authentication_enabled = var.iam_database_authentication_enabled

  allow_major_version_upgrade = var.allow_major_version_upgrade
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade

  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  maintenance_window      = var.maintenance_window

  # From the stack: the module's own default (skip_final_snapshot = false)
  # leaves a final snapshot behind after every destroy.
  skip_final_snapshot = var.skip_final_snapshot
  deletion_protection = var.deletion_protection

  create_db_subnet_group          = true
  db_subnet_group_name            = var.db_subnet_name
  db_subnet_group_use_name_prefix = false
  db_subnet_group_description     = "Subnet group for RDS instance ${var.rds_name}"
  subnet_ids                      = var.subnet_ids

  # The engine's default parameter group and option group, as before the
  # module. A custom group needs the parameter group family and the major
  # engine version, and both differ per engine and version.
  create_db_parameter_group = false
  create_db_option_group    = false

  tags = merge(
    var.cloud_tags,
    {
      Product = "rds"
    },
  )

  # The subnet group module tags its group Name = db_subnet_name itself.
  db_instance_tags = {
    Name = var.rds_name
  }
}
