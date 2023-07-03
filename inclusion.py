from enum import Enum
import re
from typing import List, Optional, Tuple, Union

# doc comment, code
RemoteFunction = Tuple[List[str], List[str]]
# Client class name, variable name
InclusionMacro = Tuple[str, str]
# "end"
EndMacro = Tuple[None]
Macro = Union[InclusionMacro, EndMacro]

# signature line (excluding "{"), function_name, [(param type, param name)]
FunctionSignature = Tuple[str, str, List[Tuple[str, str]]]


class Tokenizer:
    def __init__(self, lines: List[str]) -> None:
        self.line_no = 0
        self.lines = lines

    def read_till_end_of_block(self) -> List[str]:
        """This will read lines until the end of the current block.

        Assumptions:
            Block ends at a clean new line (ie `...}\n`).
        """
        opening_brace_count, closing_brace_count = brace_count(
            self.current_line())
        left_open = opening_brace_count - closing_brace_count
        # Block could open and close in the same line
        lines = [self.current_line()]
        while left_open > 0 and not self.is_end():
            self.advance()
            lines.append(self.current_line())
            opening_brace_count, closing_brace_count = brace_count(
                self.current_line())
            left_open += opening_brace_count - closing_brace_count
        if left_open > 0:
            raise RuntimeError("Block not closed")
        return lines

    def advance(self) -> None:
        self.line_no += 1

    def current_line(self) -> str:
        return self.lines[self.line_no]

    def tokenize(self) -> List[str]:
        line = self.current_line()
        tokens = []
        current_token = ""
        i = 0
        while i < len(line):
            char = line[i]
            if char == " ":
                if current_token != "":
                    tokens.append(current_token)
                current_token = ""
            if char == "(" and i < len(line) - 1 and line[i + 1] == ")":
                tokens.append("()")
                i += 2
                continue
            if is_delimiter(char):
                tokens.append(current_token)
                tokens.append(char)
                current_token = ""
            else:
                current_token += char
            i += 1
        return list(filter(lambda x: x != "", map(lambda x: x.strip(), tokens)))

    def is_end(self) -> bool:
        return self.line_no >= len(self.lines)

    def print_lines(self) -> None:
        for line in self.lines:
            print(line)


def is_delimiter(char: str) -> bool:
    delimiters = ["(", ")", "{", "}", ",", ";", "="]
    return char in delimiters


def brace_count(line: str) -> Tuple[int, int]:
    """Returns the number of opening and closing braces in the line."""
    return line.count("{"), line.count("}")


def new_lib_content(lines: List[str], remote_functions: List[RemoteFunction]) -> List[str]:
    tokenizer = Tokenizer(lines)
    new_lines: List[str] = []
    while not tokenizer.is_end():
        line = tokenizer.current_line()
        macro = try_parse_macro(line)
        if macro is None:
            new_lines.append(line)
            tokenizer.advance()
            continue
        if macro[0] is not None:
            new_lines.append(line)
            # TODO: generate the inclusion methods here
            for each in remote_functions:
                new_lines.extend(remote_function_defn(each, macro[1]))
            tokenizer.advance()
            macro = try_parse_macro(tokenizer.current_line())
            while macro is None or macro[0] is not None:
                tokenizer.advance()
                macro = try_parse_macro(tokenizer.current_line())
            new_lines.append(tokenizer.current_line())
            tokenizer.advance()
    return new_lines


def remote_function_defn(function: RemoteFunction, var_name: str) -> List[str]:
    content = []
    for comment in function[0]:
        content.append(indent_line(comment, 1))
    signature, fn_name, params = parse_remote_function_signature(function[1])
    # FIXME: remove inner when we have removed confliciting names
    content.append(indent_line(signature.replace(fn_name, f'{fn_name}_inner') + "{", 1))
    # content.append(indent_line(signature + "{", 1))
    args = [param[1] for param in params]
    call_tokens = [f'return self.{var_name}->{fn_name}(']
    for i, arg in enumerate(args):
        if i > 0:
            call_tokens.append(", ")
        call_tokens.append(arg)
    content.append(indent_line("".join(call_tokens)+");", 2))
    content.append(indent_line("}\n", 1))
    return content


