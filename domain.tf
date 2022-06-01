resource "aws_acm_certificate" "ecs_domain_certificate" {
    domain_name = "*.${var.app_domain}"
    validation_method = "DNS"

    tags = {
        Name = "${var.app_domain}-ecs-cert"
    }
}

data "aws_route53_zone" "ecs_domain" {
    name = "${var.app_domain}"
    private_zone = false
}

resource "aws_route53_record" "ecs_cert_validation_record" {
    for_each = {
        for ecs in aws_acm_certificate.ecs_domain_certificate.domain_validation_options : ecs.domain_name => {
          name   = ecs.resource_record_name
          record = ecs.resource_record_value
          type   = ecs.resource_record_type
        }
      }

    name            = each.value.name
    type            = each.value.type
    records = [each.value.record]
    zone_id         = data.aws_route53_zone.ecs_domain.zone_id
    ttl = 60
    allow_overwrite = true
}

resource "aws_acm_certificate_validation" "ecs_domain_certificate_validation" {
    certificate_arn = aws_acm_certificate.ecs_domain_certificate.arn
    validation_record_fqdns = [for record in aws_route53_record.ecs_cert_validation_record : record.fqdn]
}

resource "aws_route53_record" "ecs_alb_record" {
    name = "*.${var.app_domain}"
    type = "A"
    zone_id = data.aws_route53_zone.ecs_domain.zone_id

    alias {
        evaluate_target_health = false
        name = aws_alb.alb_fe.dns_name
        zone_id = aws_alb.alb_fe.zone_id
    }
}