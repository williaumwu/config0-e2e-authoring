def run(stackargs):

    stack = newStack(stackargs)

    stack.parse.add_required(key="project_id",
                             types="str")

    stack.init_variables()

    return stack.get_results()
