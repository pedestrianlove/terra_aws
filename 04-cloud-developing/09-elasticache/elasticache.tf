data "aws_subnets" "lab_vpc_ide_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.lab_vpc.id]
  }
}

resource "aws_elasticache_subnet_group" "lab_memcached_subnet_group" {
  name        = "ElastiCacheSubnetGroup"
  description = "Subnet group for ElastiCache"
  subnet_ids  = data.aws_subnets.lab_vpc_ide_subnets.ids
}

resource "aws_elasticache_cluster" "lab_memcached_cluster" {
  cluster_id           = "memcachedcache"
  engine               = "memcached"
  engine_version       = "1.6.6"
  node_type            = "cache.r6g.large"
  num_cache_nodes      = 3
  parameter_group_name = "default.memcached1.6"
  port                 = 11211

  security_group_ids = [
    data.aws_security_group.lab_sg_memcache.id,
  ]

  subnet_group_name = aws_elasticache_subnet_group.lab_memcached_subnet_group.name

  tags = {
    Name = "MemcachedCache"
  }
}
