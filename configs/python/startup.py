import readline
import sys

# Disable readline history
readline.write_history_file = lambda *_: None

class _myStartupQuitter:
    def __repr__(self): # pylint: disable=invalid-repr-returned
        sys.exit()

# Exit the repl with q<enter>
q = _myStartupQuitter()
