variable "aws-region" {
  type        = string
  description = "AWS Region"
  default     = "sa-east-1"
}

terraform {
  backend "s3" {
    bucket  = "6soat-tfstate"
    key     = "avalanches-pagamento/terraform-redis/terraform.tfstate"
    region  = "sa-east-1"
    encrypt = true
  }
}

provider "aws" {
  region = var.aws-region
}

resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "avalanches-pagamento-redis-subnet-group"
  subnet_ids = [data.aws_subnet.subnet1.id, data.aws_subnet.subnet2.id]

  tags = {
    Name        = "avalanches-pagamento Redis Subnet Group"
    Environment = "production"
    Service     = "avalanches-pagamento"
  }
}

resource "aws_elasticache_replication_group" "redis_replication_group" {
  replication_group_id        = "avalanches-pagamento-redis"
  description                 = "Redis Replication Group for avalanches-pagamento"
  engine                      = "redis"
  engine_version              = "7.0"
  node_type                   = "cache.t3.micro"
  num_cache_clusters          = 2
  automatic_failover_enabled  = true
  multi_az_enabled            = true
  preferred_cache_cluster_azs = ["sa-east-1a", "sa-east-1b"]
  parameter_group_name        = "default.redis7"
  subnet_group_name           = aws_elasticache_subnet_group.redis_subnet_group.id
  security_group_ids          = [aws_security_group.redis_sg.id]

  tags = {
    Name        = "avalanches-pagamento Redis Replication Group"
    Environment = "production"
    Service     = "avalanches-pagamento"
  }
}

resource "aws_security_group" "redis_sg" {
  name        = "avalanches-pagamento-redis-sg"
  description = "Security group for avalanches-pagamento Redis"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "avalanches-pagamento Redis Security Group"
    Environment = "production"
    Service     = "avalanches-pagamento"
  }
}

output "redis_primary_endpoint" {
  value = aws_elasticache_replication_group.redis_replication_group.primary_endpoint_address
}

output "redis_port" {
  value = aws_elasticache_replication_group.redis_replication_group.port
}
