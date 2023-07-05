import argparse
from typing import Dict, Optional, Tuple, List

NameList = Dict[str, str]

LinePosition = Tuple[int, int]  # start_col, end_col
# function_name_position, function_name
ResourceFunction = Tuple[LinePosition, str]
ParseResult = Optional[ResourceFunction]


def rename_client(
        client_path: str,
        types_path: str,
        function_name_list: NameList,
        type_name_list: NameList,
        inplace: bool) -> None:
    fix_generated_client_name(client_path, inplace)
    rename_functions(client_path, function_name_list, inplace)
    rename_types(client_path, type_name_list, inplace)
    rename_types(types_path, type_name_list, inplace)


def fix_generated_client_name(client_path: str, inplace: bool) -> None:
    body = []
    with open(client_path, "r") as file:
        lines = file.readlines()
        for line in lines:
            tokens = line.strip().split()
            if tokens == [
                "public",
                "isolated",
                "client",
                "class",
                "Client",
                    "{"]:
                body.append("isolated client class GsheetClient {\n")
            else:
                body.append(line)
    new_file_path = client_path if inplace else "new_" + client_path
    with open(new_file_path, "w") as file:
        file.writelines(body)


def rename_functions(
        file_path: str,
        function_name_list: NameList,
        inplace: bool) -> None:
    body = []
    with open(file_path, "r") as file:
        lines = file.readlines()
        body = new_client_content(lines, function_name_list)
    new_file_path = file_path if inplace else "new_" + file_path
    with open(new_file_path, "w") as file:
        file.writelines(body)


def rename_types(
        file_path: str,
        type_name_list: NameList,
        inplace: bool) -> None:
    body = []
    with open(file_path, "r") as file:
        lines = file.readlines()
        body = file_content_with_new_types(lines, type_name_list)
    new_file_path = file_path if inplace else "new_" + file_path
    with open(new_file_path, "w") as file:
        file.writelines(body)


def file_content_with_new_types(
        lines: List[str],
        type_name_list: NameList) -> List[str]:
    body = []
    for line in lines:
        for old_name, new_name in type_name_list.items():
            # space to make sure we don't raplace FooBar when we try to replace just Bar
            # NOTE: this is not a perfect solution but it is sufficient to the
            # currently generated code
            # TODO: may be a good idea to use a regex here
            line = line.replace(f' {old_name}', f' {new_name}')
        body.append(line)
    return body


def new_client_content(
        lines: List[str],
        name_list: NameList) -> List[str]:
    new_client_body = []
    for line in lines:
        parse_result = parse_line(line)
        if parse_result is not None:
            function_name_position, function_name = parse_result
            new_function_name = name_list.get(
                function_name, generic_new_name(function_name))
            new_client_body.append(line[:function_name_position[0]] +
                                   new_function_name +
                                   line[function_name_position[1]:])
        else:
            new_client_body.append(line)
    return new_client_body


def generic_new_name(old_name: str) -> str:
    """Return a generic new name to be used when no hardcoded name is given

    This assumes names are of the form "sheetsSpreadsheets<Noun>[Verb]" where both
    Noun and Verb start with a capital letter, and noun is a single word. New name
    will be "[Verb]<Noun>"
    """
    prefix = "sheetsSpreadsheets"
    assert (old_name.startswith(prefix))
    name = old_name[len(prefix):]
    for i, c in enumerate(name):
        if i != 0 and c.isupper():
            return name[i:].lower() + name[:i]
    return name


def parse_line(line: str) -> ParseResult:
    tokens = line.strip().split()
    if tokens[:3] == ["remote", "isolated", "function"]:
        start_index = line.index(tokens[3])
        end_index = line.index("(", start_index)
        function_name = line[start_index:end_index]
        return ((start_index, end_index), function_name)
    return None


def read_name_list(name_list_path: str) -> Tuple[NameList, NameList]:
    function_name_list = {}
    type_name_list = {}
    name_list = function_name_list
    with open(name_list_path, "r") as f:
        for line in f.readlines():
            line = line.strip()
            if line == "# functions":
                name_list = function_name_list
            elif line == "# types":
                name_list = type_name_list
            if len(line) == 0 or line[0] == "#":
                continue
            org_name, new_name = line.split()
            name_list[org_name] = new_name
    return function_name_list, type_name_list


if __name__ == "__main__":
    arg_parser = argparse.ArgumentParser(
        prog="rename", description="Rename generated client")
    arg_parser.add_argument(
        "client_path",
        help="Path to client.bal")
    arg_parser.add_argument(
        "types_path",
        help="Path to types.bal")
    arg_parser.add_argument(
        "name_list_path",
        help="Path to hardcoded name list")
    arg_parser.add_argument(
        "--inplace",
        help="If set repalce the client file inplace, else create new_client.bal",
        action="store_true",
        default=False)
    args = arg_parser.parse_args()
    function_name_list, type_name_list = read_name_list(args.name_list_path)
    rename_client(
        args.client_path,
        args.types_path,
        function_name_list,
        type_name_list,
        args.inplace)
