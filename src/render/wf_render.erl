-module(wf_render).
-include_lib("nitro/include/nitro.hrl").
-export([render/1, render1/1, tag/1, js/1]).


render(R) -> r(html, uto_list([R])).
  % [r(esc, E) || E <- uto_list(R), E /= undefined, E /= nil, E /= <<>>, E /= []].

render1(R) -> r(no, uto_list([R])).
  % [r(no, E) || E <- uto_list(R), E /= undefined, E /= nil, E /= <<>>, E /= []].

tag(R) when is_binary(R); is_list(R) -> uto_bin(r(tag, uto_list([R])));
  % io:fwrite("tag before: ~p~n", [R]),
  % R1 = uto_bin(r(tag, uto_list([R]))),
  % io:fwrite("tag result: ~p~n", [R1]),
  % R1;
tag(R) -> nitro:to_binary(R).

js(R) -> r(js, uto_list([R])).


r(_, []) -> [];
r(Esc, [undefined|T]) -> r(Esc, T);
r(Esc, [nil|T]) -> r(Esc, T);
r(Esc, [[]|T]) -> r(Esc, T);
r(Esc, [<<>>|T]) -> r(Esc, T);
r(Esc, [A | T]) when is_atom(A) -> [atom_to_binary(A) | r(Esc, T)];
r(Esc, [#raw{v = V} | T]) -> [V | r(Esc, T)];
r(Esc, [E|T]) when element(2,E) =:= element ->
  [wf_render_elements:render_element(E) | r(Esc, T)];
r(Esc, [E|T]) when element(2,E) =:= action  ->
  [wf_render_actions:render_action(E) | r(Esc, T)];
% r(_, E) when element(2,E) =:= element -> wf_render_elements:render_element(E);
% r(_, E) when element(2,E) =:= action  -> wf_render_actions:render_action(E);
r(Esc, [R | T]) when is_binary(R) -> r(Esc, [unicode:characters_to_list(R) | T]);
r(Esc, [A | T]) when is_atom(A) -> atom_to_list(A) ++ r(Esc, T);
r(Esc, [$< | T]) when Esc =:= html; Esc =:= tag -> "&lt;" ++ r(esc, T);
r(Esc, [$> | T]) when Esc =:= html; Esc =:= tag -> "&gt;" ++ r(esc, T);
r(tag, [$" | T]) -> "&quot;" ++ r(tag, T);
r(tag, [$ , $  | T]) -> r(tag, [$ |T]);
r(tag, [$ , $\n | T]) -> r(tag, [$ |T]);
r(tag, [$\n | T]) -> r(tag, [$ |T]);
r(js,  [$\\, $\\ | T]) -> "\\\\" ++ r(js, T);
r(js,  [$\\, $r | T]) -> "\\r" ++ r(js, T);
r(js,  [$\\, $n | T]) -> "\\n" ++ r(js, T);
r(js,  [$\\, $" | T]) -> "\\\"" ++ r(js, T);
r(js,  [$' | T]) -> "\\'" ++ r(js, T);
r(js,  [$` | T]) -> "\\`" ++ r(js, T);
r(Esc, [Any | T]) -> [Any | r(Esc, T)].

% r(_, E) when element(2,E) =:= element -> wf_render_elements:render_element(E);
% r(_, E) when element(2,E) =:= action  -> wf_render_actions:render_action(E);
% r(Esc, R) when is_binary(R) -> [r(Esc, E) || E <- unicode:characters_to_list(R)];
% r(_, A) when is_atom(A) -> atom_to_list(A);
% r(esc, $<) -> "&lt;";
% r(esc, $>) -> "&gt;";
% r(esc, $") -> "&quot;";
% r(_, Any) -> Any.


uto_bin(L) ->
  case unicode:characters_to_binary(L, unicode) of
    {_, S, _} -> S; S -> S end.


uto_list(L) when is_list(L) ->
  lists:flatten([uto_list(E) || E <- lists:flatten(L)]);
uto_list(S) when is_binary(S) ->
  case unicode:characters_to_list(S, unicode) of
    {_, L, _} -> L; L -> L end;
uto_list(Any) -> Any.
