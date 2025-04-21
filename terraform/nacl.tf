resource "aws_network_acl_rule" "allow_jenkins_vault" {
  network_acl_id = "acl-037a96a904142eff6"   
  rule_number    = 50   
  egress         = false   
  protocol       = "tcp"   
  rule_action    = "allow"   
  cidr_block     = "0.0.0.0/0"   
  from_port      = 0
  to_port        = 65535
}

resource "aws_network_acl_rule" "deny_all" {
  network_acl_id = "acl-037a96a904142eff6"   
  rule_number    = 200   
  egress         = false   
  protocol       = "all"   
  rule_action    = "deny"   
  cidr_block     = "0.0.0.0/0"   
  from_port      = 0
  to_port        = 65535
}
