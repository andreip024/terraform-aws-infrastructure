resource "aws_acm_certificate" "domain_certificate" {
  domain_name       = "${local.domain_name}"
  validation_method = "DNS"

  tags = {
    "Name"          = "${local.domain_name}-Certificate"
  }
}

data "aws_route53_zone" "domain_zone" {
    name          = local.domain_name
    private_zone  = false
  
}

resource "aws_route53_record" "route53" {
  for_each = {
    for i in aws_acm_certificate.domain_certificate.domain_validation_options : i.domain_name => {
      name   = i.resource_record_name
      record = i.resource_record_value
      type   = i.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.domain_zone.zone_id

}

resource "aws_acm_certificate_validation" "domain_certificate_validation" {
  certificate_arn         = aws_acm_certificate.domain_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.route53 : record.fqdn]
}

resource "aws_alb_listener" "alb_lisener" {
  load_balancer_arn = aws_lb.app_lb.arn
  certificate_arn   = aws_acm_certificate.domain_certificate.arn
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01" 
  port              = 443
  protocol          = "HTTPS"
 
  default_action {
    target_group_arn = aws_alb_target_group.app_lb_target_group.arn
    type             = "forward"
  }
}

resource "aws_route53_record" "load_balancer_record" {
    name    = local.domain_name
    type    = "A"
    zone_id = data.aws_route53_zone.domain_zone.zone_id
    alias {
      name                   = aws_lb.app_lb.dns_name
      zone_id                = aws_lb.app_lb.zone_id
      evaluate_target_health = true
  }

}

