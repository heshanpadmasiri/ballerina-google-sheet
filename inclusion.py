import argparse
from typing import List, Callable, Optional
from parser import (
    Tokenizer,
    RemoteFunction,
    is_class_start,
    try_parse_macro,
    parse_remote_function_signature,
    indent_line,
    is_doc_comment,
    is_remote_func_start,
)

ContentGenFn = Callable[[List[str], List[RemoteFunction]], List[str]]


def new_lib_content(
    lines: List[str], remote_functions: List[RemoteFunction]
) -> List[str]:
    return lib_content(lines, remote_functions, False)


def clean_lib_content(lines: List[str], _: List[RemoteFunction]) -> List[str]:
    return lib_content(lines, [], True)


def lib_content(
    lines: List[str], remote_functions: List[RemoteFunction], is_clean: bool
) -> List[str]:
    tokenizer = Tokenizer(lines)
    new_lines: List[str] = []
    while not tokenizer.is_end():
        line = tokenizer.current_line()
        macro = try_parse_macro(tokenizer)
        if macro is None:
            new_lines.append(line)
            tokenizer.advance()
            continue
        elif macro[0] == "type inclusion":
            new_lines.append(line)
            if not is_clean:
                new_lines.append(indent_line(f"*{macro[1]};\n", 1))
            while try_parse_macro(tokenizer) != "end":
                tokenizer.advance()
            new_lines.append(tokenizer.current_line())
            tokenizer.advance()
        else:
            new_lines.append(line)
            if not is_clean:
                for each in remote_functions:
                    new_lines.extend(remote_function_defn(each, macro[1]))
                tokenizer.advance()
            macro = try_parse_macro(tokenizer)
            while macro != "end":
                tokenizer.advance()
                macro = try_parse_macro(tokenizer)
            new_lines.append(tokenizer.current_line())
            tokenizer.advance()
    return new_lines


def remote_function_defn(function: RemoteFunction, var_name: str) -> List[str]:
    content = []
    for comment in function[0]:
        content.append(indent_line(comment, 1))
    signature, fn_name, params = parse_remote_function_signature(Tokenizer(function[1]))
    content.append(indent_line(signature + " {", 1))
    args = [param[1] for param in params]
    call_tokens = [f"return self.{var_name}->{fn_name}("]
    for i, arg in enumerate(args):
        if i > 0:
            call_tokens.append(", ")
        call_tokens.append(arg)
    content.append(indent_line("".join(call_tokens) + ");", 2))
    content.append(indent_line("}\n", 1))
    return content


def update_lib(
    lib_path: str, remote_functions: List[RemoteFunction], contentGen: ContentGenFn
):
    with open(lib_path) as f:
        lines = list(map(lambda line: line.rstrip(), f.readlines()))
    content = contentGen(lines, remote_functions)
    with open(lib_path, "w") as f:
        f.write("\n".join(content))


def get_remote_functions(client_path: str) -> List[RemoteFunction]:
    with open(client_path) as f:
        tokenizer = Tokenizer(f.readlines())
    tokenizer = parse_client_class(tokenizer, "GsheetClient")
    return parse_remote_functions(tokenizer)


def parse_client_class(tokenizer: Tokenizer, client_class_name: str) -> Tokenizer:
    while not is_class_start(tokenizer, client_class_name):
        tokenizer.advance()
    return Tokenizer(tokenizer.read_till_end_of_block())


def parse_remote_functions(tokenizer: Tokenizer) -> List[RemoteFunction]:
    remote_functions: List[RemoteFunction] = []
    while not tokenizer.is_end():
        doc_comment = parse_doc_comment(tokenizer)
        if doc_comment is None:
            continue
        code = tokenizer.read_till_end_of_block()
        remote_functions.append((doc_comment, code))
    return remote_functions


def parse_doc_comment(tokenizer: Tokenizer) -> Optional[List[str]]:
    doc_comment: List[str] = []
    while is_doc_comment(tokenizer):
        doc_comment.append(tokenizer.current_line())
        tokenizer.advance()
    if not is_remote_func_start(tokenizer):
        tokenizer.advance()
        return None
    return doc_comment


def main(client_path: str, lib_path: str, clean: bool):
    if clean:
        contentFn = clean_lib_content
        remote_functions = []
    else:
        contentFn = new_lib_content
        remote_functions = get_remote_functions(client_path)
    return update_lib(lib_path, remote_functions, contentFn)


if __name__ == "__main__":
    arg_parser = argparse.ArgumentParser()
    arg_parser.add_argument("client", help="Path to client.bal")
    arg_parser.add_argument("lib", help="Path to lib.bal")
    arg_parser.add_argument(
        "--clean", action="store_true", help="Remove generated code"
    )
    args = arg_parser.parse_args()
    main(args.client, args.lib, args.clean)
