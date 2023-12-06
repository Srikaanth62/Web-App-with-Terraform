docdb = {
  main ={
    subnet_name    = "db"
    allow_db_cidr  = "app"
    engine_version = "4.0.0"
    instance_count = 1
    instance_class = "db.t3.medium"
  }
}

rds = {
  main ={
    subnet_name    = "db"
    allow_db_cidr  = "app"
    engine_version = "5.7.mysql_aurora.2.11.2"
    instance_count = 1
    instance_class = "db.t3.small"
  }
}

elasticache = {
  main ={
    subnet_name    = "db"
    allow_db_cidr  = "app"
    engine_version = "6.x"
    num_node_groups = 1
    replicas_per_node_group = 1
    node_type = "cache.t3.micro"
  }
}

rabbitmq = {
  main = {
    subnet_name   = "db"
    allow_db_cidr = "app"
    instance_type = "t3.small"
  }
}

alb = {
  public = {
    name           = "public"
    subnet_name    = "public"
    allow_alb_cidr = null
    internal       = false
  }
  private = {
    name           = "private"
    subnet_name    = "app"
    allow_alb_cidr = "web"
    internal       = true
  }
}


env = "dev"
bastion_cidr = ["172.31.13.238/32"]
monitor_cidr     = ["172.31.12.74/32"]
default_vpc_id = "vpc-0f945a96f067e3942"
default_vpc_cidr = "172.31.0.0/16"
default_vpc_rtid = "rtb-041517747ef206d80"
domain_name      = "srikaanth62.online"
domain_id        = "Z088180210HCZBPL2XI2M"
kms_arn = "arn:aws:kms:us-east-1:054432098243:key/b4390df6-235e-4da9-a62d-1f713a82e28d"
vpc = {
  main = {
    cidr_block = "10.0.0.0/16"
    subnets = {
      public = {
        name = "public"
        cidr_block = ["10.0.0.0/24", "10.0.1.0/24"]
        azs = ["us-east-1a", "us-east-1b"]
      }
      web = {
        name = "web"
        cidr_block = ["10.0.2.0/24", "10.0.3.0/24"]
        azs = ["us-east-1a", "us-east-1b"]
      }
      app = {
        name = "app"
        cidr_block = ["10.0.4.0/24", "10.0.5.0/24"]
        azs = ["us-east-1a", "us-east-1b"]
      }
      db = {
        name = "db"
        cidr_block = ["10.0.6.0/24", "10.0.7.0/24"]
        azs = ["us-east-1a", "us-east-1b"]
      }
    }
  }
}

app ={
  frontend = {
    name = "frontend"
    instance_type = "t3.small"
    subnet_name = "web"
    allow_app_cidr = "public"
    desired_capacity   = 1
    max_size           = 10
    min_size           = 1
    app_port = 80
    listener_priority = 1
    dns_name          = "dev"
    parameters        = []
    lb_type           = "public"
  }
  catalogue = {
    name = "catalogue"
    instance_type = "t3.small"
    subnet_name = "app"
    allow_app_cidr = "app"
    desired_capacity   = 1
    max_size           = 10
    min_size           = 1
    app_port = 8080
    listener_priority = 1
    parameters        = ["docdb"]
    lb_type           = "private"
  }

  cart = {
    name = "cart"
    instance_type = "t3.small"
    subnet_name = "app"
    allow_app_cidr = "app"
    desired_capacity   = 1
    max_size           = 10
    min_size           = 1
    app_port = 8080
    listener_priority = 2
    parameters        = []
    lb_type           = "private"
  }
  user = {
    name = "user"
    instance_type = "t3.small"
    subnet_name = "app"
    allow_app_cidr = "app"
    desired_capacity   = 1
    max_size           = 10
    min_size           = 1
    app_port = 8080
    listener_priority = 3
    parameters        = ["docdb"]
    lb_type           = "private"
  }
  shipping = {
    name = "shipping"
    instance_type = "t3.small"
    subnet_name = "app"
    allow_app_cidr = "app"
    desired_capacity   = 1
    max_size           = 10
    min_size           = 1
    app_port = 8080
    listener_priority = 4
    parameters        = ["rds"]
    lb_type           = "private"
  }
  payment = {
    name = "payment"
    instance_type = "t3.small"
    subnet_name = "app"
    allow_app_cidr = "app"
    desired_capacity   = 1
    max_size           = 10
    min_size           = 1
    app_port = 8080
    listener_priority = 5
    parameters        = []
    lb_type           = "private"
  }
}