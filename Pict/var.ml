
type var = string * int

let base = ref ""
let counter = ref 0

let setModuleName n =
  let sz = String.length n in
  let e = String.create (sz * 3 + 6) in
  String.blit "pict_" 0 e 0 5;
  let rec encode x p =
    if x = sz then (String.set e p '_'; p+1) else
    let c = String.get n x in
    if
      (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') ||
      (c >= '0' && c <= '9')
    then
      (String.set e p c; encode (x+1) (p+1))
    else
      (String.set e p '_'; encode (x+1) (p+1))
in
  base := String.sub e 0 (encode 0 5)

let fresh () = incr counter; (!base,!counter)
let local () = incr counter; ("v",!counter)
let indexed i = ("l",i)

(*
 * The name of the top-level process (must be guaranteed distinct
 * from any other top-level identifier generated by Pict).
 *)

let main = ("pictMain",0)

let name (m,x) = m ^ string_of_int x
let print os (m,x) = output_string os m; output_string os (string_of_int x)
let format (m,x) = Format.print_string m; Format.print_int x

module Map =
  Misc.Make(struct
    type t = var
    let compare = compare
  end)