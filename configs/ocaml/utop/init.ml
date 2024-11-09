#edit_mode_vi;;
#require "lambda-term";;
Lwt.map (fun term -> LTerm.set_escape_time term 0.01) (Lazy.force LTerm.stdout);;
