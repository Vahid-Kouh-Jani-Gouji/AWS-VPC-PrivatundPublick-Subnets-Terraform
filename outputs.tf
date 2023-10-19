output "ec2_id" {
  value = aws_instance.ec2.*.id

}

output "load_balancer_DNS_Name" {
    value = aws_lb.application_loadbalancer.dns_name
  
}