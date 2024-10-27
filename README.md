# Welcome to the purepiv6aws Project

Pure IPv6 AWS Subnet and EC2 Instance with Terraform. For a full description of this project, read the article on [Medium](https://medium.com/@ajmusgrove/pure-ipv6-on-aws-with-terraform-ebbdc0016812).

## Running

Building and running this project is very simple. Before running the Terraform, if you want to modify the default region
of *us-east-1*, when you run the `terraform plan` step, run
it as `terraform plan -var region=REGION -out tfplan.out`.

```
./keypair_gen.sh
cd terraform
terraform init
terraform plan -out tfplan.out
terraform apply tfplan.out

# log into the IPv6 EC2 Instance
ssh -i ../pureipv6 ubuntu@$(terraform output -raw public_ipv6)
```

## Verifying

From the SSH shell, enter `ip addr show`. For the IPv4 address, you shoul see
a 169.254.x.x address. That is a *Automatic Private IP Address Assignment
(APIPA)* address. It was assigned because no routable IPv4 address
was available from DHCP. On the same interface, you will see your IPv6 Address. 

To see the route table, the route command has a slight change from the IPv4
version. You enter `ip -6 route show`. To ping another host (or to ping
this host over the internet, you use `ping6 IPV6ADDR`. Notice ping is allowed
in the security group this Terraform created for testing purposes, but you will probably
not leave ping open in production. 

If you want to test speed with `iperf`, be sure you use the -V option so
that iperf will use IPv6.

When addressing the host with curl be sure you enter something like
`curl https://[2600:1f18:6028:9f64:e3eb:5156:421e:331]/`. Notice the
square brackets, otherwise curl will misinterpret the colons.

## Conclusion

That is how you make a sure IPv6 EC2 instance. Be sure to check
out the artice on [Medium](https://medium.com/@ajmusgrove/pure-ipv6-on-aws-with-terraform-ebbdc0016812) for a full explanation.

