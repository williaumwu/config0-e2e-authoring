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

from config0_publisher.terraform import TFConstructor


def run(stackargs):

    # instantiate authoring stack
    stack = newStack(stackargs)

    # Add default variables
    stack.parse.add_required(key="subnet_ids")

    stack.parse.add_required(key="sg_id",
                             types="str")

    stack.parse.add_required(key="rds_name",
                             tags="resource,tf_exec_env,db,tfvar",
                             types="str")

    stack.parse.add_optional(key="db_name",
                             default="_random",
                             tags="tfvar,db",
                             types="str")

    stack.parse.add_optional(key="allocated_storage",
                             default=30,
                             tags="tfvar",
                             types="int")

    stack.parse.add_optional(key="engine",
                             default="MySQL",
                             tags="tfvar",
                             types="str")

    stack.parse.add_optional(key="engine_version",
                             default="8.0.46",
                             tags="tfvar",
                             types="str")

    stack.parse.add_optional(key="instance_class",
                             default="db.t3.micro",
                             tags="tfvar",
                             types="str")

    stack.parse.add_optional(key="multi_az",
                             default="false",
                             tags="tfvar",
                             types="bool")

    stack.parse.add_optional(key="storage_type",
                             default="gp2",
                             tags="tfvar",
                             types="str")

    stack.parse.add_optional(key="publicly_accessible",
                             default="false",
                             tags="tfvar",
                             types="bool")

    stack.parse.add_optional(key="iam_database_authentication_enabled",
                             default="false",
                             tags="tfvar",
                             types="bool")

    stack.parse.add_optional(key="storage_encrypted",
                             default="false",
                             tags="tfvar",
                             types="bool")

    stack.parse.add_optional(key="allow_major_version_upgrade",
                             default="true",
                             tags="tfvar",
                             types="bool")

    stack.parse.add_optional(key="auto_minor_version_upgrade",
                             default="true",
                             tags="tfvar",
                             types="bool")

    stack.parse.add_optional(key="skip_final_snapshot",
                             default="true",
                             tags="tfvar",
                             types="bool")

    stack.parse.add_optional(key="deletion_protection",
                             default="false",
                             tags="tfvar",
                             types="bool")

    stack.parse.add_optional(key="port",
                             default="3306",
                             tags="tfvar",
                             types="int")

    stack.parse.add_optional(key="backup_retention_period",
                             default="1",
                             tags="tfvar",
                             types="str")

    stack.parse.add_optional(key="backup_window",
                             default="10:22-11:22",
                             tags="tfvar",
                             types="str")

    stack.parse.add_optional(key="maintenance_window",
                             default="Mon:00:00-Mon:03:00",
                             tags="tfvar",
                             types="str")

    stack.parse.add_optional(key="rds_master_username",
                             default=None,
                             tags="tfvar",
                             types="str")

    stack.parse.add_optional(key="aws_default_region",
                             default="eu-west-1",
                             tags="tfvar,db,resource,tf_exec_env",
                             types="str")

    stack.parse.add_optional(key="publish_creds",
                             default=None,
                             types="bool")

    stack.parse.add_optional(key="publish_to_saas",
                             default=None,
                             types="bool")

    # add execgroup
    stack.add_execgroup("williaumwu:::config0-e2e-authoring::rds",
                        "tf_execgroup")

    # add substack
    stack.add_substack("config0-hub:::config0_core::tf_executor")

    # initialize
    stack.init_variables()
    stack.init_execgroups()
    stack.init_substacks()

    # automatically name the db_subnet_name
    stack.set_variable("security_group_ids",
                       stack.to_list(stack.sg_id),
                       tags="tfvar",
                       types="list")

    stack.set_variable("db_subnet_name",
                       f"{stack.rds_name}-subnet",
                       tags="tfvar",
                       types="str")

    stack.set_variable("subnet_ids",
                       stack.to_list(stack.subnet_ids),
                       tags="tfvar",
                       types="list")

    # set the master username. RDS makes the master password itself and keeps
    # it in AWS Secrets Manager, so this stack never makes or takes one.
    # ponytail: the "u" prefix makes the username start with a letter, and 16
    # characters is the RDS for MySQL and MariaDB limit, the shortest of the
    # engines (random_id is lowercase letters and digits only).
    if not stack.get_attr("rds_master_username") and stack.inputvars.get("DB_MASTER_USERNAME"):
        stack.set_variable("rds_master_username",
                           stack.inputvars["DB_MASTER_USERNAME"],
                           tags="tfvar",
                           types="str")
    elif not stack.get_attr("rds_master_username"):
        stack.set_variable("rds_master_username",
                           f"u{stack.random_id(size=15)}",
                           tags="tfvar",
                           types="str")

    stack.set_variable("timeout", 2700)

    # use the terraform constructor (helper)
    # the rds execgroup's module (terraform-aws-modules/rds/aws 7.2.2) needs
    # OpenTofu >= 1.11.1; 1.11.14 is the newest 1.11 release.
    tf = TFConstructor(stack=stack,
                       execgroup_name=stack.tf_execgroup.name,
                       provider="aws",
                       resource_name=stack.rds_name,
                       resource_type="rds",
                       tf_runtime="tofu:1.11.14")

    tf.include(maps={"db_id": "arn", "id": "arn"})

    output_keys = [
        "db_subnet_group_name",
        "arn",
        "publicly_accessible",
        "availability_zone",
        "allocated_storage",
        "instance_class",
        "performance_insights_enabled",
        "storage_type",
        "multi_az",
        "engine",
        "engine_version"
    ]

    # put the ARN of the Secrets Manager secret that holds the master user
    # name and password onto the saas ui (optional). Never the user or the
    # password: they stay in the secret.
    if stack.get_attr("publish_creds") or stack.get_attr("publish_to_saas"):
        output_keys.append("master_user_secret_arn")

    tf.output(keys=output_keys)

    # finalize the tf_executor
    stack.tf_executor.insert(display=True, **tf.get())

    return stack.get_results()
