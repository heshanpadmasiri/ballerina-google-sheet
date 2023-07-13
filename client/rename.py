import argparse
import re
from typing import Dict, Optional, Tuple, List

from parser import (
    Tokenizer,
    indent_line,
    is_class_start,
    is_doc_comment,
    is_remote_func_start,
    parse_remote_function_signature,
)

NameList = Dict[str, str]
LinePosition = Tuple[int, int]  # start_col, end_col
ResourceFunction = Tuple[LinePosition, str]  # function_name_position, function_name
ParseResult = Optional[ResourceFunction]


def rename_client(
    client_path: str,
    types_path: str,
    function_name_list: NameList,
    regex_name_list: NameList,
    comment_list: NameList,
    inplace: bool,
) -> None:
    fix_generated_client_name(client_path, inplace)
    rename_functions(client_path, function_name_list, inplace)
    rename_file_content(client_path, regex_name_list, inplace)
    rename_file_content(types_path, regex_name_list, inplace)
    fix_doc_comment(client_path, comment_list, inplace)


def fix_doc_comment(src_path: str, comment_list: NameList, inplace: bool) -> None:
    body = []
    with open(src_path, "r") as file:
        tokenizer = Tokenizer(file.readlines())
        doc_buffer = []
        while not tokenizer.is_end():
            line = tokenizer.current_line()
            if is_doc_comment(tokenizer):
                doc_buffer.append(line)
            elif is_remote_func_start(tokenizer):
                _, _, params = parse_remote_function_signature(tokenizer)
                body.extend(doc_buffer[:2])
                for _, param in params:
                    if param in comment_list:
                        comment = f"# + {param} - {comment_list[param]}"
                        body.append(indent_line(comment, 1) + "\n")
                body.extend(doc_buffer[2:])
                body.append(line)
                doc_buffer = []
                pass
            else:
                if len(doc_buffer) > 0:
                    body.extend(doc_buffer)
                    doc_buffer = []
                body.append(line)
            tokenizer.advance()
    save_content(src_path, body, inplace)


def fix_generated_client_name(client_path: str, inplace: bool) -> None:
    body = []
    with open(client_path, "r") as file:
        tokenizer = Tokenizer(file.readlines())
        while not tokenizer.is_end():
            tokens = tokenizer.tokenize()
            # NOTE: we don't use a generic class checker since we have only one case,
            # and hopefully we don't need to add more in the future
            if is_class_start(tokenizer, "Client"):
                body.append("isolated client class GsheetClient {\n")
            else:
                body.append(tokenizer.current_line())
            tokenizer.advance()
    save_content(client_path, body, inplace)


def rename_functions(
    file_path: str, function_name_list: NameList, inplace: bool
) -> None:
    body = []
    with open(file_path, "r") as file:
        lines = file.readlines()
        body = new_client_content(lines, function_name_list)
    save_content(file_path, body, inplace)


def rename_file_content(file_path: str, name_list: NameList, inplace: bool) -> None:
    body = []
    with open(file_path, "r") as file:
        lines = file.readlines()
        body = file_content_with_new_names(lines, name_list)
    save_content(file_path, body, inplace)


def save_content(file_path: str, body: List[str], inplace: bool) -> None:
    if len(body) == 0:
        raise RuntimeError("Writing empty body")
    new_file_path = file_path if inplace else "new_" + file_path
    with open(new_file_path, "w") as file:
        file.writelines(body)


def file_content_with_new_names(lines: List[str], name_list: NameList) -> List[str]:
    body = []
    for line in lines:
        for old_name, new_name in name_list.items():
            line = re.sub(old_name, new_name, line)
        body.append(line)
    return body


def new_client_content(lines: List[str], name_list: NameList) -> List[str]:
    new_client_body = []
    tokenizer = Tokenizer(lines)
    while not tokenizer.is_end():
        if is_remote_func_start(tokenizer):
            line, function_name, _ = parse_remote_function_signature(tokenizer)
            new_function_name = name_list.get(
                function_name, generic_new_name(function_name)
            )
            new_line = (
                indent_line(line.replace(function_name, new_function_name), 1) + " {\n"
            )
            new_client_body.append(new_line)
        else:
            new_client_body.append(tokenizer.current_line())
        tokenizer.advance()
    return new_client_body


def generic_new_name(old_name: str) -> str:
    """Return a generic new name to be used when no hardcoded name is given

    This assumes names are of the form "sheetsSpreadsheets<Noun>[Verb]" where both
    Noun and Verb start with a capital letter, and noun is a single word. New name
    will be "[Verb]<Noun>"
    """
    prefix = "sheetsSpreadsheets"
    assert old_name.startswith(prefix)
    name = old_name[len(prefix) :]
    for i, c in enumerate(name):
        if i != 0 and c.isupper():
            return name[i:].lower() + name[:i]
    return name


def read_name_list(name_list_path: str) -> Tuple[NameList, NameList, NameList]:
    function_name_list = {}
    regex_name_list = {}
    comment_list = {}
    name_list = function_name_list
    with open(name_list_path, "r") as f:
        for line in f.readlines():
            line = line.strip()
            if line == "# functions":
                name_list = function_name_list
            elif line == "# regex":
                name_list = regex_name_list
            elif line == "# comments":
                name_list = comment_list
            if len(line) == 0 or line[0] == "#":
                continue
            vals = line.split()
            if len(vals) == 2:
                org_name, new_name = vals
            elif len(vals) > 2:
                org_name = vals[0]
                new_name = " ".join(vals[1:])
            else:
                org_name = vals[0]
                new_name = ""
            name_list[org_name] = new_name
    return function_name_list, regex_name_list, comment_list


if __name__ == "__main__":
    arg_parser = argparse.ArgumentParser(
        prog="rename", description="Rename generated client"
    )
    arg_parser.add_argument("client_path", help="Path to client.bal")
    arg_parser.add_argument("types_path", help="Path to types.bal")
    arg_parser.add_argument("name_list_path", help="Path to hardcoded name list")
    arg_parser.add_argument(
        "--inplace",
        help="If set repalce the client file inplace, else create new_client.bal",
        action="store_true",
        default=False,
    )
    args = arg_parser.parse_args()
    function_name_list, regex_name_list, comment_list = read_name_list(
        args.name_list_path
    )
    rename_client(
        args.client_path,
        args.types_path,
        function_name_list,
        regex_name_list,
        comment_list,
        args.inplace,
    )
