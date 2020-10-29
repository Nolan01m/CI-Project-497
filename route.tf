resource "aws_route53_zone" "aiexparts" {
  name = "aiexparts.com"
}

resource "aws_route53_record" "Record1" {
  allow_overwrite = true
  name            = "aiexparts.com"
  ttl             = 30
  type            = "A"
  zone_id         = aws_route53_zone.aiexparts.zone_id

  records = ["54.83.73.188"]
}

resource "aws_route53_record" "Record2" {
  allow_overwrite = true
  name            = "aiexparts.com"
  ttl             = 30
  type            = "CNAME"
  zone_id         = aws_route53_zone.aiexparts.zone_id

  records = ["aiexparts.com"]
}
