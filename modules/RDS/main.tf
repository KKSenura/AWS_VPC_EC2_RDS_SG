module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "5.9.0"
  # insert the 1 required variable here
  identifier = infradb
  engine = "mysql"
  engine_version = "5.7.19"
  instance_class = "db.t2.micro"
  allocated_storage = 5
  name = "INFRA"
  username = "infra"
  password = "Infra123"
  port = 3306
  skip_final_snapshot = true
  
  vpc_security_group_ids = aws_security_group.vpc-sg.id
  subnet_ids = aws_subnet.private-a1.id
  multi_az = true

  #DB Parameter Group
  family = "mysql5.7"

  #DB Option group
  option_group_name = "mysql5-7-option-group"
  
  major_engine_version = "5.7"

}