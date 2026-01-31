RFC: Command library for OCaml
==

An everyday function named `Command.run` for running external commands
from OCaml programs without losing too many brain cells.

The proposal is
[Command.mli](https://github.com/mjambon/command/blob/main/Command.mli).

Design constraints
--

1. Works on all platforms
2. Must be as easy to use as possible for common use cases
3. Supports many options with good defaults for less common use cases
4. Must be small enough to be properly tested and maintained over the years

Scope
--

Running external commands by creating subprocesses and waiting for
them to complete.

From the design constraints derive these requirements:

* `Command.run_exn ["ls"]` and `let status = Command.run ["ls"]` do
  the obvious.
* Works on Unixes and on Windows
* Doesn't rely on a shell
* Doesn't try to be a shell replacement. For example, the following
  features are out of scope:
  - pipelines
  - running commands in the background
* Takes optional arguments: extensible input type, good defaults
* Returns a record: extensible output type
