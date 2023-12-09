resource "aws_security_group" "wordpress_sg" {
  name        = "wordpress-sg"
  description = "wordpress-sg"
  vpc_id      = aws_vpc.srikaanth_vpc.id

  ingress {
    description = "APP"
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = "public"
  }

#  ingress {
#    description = "SSH"
#    from_port   = 22
#    to_port     = 22
#    protocol    = "tcp"
#    cidr_blocks = ["172.31.13.238/32"]
#  }
#
#  ingress {
#    description = "PROMETHEUS"
#    from_port   = 9100
#    to_port     = 9100
#    protocol    = "tcp"
#    cidr_blocks = ["172.31.12.74/32"]
#  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "wordpress-sg"
  }
}


resource "aws_launch_template" "template" {
  name_prefix            = "wordpress-lt"
  image_id               = data.aws_ami.ami.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.wordpress_sg.id]
#  iam_instance_profile {
#    name = aws_iam_instance_profile.instance_profile.name
#  }
#
#  user_data = base64encode(templatefile("${path.module}/userdata.sh", {
#    name = var.name
#    env  = var.env
#  }))

}

resource "aws_autoscaling_group" "asg" {
  name                = "wordpress-asg"
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  vpc_zone_identifier = [aws_subnet.subnet_private1_us_east_1a.id, aws_subnet.subnet_private2_us_east_1b.id]
  target_group_arns   = [aws_lb_target_group.main.arn]


  launch_template {
    id      = aws_launch_template.template.id
    version = "$Latest"
  }
  tags = {
    Name = "asg_tags"
  }

#  dynamic "tag" {
#    for_each = local.asg_tags
#    content {
#      key                 = tag.key
#      propagate_at_launch = true
#      value               = tag.value
#    }
#  }

}

resource "aws_lb_target_group" "main" {
  name     = "wordpress-tg"
  port     = var.app_port
  protocol = "HTTP"
  vpc_id   = aws_vpc.srikaanth_vpc.id
  tags = {
    Name = "wordpress-tg"
  }

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 5
    timeout             = 4
    path                = "/health"
  }
}

resource "aws_lb_listener" "wordpress-lb" {
  # Other parameters
}

resource "aws_lb_listener_rule" "rule" {
  listener_arn = aws_lb_listener.wordpress-lb.arn
  priority     = var.listener_priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }

  condition {
    host_header {
      values = var.dns_name
    }
  }
}
