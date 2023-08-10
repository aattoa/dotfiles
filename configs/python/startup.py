import readline

# Disable readline history
readline.write_history_file = lambda *_: None

# Enable quit on Q
class __my_startup_quitter_implementation__:
    def __repr__(self):
        exit(0)
q = __my_startup_quitter_implementation__()
