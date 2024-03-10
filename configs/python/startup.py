# pylint: disable=missing-docstring, too-few-public-methods, invalid-repr-returned

import readline
import sys

# Disable readline history
readline.write_history_file = lambda *_: None

class MyStartupQuitterImplementation:
    def __repr__(self) -> str:
        sys.exit()

# Exit the REPL with q<Return>
q = MyStartupQuitterImplementation()