def indent_line(line: str, indent: int) -> str:
    return " " * (indent * 4) + line.strip()


def parse_remote_function_signature(lines: List[str]) -> FunctionSignature:
    tokenizer = Tokenizer(lines)
    signature_tokens = []
    param_types: List[Tuple[str, str]] = []
    in_param_list = False
    function_name = ""
    while not tokenizer.is_end():
        tokens = tokenizer.tokenize()
        i = 0
        while i < len(tokens):
            token = tokens[i]
            if token == "{":
                signature_line = to_line(signature_tokens)
                return signature_line, function_name, param_types
            if token == "function":
                function_name = tokens[i + 1]
            if in_param_list:
                if token == ")":
                    in_param_list = False
                else:
                    param_type = token
                    param_name = tokens[i + 1]
                    param_types.append((param_type, param_name))
                    signature_tokens.append(param_type)
                    signature_tokens.append(param_name)
                    # advance till we see a comma or closing brace
                    j = i + 2
                    while j < len(tokens):
                        signature_tokens.append(tokens[j])
                        if tokens[j] == "," or tokens[j] == ")":
                            if tokens[j] == ")":
                                in_param_list = False
                            break
                        j += 1
                    i = j + 1
                    continue
            if token == "(":
                in_param_list = True
            signature_tokens.append(token)
            i += 1
        tokenizer.advance()
    raise RuntimeError("Failed to parse function signature")


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


def try_parse_macro(line: str) -> Optional[Macro]:
    line = line.strip()
    if "includeClient!" in line:
        return parse_inclusion_macro(line)
    elif "end!" in line:
        return None,
    return None


def parse_inclusion_macro(line: str) -> InclusionMacro:
    m = re.search(r"includeClient!\((\S*)\s*,\s*(\S*)\)", line)
    if m:
        return m.group(1), m.group(2)
    raise RuntimeError(f"Invalid inclusion macro: {line}")


def parse_remote_functions(tokenizer: Tokenizer) -> List[RemoteFunction]:
    # Note: this expect tokenizer to be GsheetClient tokenizer
    remote_functions: List[RemoteFunction] = []
    doc_comment: List[str] = []
    while not tokenizer.is_end():
        while is_doc_comment(tokenizer.current_line()):
            doc_comment.append(tokenizer.current_line())
            tokenizer.advance()
        if not is_remote_func_start(tokenizer.current_line()):
            tokenizer.advance()
            doc_comment = []
            continue
        code = tokenizer.read_till_end_of_block()
        remote_functions.append((doc_comment, code))
    return remote_functions


def is_remote_func_start(line: str) -> bool:
    return line.strip().startswith("remote isolated function")


def is_doc_comment(line: str) -> bool:
    return line.strip().startswith("#")


def parse_client_class(tokenizer: Tokenizer, client_class_name: str) -> Tokenizer:
    tokens = tokenizer.current_line().strip().split()
    expected_tokens = ["isolated", "client", "class", client_class_name, "{"]
    while tokens != expected_tokens:
        tokenizer.advance()
        tokens = tokenizer.current_line().strip().split()
    return Tokenizer(tokenizer.read_till_end_of_block())


if __name__ == "__main__":
    # TODO: accept client path and lib path as arguments
    with open("client.bal") as f:
        lines = list(map(lambda line: line.rstrip(), f.readlines()))
    tokenizer = Tokenizer(lines)
    tokenizer = parse_client_class(tokenizer, "GsheetClient")
    remote_functions = parse_remote_functions(tokenizer)
    with open("lib.bal") as f:
        lines = list(map(lambda line: line.rstrip(), f.readlines()))
    content = new_lib_content(lines, remote_functions)
    with open("lib.bal", "w") as f:
        f.write("\n".join(content))
