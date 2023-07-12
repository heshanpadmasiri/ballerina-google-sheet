import argparse
from typing import Callable, List, Optional, Tuple, Union, Literal

# doc comment, code
RemoteFunction = Tuple[List[str], List[str]]
# Client class name, variable name
IncludeRemoteFnMacro = Tuple[str, str]
TypeInclusionMacro = Tuple[Literal["type inclusion"], str]
Macro = Union[IncludeRemoteFnMacro, TypeInclusionMacro, Literal["end"]]

# signature line (excluding "{"), function_name, [(param type, param name)]
FunctionSignature = Tuple[str, str, List[Tuple[str, str]]]

ContentGenFn = Callable[[List[str], List[RemoteFunction]], List[str]]


class Tokenizer:
    def __init__(self, lines: List[str]) -> None:
        self.line_no = 0
        self.lines = lines

    def read_till_end_of_block(self) -> List[str]:
        """This will read lines until the end of the current block."""
        opening_brace_count, closing_brace_count = brace_count(self.current_line())
        left_open = opening_brace_count - closing_brace_count
        # Block could open and close in the same line
        lines = [self.current_line()]
        while left_open > 0 and not self.is_end():
            self.advance()
            lines.append(self.current_line())
            opening_brace_count, closing_brace_count = brace_count(self.current_line())
            left_open += opening_brace_count - closing_brace_count
        if left_open > 0:
            raise RuntimeError("Block not closed")
        last_line = lines.pop().rstrip()
        end_index = last_line.rfind("}")
        lines.append(last_line[: end_index + 1])
        return lines

    def advance(self) -> None:
        self.line_no += 1

    def current_line(self) -> str:
        return self.lines[self.line_no]

    def tokenize(self) -> List[str]:
        line = self.current_line()
        tokens = []
        current_token_chars = []
        i = 0
        while i < len(line):
            char = line[i]
            if char == " ":
                if len(current_token_chars) != 0:
                    tokens.append(create_token(current_token_chars))
                current_token_chars.clear()
            elif char == "(" and i < len(line) - 1 and line[i + 1] == ")":
                tokens.append("()")
                i += 2
                continue
            elif is_delimiter(char):
                if len(current_token_chars) != 0:
                    tokens.append(create_token(current_token_chars))
                tokens.append(char)
                current_token_chars.clear()
            else:
                current_token_chars.append(char)
            i += 1
            if i == len(line) and len(current_token_chars) != 0:
                tokens.append(create_token(current_token_chars))
        return tokens

    def is_end(self) -> bool:
        return self.line_no >= len(self.lines)

    def print_lines(self) -> None:
        for line in self.lines:
            print(line)


def create_token(chars: List[str]) -> str:
    return "".join(chars)


def is_delimiter(char: str) -> bool:
    delimiters = ["(", ")", "{", "}", ",", ";", "="]
    return char in delimiters


def brace_count(line: str) -> Tuple[int, int]:
    """Returns the number of opening and closing braces in the line."""
    return line.count("{"), line.count("}")


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
        macro = try_parse_macro(tokenizer.tokenize())
        if macro is None:
            new_lines.append(line)
            tokenizer.advance()
            continue
        elif macro[0] == "type inclusion":
            new_lines.append(line)
            if not is_clean:
                new_lines.append(indent_line(f"*{macro[1]};\n", 1))
            while try_parse_macro(tokenizer.tokenize()) != "end":
                tokenizer.advance()
            new_lines.append(tokenizer.current_line())
            tokenizer.advance()
        else:
            new_lines.append(line)
            if not is_clean:
                for each in remote_functions:
                    new_lines.extend(remote_function_defn(each, macro[1]))
                tokenizer.advance()
            macro = try_parse_macro(tokenizer.tokenize())
            while macro != "end":
                tokenizer.advance()
                macro = try_parse_macro(tokenizer.tokenize())
            new_lines.append(tokenizer.current_line())
            tokenizer.advance()
    return new_lines


def remote_function_defn(function: RemoteFunction, var_name: str) -> List[str]:
    content = []
    for comment in function[0]:
        content.append(indent_line(comment, 1))
    signature, fn_name, params = parse_remote_function_signature(function[1])
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


def indent_line(line: str, level: int, indent_size=4) -> str:
    return " " * (level * indent_size) + line.strip()


