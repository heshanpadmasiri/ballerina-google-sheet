from typing import List, Tuple

# doc comment, code
RemoteFunction = Tuple[List[str], List[str]]

class Parser:
    def __init__(self, lines: List[str]) -> None:
        self.line_no = 0
        self.lines = lines

    def read_till_end_of_block(self) -> List[str]:
        """This will read lines until the end of the current block.

        Assumptions:
            Block ends at a clean new line (ie `...}\n`).
        """
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
        return lines

    def advance(self) -> None:
        self.line_no += 1

    def current_line(self) -> str:
        return self.lines[self.line_no]

    def is_end(self) -> bool:
        return self.line_no >= len(self.lines)

    def print_lines(self) -> None:
        for line in self.lines:
            print(line)


def brace_count(line: str) -> Tuple[int, int]:
    """Returns the number of opening and closing braces in the line."""
    return line.count("{"), line.count("}")

# Note: this expect parser to be GsheetClient parser
def parse_remote_functions(parser: Parser) -> List[RemoteFunction]:
    remote_functions: List[RemoteFunction] = []
    doc_comment: List[str] = []
    while not parser.is_end():
        while is_doc_comment(parser.current_line()):
            doc_comment.append(parser.current_line())
            parser.advance()
        if not is_remote_func_start(parser.current_line()):
            parser.advance()
            doc_comment = []
            continue
        code = parser.read_till_end_of_block()
        remote_functions.append((doc_comment, code))
    return remote_functions

def is_remote_func_start(line: str) -> bool:
    return line.strip().startswith("remote isolated function")

def is_doc_comment(line: str) -> bool:
    return line.strip().startswith("#")

def parse_client_class(parser: Parser, client_class_name: str) -> Parser:
    tokens = parser.current_line().strip().split()
    expected_tokens = ["isolated", "client", "class", client_class_name, "{"]
    while tokens != expected_tokens:
        parser.advance()
        tokens = parser.current_line().strip().split()
    return Parser(parser.read_till_end_of_block())

if __name__ == "__main__":
    # TODO: accept client path and client class name as arguments
    with open("client.bal") as f:
        lines = list(map(lambda line: line.rstrip(), f.readlines()))
    parser = Parser(lines)
    parser = parse_client_class(parser, "GsheetClient")
    remote_functions = parse_remote_functions(parser)
    for doc_comment, code in remote_functions:
        print("Doc comment:")
        print(doc_comment)
        print("Code:")
        print(code)
        print("=====================================")
