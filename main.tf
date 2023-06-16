resource "aws_docdb_cluster" "main" {
  cluster_identifier      = "${vars.env}-docdb"
  engine                  = var.engine
  engine_version            = var.engine_version
  master_username         = data.aws_ssm_parameter.user.value
  master_password         = data.aws_ssm_parameter.user.value
  backup_retention_period = var.backup_retention_period
  preferred_backup_window = var.preferred_backup_window
  skip_final_snapshot     = var.skip_final_snapshot
  db_subnet_group_name    = aws_docdb_subnet_group.main.name
  kms_key_id = data.aws_kms_key.key.arn
  storage_encrypted =   var.aws_docdb_subnet_group
}

/* #When we need to create Cluster we need minimum two available zones, 
which need to be create **SUBNET GROUPS   . 
SUBNETS are tightly integrated with available zones.** 
    1 - due to that, we need to create sub-net groups. (aws_docdb_subnet_groups) */
resource "aws_docdb_subnet_group" "main" {
  name       =  "${vars.env}-docdb"
  subnet_ids = var.subnet_ids

  tags = merge(
    var.tags,
    { Name = "${var.env}-subnet-group" }
  )
}