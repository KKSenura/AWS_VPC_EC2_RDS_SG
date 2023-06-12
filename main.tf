

resource "aws_vpc" "customVPC" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "MyCustomVPC"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.customVPC.id

  tags = {
    Name = "MyIGW"
  }
}

resource "aws_route_table" "routeIGW" {
  vpc_id     = aws_vpc.customVPC.id
  # route_table_id            = aws_vpc.customVPC.main_route_table_id
  route{
  cidr_block    = "0.0.0.0/0" #internet gateway
  gateway_id    = aws_internet_gateway.igw.id 
  }
}


# resource "aws_route" "r" {
#   route_table_id            = "rtb-4fbb3ac4"
#   destination_cidr_block    = "10.0.1.0/22"
#   vpc_peering_connection_id = "pcx-45ff3dc1"
#   depends_on                = [aws_route_table.testing]
# }


#subnet association adding subnet to the route table
resource "aws_route_table_association" "rt_associate_public_a" {
    subnet_id = aws_subnet.pub-a.id
    route_table_id = aws_route_table.routeIGW.id
}

resource "aws_route_table_association" "rt_associate_public_b" {
    subnet_id = aws_subnet.pub-b.id
    route_table_id = aws_route_table.routeIGW.id
}

#Creating a public subnet
resource "aws_subnet" "pub-a" {
  vpc_id     = aws_vpc.customVPC.id
  cidr_block = "10.0.0.0/19"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public - a"
  }
}

#Creating a public subnet
resource "aws_subnet" "pub-b" {
  vpc_id     = aws_vpc.customVPC.id
  cidr_block = "10.0.32.0/19"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public - b"
  }
}

#Creating a Private subnet
resource "aws_subnet" "private-a1" {
  vpc_id     = aws_vpc.customVPC.id
  cidr_block = "10.0.64.0/19"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private - a1"
  }
}

#Creating a Private subnet
resource "aws_subnet" "private-b1" {
  vpc_id     = aws_vpc.customVPC.id
  cidr_block = "10.0.96.0/19"
  availability_zone = "us-east-1b"

  tags = {
    Name = "private - b1"
  }
}
#--------------------------------------------------------private subnet
#Creating a Private subnet
resource "aws_subnet" "private-a2" {
  vpc_id     = aws_vpc.customVPC.id
  cidr_block = "10.0.128.0/19"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private - a2"
  }
}

#Creating a Private subnet
resource "aws_subnet" "private-b2" {
  vpc_id     = aws_vpc.customVPC.id
  cidr_block = "10.0.160.0/19"
  availability_zone = "us-east-1b"

  tags = {
    Name = "private - b2"
  }
}
#-------------------------------------------------------private subnet
################################
#Creating a Private subnet
# resource "aws_subnet" "private-b29" {
#   vpc_id     = aws_vpc.customVPC.id
#   cidr_block = "10.0.192.0/19"
#   availability_zone = "us-east-1b"

#   tags = {
#     Name = "private - b29"
#   }
# }

# #Creating a Private subnet
# resource "aws_subnet" "private-b28" {
#   vpc_id     = aws_vpc.customVPC.id
#   cidr_block = "10.0.224.0/19"
#   availability_zone = "us-east-1b"

#   tags = {
#     Name = "private - b28"
#   }
# }

# #route table for the private subnet

# resource "aws_route" "rt_private" {
#   route_table_id            = aws_vpc.customVPC.main_route_table_id
#   # tags = {
#   #   Name = "Route table for private subnet"
#   # }
# }

# resource "aws_route_table_association" "rt_associate_private_1" {
#     subnet_id = aws_subnet.private-a.id
#     route_table_id = aws_route_table.rt_private.id
# }


#security group
resource "aws_security_group" "vpc-sg" {
  name        = "vpc-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.customVPC.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_instance" "ec2-public1" {
  ami           = "ami-0715c1897453cabd1"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.pub-a.id
  #aws_subnet.pub-a.id
  vpc_security_group_ids = [aws_security_group.vpc-sg.id]

  tags = {
    Name = "ec2 created in public_a"
  }
}

resource "aws_instance" "ec2-private1" {
  ami           = "ami-0715c1897453cabd1"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.private-a1.id
  vpc_security_group_ids = [aws_security_group.vpc-sg.id]

  tags = {
    Name = "ec2 created in private_a"
  }
}

# module "rds" {

#   source = "./modules/RDS"

# }


resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = ["${aws_subnet.private-a1.id}", "${aws_subnet.private-b1.id}"]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_security_group" "db_sg" {

  name = "db_sg_name"
  description = "security group for the database"
  vpc_id = aws_vpc.customVPC.id

  # ingress = {

  #   description = "allow Mysql traffic"
  #   from_port = "3306"
  #   to_port = "3306"
  #   protocol = "tcp"
  #   aws_security_group = [aws_security_group.vpc-sg.id]
  # }
  
  tags = {
    Name = "database_sg"
  }

}


resource "aws_db_instance" "rds" {
  # source  = "terraform-aws-modules/rds/aws"
  # version = "5.9.0"
  # insert the 1 required variable here
  identifier = "infradb"
  engine = "mysql"
  engine_version = "8.0.32"
  instance_class = "db.t2.micro"
  allocated_storage = 5
  # name = "INFRA"
  username = "infra"
  password = "Infra123"
  port = 3306
  skip_final_snapshot = true
  db_subnet_group_name = aws_db_subnet_group.default.id
  # vpc_security_group_ids = aws_security_group.vpc-sg.id
  # subnet_ids = aws_subnet.private-a1.id
  multi_az = true

  # #DB Parameter Group
  # family = "mysql5.7"

  # #DB Option group
  # option_group_name = "mysql5-7-option-group"
  
  # major_engine_version = "5.7"
}

