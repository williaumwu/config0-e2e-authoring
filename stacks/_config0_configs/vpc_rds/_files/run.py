"""
# Copyright (C) 2025 Gary Leong <gary@config0.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
"""

def run(stackargs):

    # instantiate authoring stack
    stack = newStack(stackargs)

    # Parse only what must thread through BOTH substacks. Everything the RDS needs
    # off the VPC (vpc_name / private_subnet_ids / db_sg_id) is resolved by the
    # selectors below — this parent never parses those.
    stack.parse.add_optional(key="aws_default_region",
                             default="eu-west-1",
                             types="str")

    stack.parse.add_required(key="vpc_name",
                             types="str")

    stack.parse.add_required(key="rds_name",
                             types="str")

    stack.parse.add_optional(key="cloud_tags_hash",
                             types="str")

    stack.parse.add_optional(key="engine_version",
                             default="8.0.46",
                             types="str")

    # Compose the user's own VPC stack, then the user's own RDS stack, as
    # substacks. Inserted sequentially (no set_parallel), so one run brings up
    # the VPC — with its security groups — first, then the RDS.
    stack.add_substack("williaumwu:::config0-e2e-authoring::aws_simple_vpc")
    stack.add_substack("williaumwu:::config0-e2e-authoring::rds")

    # initialize
    stack.init_variables()
    stack.init_substacks()

    ##################################
    # 1) VPC (aws_simple_vpc also creates the security groups via its own aws_sg)
    ##################################
    vpc_arguments = {
        "vpc_name": stack.vpc_name,
        "aws_default_region": stack.aws_default_region,
    }

    if stack.get_attr("cloud_tags_hash"):
        vpc_arguments["cloud_tags_hash"] = stack.cloud_tags_hash

    stack.aws_simple_vpc.insert(display=True,
                                arguments=vpc_arguments,
                                automation_phase="infrastructure",
                                human_description=f'create vpc "{stack.vpc_name}"')

    ##################################
    # 2) RDS, wired to the VPC created above.
    #    vpc_name + private_subnet_ids come off the VPC resource record; db_sg_id
    #    comes off the SEPARATE security_group record. These selectors skip-and-
    #    leave at the Python mint pass and resolve at the Go dispatch pass, after
    #    the VPC substack has written its records back.
    ##################################
    rds_arguments = {
        "rds_name": stack.rds_name,
        "aws_default_region": stack.aws_default_region,
        "vpc_name": "selector:::network_vars::vpc_name",
        "subnet_ids": "selector:::network_vars::private_subnet_ids",
        "sg_id": "selector:::sg_vars::db_sg_id",
        "engine_version": stack.engine_version,
        "allocated_storage": 14,
        "db_name": "app",
        "publish_creds": True,
    }

    if stack.get_attr("cloud_tags_hash"):
        rds_arguments["cloud_tags_hash"] = stack.cloud_tags_hash

    stack.rds.insert(display=True,
                                arguments=rds_arguments,
                                automation_phase="infrastructure",
                                human_description=f'create rds "{stack.rds_name}"')

    return stack.get_results()
