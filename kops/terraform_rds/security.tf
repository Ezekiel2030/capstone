
data "aws_security_group" "kops_nodes" {
  filter {
    name   = "group-name"
    # Kops usually names its node SG: nodes.<cluster-name>
    # Replace 'yourcluster.com' with your actual cluster name
    values = ["nodes.${var.cluster_name}"] 
  }
  
  # Ensure it looks in the correct VPC
  vpc_id = var.vpc_id
}

resource "aws_security_group" "database" {
    name     = "${var.project_name}-db-sg"
    description = "Allow PostgresSQL only from backend nodes"
    vpc_id = var.vpc_id

    ingress {
        from_port = 5432
        to_port = 5432
        protocol = "tcp"
        security_groups = [data.aws_security_group.kops_nodes.id]
    } 

    egress {
        from_port = 0
        to_port      = 0
        protocol    = "-1" 
        cidr_blocks = ["0.0.0.0/0"]
    } 
}
