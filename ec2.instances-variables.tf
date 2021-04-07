
### #################################################### ###
### [[ec2 instance cluster module]] Input Variables List ###
### #################################################### ###


### ############# ###
### in_node_count ###
### ############# ###

variable in_node_count {
    description = "The number of nodes that this fixed size ec2 instance cluster should bring up."
    default     = 3
}

### ######### ###
### in_ami_id ###
### ######### ###

variable in_ami_id {
    description = "The ID of the EC2 machine image (AMI) that each instance will boot up from."
    default     = "ami-01581ffba3821cdf3"
}


### ############ ###
### in_user_data ###
### ############ ###

variable in_user_data {
    description = "The body of text responsible for bootrapping the node."
    default = ""
}


### ################ ###
### in_instance_type ###
### ################ ###

variable in_instance_type {
    description = "The ec2 instance type (default is t2.medium) that will make up the fixed size ec2 cluster nodes."
    default = "t3.large"
}


### ####################### ###
### in_iam_instance_profile ###
### ####################### ###

variable in_iam_instance_profile {
    description = "The ec2 instance role access policies profile (see module terraform-aws-ec2-instance-profile)."
    default = ""
}


### ############# ###
### in_subnet_ids ###
### ############# ###

variable in_subnet_ids {
    description = "The list of subnet IDs each instance will join using modulus wrap-round arithmetic."
    type        = list
}


### ##################### ###
### in_security_group_ids ###
### ##################### ###

variable in_security_group_ids {
    description = "The identifiers of the (usually 1) security group that the nodes will identify with."
    type        = "sg-05092a13135f9b47b"
}


### ################# ###
### in_ssh_public_key ###
### ################# ###

#variable in_ssh_public_key {
#    description = "The public key for accessing both the DMZ bastion and the nodes behind enemy lines."
#}


/*
 | --
 | -- IMPORTANT - DO NOT LET TERRAFORM BRING UP EC2 INSTANCES INSIDE PRIVATE
 | -- SUBNETS BEFORE (SLOW TO CREATE) NAT GATEWAYS ARE UP AND RUNNING.
 | --
 | -- Suppose systemd on bootup wants to get a rabbitmq docker image as
 | -- specified by a service unit file. Terraform will quickly bring up ec2
 | -- instances and then proceed to slowly create NAT gateways. To avoid
 | -- these types of bootup errors we must declare explicit dependencies to
 | -- delay ec2 creation until the private gateways and routes are ready.
 | --
*/
variable in_route_dependency {
    description = "Aids creation of explicit dependency for instances brought up in private subnets."
    type        = list
    default     = [ "xxxxxx" ]
}


### ################ ###
### in_mandated_tags ###
### ################ ###

variable in_mandated_tags {

    description = "Optional tags unless your organization mandates that a set of given tags must be set."
    type        = map
    default     = { }
}


### ############ ###
### in_ecosystem ###
### ############ ###

variable in_ecosystem {
    description = "Creational stamp binding all infrastructure components created on behalf of this ecosystem instance."
    default = "security-grp"
    type    = string
}


### ############ ###
### in_timestamp ###
### ############ ###

variable in_timestamp {
    description = "A timestamp for resource tags in the format ymmdd-hhmm like 80911-1435"
    default     = "timestamp"
    type        = string
}


### ############## ###
### in_description ###
### ############## ###

variable in_description {
    description = "Ubiquitous note detailing who, when, where and why for every infrastructure component."
    default     = "This VPC network was created for an ecosystem."
    type        = string
}
