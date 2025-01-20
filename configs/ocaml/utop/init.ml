UTop.require [ "lambda-term" ];;

UTop.edit_mode := LTerm_editor.Vi;;

Lazy.force LTerm.stdout |> Lwt.map (Fun.flip LTerm.set_escape_time 0.01);;

LTerm_read_line.bind
  [ { code = Enter; control = false; shift = false; meta = false } ]
  [ UTop.end_and_accept_current_phrase ];;
