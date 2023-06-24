import argparse
from typing import Dict, Optional, Tuple, List

HardcodedNameList = Dict[str, str]

LinePosition = Tuple[int, int]  # start_col, end_col
# function_name_position, function_name
ResourceFunction = Tuple[LinePosition, str]
ParseResult = Optional[ResourceFunction]


def rename_client(
        client_path: str,
        hardcoded_name_list: HardcodedNameList,
        inplace: bool) -> None:
    body = []
    with open(client_path, "r") as client_file:
        lines = client_file.readlines()
        body = new_client_content(lines, hardcoded_name_list)
    new_client_path = client_path if inplace else "new_client.bal"
    with open(new_client_path, "w") as client_file:
        client_file.writelines(body)


def new_client_content(
        lines: List[str],
        hardcoded_name_list: HardcodedNameList) -> List[str]:
    new_client_body = []
    for line in lines:
        parse_result = parse_line(line)
        if parse_result is not None:
            function_name_position, function_name = parse_result
            new_function_name = hardcoded_name_list.get(
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
    assert(old_name.startswith(prefix))
    name = old_name[len(prefix):]
    for i, c in enumerate(name):
        if i != 0 and c.isupper():
            return name[i:].lower() + name[:i]
    return name


def parse_line(line: str) -> ParseResult:
    tokens = line.strip().split()
    if len(
            tokens) > 3 and tokens[0] == "remote" and tokens[1] == "isolated" and tokens[2] == "function":
        start_index = line.index(tokens[3])
        end_index = line.index("(", start_index)
        function_name = line[start_index:end_index]
        return ((start_index, end_index), function_name)
    return None


def read_name_list(name_list_path: str) -> HardcodedNameList:
    replacement_names = {}
    with open(name_list_path, "r") as f:
        for line in f.readlines():
            org_name, new_name = line.split()
            replacement_names[org_name] = new_name
    return replacement_names


if __name__ == "__main__":
    arg_parser = argparse.ArgumentParser(
        prog="rename", description="Rename generated client")
    arg_parser.add_argument("client_path", help="Path to client.bal file")
    arg_parser.add_argument(
        "name_list_path",
        help="Path to hardcoded name list")
    arg_parser.add_argument(
        "--inplace",
        help="If set repalce the client file inplace, else create new_client.bal",
        action="store_true",
        default=False)
    args = arg_parser.parse_args()
    hardcoded_name_list = read_name_list(args.name_list_path)
    rename_client(args.client_path, hardcoded_name_list, args.inplace)
