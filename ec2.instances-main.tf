
/*
 | --
 | -- This ec2 instance resource creates a fixed size cluster containing
 | -- anything from 1 to n nodes.
 | --
 | -- This implements the middle of the 3 layered cluster architecture.
 | -- This cluster layer is concerned with instance types, storage sizes
 | -- and the underlying machine images.
 | --
 | -- This middle layer accepts user data configuration from the systemd
 | -- services layer and network concerns like subnet IDs and security
 | -- groups from the network layer.
 | --
 | -- We hardcode an outgoing routing dependency to enforce its precedence
 | -- over instance creation within private subnets.
 | --
*/
resource aws_instance nodes
{
    count = "${var.in_node_count}"

    instance_type          = "${ var.in_instance_type }"
    ami                    = "${ var.in_ami_id }"
    subnet_id              = "${ element( var.in_subnet_ids, count.index ) }"
    user_data              = "${ var.in_user_data }"
    vpc_security_group_ids = [ "${ var.in_security_group_ids }" ]
    iam_instance_profile   = "${ module.s3-instance-profile.out_profile_name }"
    key_name               = "${ element( aws_key_pair.ssh.*.id, 0 ) }"

    tags
    {
        Name     = "ec2-${ var.in_ecosystem_name }-${ var.in_tag_timestamp }-${ ( count.index + 1 ) }"
        Class    = "${ var.in_ecosystem_name }"
        Instance = "${ var.in_ecosystem_name }-${ var.in_tag_timestamp }"
        Desc     = "This cluster node no.${ ( count.index + 1 ) } of ${ var.in_node_count } for ${ var.in_ecosystem_name } ${ var.in_tag_description }"
/*
        Route    = "This ec2 instance can connect externally through route ${ element( var.in_route_dependency, count.index ) } that serves subnet ${ element( var.in_subnet_ids, count.index ) }."
*/
    }
}


/*
 | --
 | -- This resource in the "troubleshoot" branch is looking out
 | -- for an environment variable named TF_VAR_in_ssh_public_key
 | --
 | -- The environment variable shields the public key contents
 | -- from the public repository.
 | --
*/
resource aws_key_pair ssh
{
    count = "${ signum( length( var.in_ssh_public_key ) ) }"
    key_name = "key-4-${ var.in_ecosystem_name }-${ var.in_tag_timestamp }"
    public_key = "${ var.in_ssh_public_key }"
}


module s3-instance-profile
{
    source = "github.com/devops4me/terraform-aws-s3-instance-profile"

    in_ecosystem_name  = "${ var.in_ecosystem_name }"
    in_tag_timestamp   = "${ var.in_tag_timestamp }"
    in_tag_description = "${ var.in_tag_description }"
}

