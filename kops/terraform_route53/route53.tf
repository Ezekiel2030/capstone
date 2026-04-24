# The Hosted Zone you created in Phase 2
data "aws_route53_zone" "selected" {
  name         = var.domain_name # Replace with your actual domain
  private_zone = false
}

# The DNS name from: kubectl get svc -n ingress-nginx
variable "ingress_lb_dns_name" {
  type        = string
  description = "The external DNS name of the Ingress Load Balancer"
}

resource "aws_route53_record" "frontend_cname" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "taskapp.${data.aws_route53_zone.selected.name}"
  type    = "CNAME"
  ttl     = 300
  records = [var.ingress_lb_dns_name]
}

resource "aws_route53_record" "api_cname" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "api.${data.aws_route53_zone.selected.name}"
  type    = "CNAME"
  ttl     = 300
  records = [var.ingress_lb_dns_name]
}

