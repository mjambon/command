(**
   The ultimate everyday function for running external commands

   - works on all platforms
   - offers the simplest possible interface for common uses
   - less common features may be supported as long as the above conditions
     are met
   - the following features will not be offered by this library:
     * piping between two commands
     * commands running in the background (note that we support running
       multiple commands in parallel, though)
*)

(** Data collected during the execution of the process and returned
    upon completion *)
type status = {
  success : bool;
    (** whether the command terminated successfully i.e. with exit code 0 *)

  exit_code: int;
    (** same exit code as would be returned by [Sys.command] *)

  process_status: Unix.process_status;
    (** exit status as returned by the [Unix] library *)

  stdout: string option;
    (** captured standard output, if it was requested *)

  stderr: string option;
    (** captured error output, if it was requested *)
}

(** Where the new process will read from instead of the inherited stdin *)
type input_redirection =
  | String of string
  | File of string
  | Channel of in_channel

(** Where the new process will write to instead of the inherited stdout
    or stderr *)
type output_redirection =
  | String
  | File of string
  | Channel of out_channel

(** The usual function used to run a command *)
val run :
  ?env:(string * string) list ->
  ?extend_env:(string * string) list ->
  ?name:string ->
  ?stdin:input_redirection ->
  ?stdout:output_redirection ->
  ?stderr:output_redirection ->
  string list -> status

exception Failed of status

(** Check an exit status and raise a [Failed] exception in case
    of a failure *)
val check_status : status -> unit

(** Same as {!run} but raise a [Failed] exception in case of a failure. *)
val run_exn :
  ?env:(string * string) list ->
  ?extend_env:(string * string) list ->
  ?name:string ->
  ?stdin:input_redirection ->
  ?stdout:output_redirection ->
  ?stderr:output_redirection ->
  string list -> unit

type options = {
  env: (string * string) list option;
  extend_env: (string * string) list option;
  name: string option;
  stdin: input_redirection option;
  stdout: output_redirection;
  stderr: output_redirection;
}

(** Pack the options into a record to allow running multiple commands
    in parallel with different options using {!run_multiple}. *)
val options :
  ?env:(string * string) list ->
  ?extend_env:(string * string) list ->
  ?name:string ->
  ?stdin:input_redirection ->
  ?stdout:output_redirection ->
  ?stderr:output_redirection ->
  options

(** Run multiple commands in parallel *)
val run_multiple :
  (string list * options) list ->
  ((string list * options) * status) list

(** Set the approximate maximum length of captured standard output to be
    displayed by {!show_status} and by the exception printer. Excessive
    output is elided in the middle of the string.
    Default: 1000 bytes *)
val set_max_stdout_length : int -> unit
val get_max_stdout_length : unit -> int

(** Set the approximate maximum length of captured error output to be
    displayed by {!show_status} and by the exception printer. Excessive
    output is elided in the middle of the string.
    Default: 1000 bytes *)
val set_max_stderr_length : int -> unit
val get_max_stderr_length : unit -> int

val show_status : status -> string
val pp_status : Format.formatter -> status -> unit

val register_exception_printers : unit -> unit