def parse_remote_function_signature(lines: List[str]) -> FunctionSignature:
    tokenizer = Tokenizer(lines)
    signature_tokens = []
    param_types: List[Tuple[str, str]] = []
    function_name = ""
    while not tokenizer.is_end():
        tokens = tokenizer.tokenize()
        i = 0
        while i < len(tokens):
            token = tokens[i]
            if token == "{":
                signature_line = to_line(signature_tokens)
                return signature_line, function_name, param_types
            elif token == "function":
                function_name = tokens[i + 1]
                signature_tokens.append(token)
            elif token == "(":
                signature_tokens.append(token)
                param_types = parse_param_list(tokens[i + 1 :], signature_tokens)
            else:
                signature_tokens.append(token)
            i = len(signature_tokens)
        tokenizer.advance()
    raise RuntimeError("Failed to parse function signature")


def parse_param_list(tokens: List[str], accum: List[str]) -> List[Tuple[str, str]]:
    i = 0
    param_types: List[Tuple[str, str]] = []
    while i < len(tokens):
        param_type = tokens[i]
        param_name = tokens[i + 1]
        accum.append(param_type)
        accum.append(param_name)
        param_types.append((param_type, param_name))
        j = i + 2
        while j < len(tokens):
            if tokens[j] == ")":
                return param_types
            accum.append(tokens[j])
            j += 1
            if tokens[j - 1] == ",":
                break
        i = j
    raise RuntimeError("Failed to parse param list")


def to_line(tokens: List[str]) -> str:
    spaced_tokens = []
    i = 0
    no_space_after = False
    while i < len(tokens):
        token = tokens[i]
        if i != 0 and space_before(token) and not no_space_after:
            spaced_tokens.append(" ")
        spaced_tokens.append(token)
        if no_space_after:
            no_space_after = False
        if token == "(":
            no_space_after = True
        i += 1
    while spaced_tokens[-1] == " ":
        spaced_tokens.pop()
    return "".join(spaced_tokens)


def space_before(token: str) -> bool:
    chars = ["(", ",", ")"]
    return token not in chars


INCLUDE_REMOTE_FN_MACRO = "includeRemoteFunctions!"
TYPE_INCLUSION_MACRO = "typeInclusion!"
END_MACRO = "end!"


def try_parse_macro(tokens: List[str]) -> Optional[Macro]:
    if len(tokens) < 2 or tokens[0] != "//":
        return None
    macro = tokens[1]
    if macro == INCLUDE_REMOTE_FN_MACRO:
        return parse_include_remote_fn_macro(tokens)
    elif macro == TYPE_INCLUSION_MACRO:
        return parse_type_inclusion_macro(tokens)
    elif macro == END_MACRO:
        return "end"
    return None


def parse_include_remote_fn_macro(tokens: List[str]) -> IncludeRemoteFnMacro:
    if len(tokens) == 7:
        return tokens[3], tokens[5]
    raise RuntimeError(f"Invalid inclusion macro: {to_line(tokens)}")


def parse_type_inclusion_macro(tokens: List[str]) -> TypeInclusionMacro:
    return "type inclusion", tokens[3]


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
    while is_doc_comment(tokenizer.tokenize()):
        doc_comment.append(tokenizer.current_line())
        tokenizer.advance()
    if not is_remote_func_start(tokenizer.tokenize()):
        tokenizer.advance()
        return None
    return doc_comment


def is_remote_func_start(tokens: List[str]) -> bool:
    return len(tokens) > 0 and tokens[0] == "remote"


def is_doc_comment(tokens: List[str]) -> bool:
    return len(tokens) > 0 and tokens[0] == "#"


def parse_client_class(tokenizer: Tokenizer, client_class_name: str) -> Tokenizer:
    tokens = tokenizer.tokenize()
    expected_tokens = ["isolated", "client", "class", client_class_name, "{"]
    while tokens != expected_tokens:
        tokenizer.advance()
        tokens = tokenizer.tokenize()
    return Tokenizer(tokenizer.read_till_end_of_block())


def get_remote_functions(client_path: str) -> List[RemoteFunction]:
    with open(client_path) as f:
        lines = list(map(lambda line: line.rstrip(), f.readlines()))
    tokenizer = Tokenizer(lines)
    tokenizer = parse_client_class(tokenizer, "GsheetClient")
    return parse_remote_functions(tokenizer)


def update_lib(
    lib_path: str, remote_functions: List[RemoteFunction], contentGen: ContentGenFn
):
    with open(lib_path) as f:
        lines = list(map(lambda line: line.rstrip(), f.readlines()))
    content = contentGen(lines, remote_functions)
    with open(lib_path, "w") as f:
        f.write("\n".join(content))


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
