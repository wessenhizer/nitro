-module(element_br).
-author('Lapshin Andrey').
-include_lib("nitro/include/nitro.hrl").
-compile(export_all).

render_element(#br{show_if = false}) -> [];
render_element(#br{}) -> <<"<br />">>.
