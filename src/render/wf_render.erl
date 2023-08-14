-module(wf_render).
-include_lib("nitro/include/nitro.hrl").
-export([render/1]).


render(R) ->
  [r(E) || E <- lists:flatten([R]), E /= undefined, E /= nil, E /= <<>>].
  % unicode:characters_to_binary(L).


r(E) when element(2,E) =:= element -> wf_render_elements:render_element(E);
r(E) when element(2,E) =:= action  -> wf_render_actions:render_action(E);
r(R) when is_binary(R) -> [r(E) || E <- unicode:characters_to_list(R)];
r(A) when is_atom(A) -> atom_to_list(A);
r($<) -> "&lt;";
r($>) -> "&gt;";
r($") -> "&quot;";
r(Any) -> Any.

% item([]) -> <<>>;
% item(undefined) -> <<>>;
% item(E) when element(2,E) =:= element -> wf_render_elements:render_element(E);
% item(E) when element(2,E) =:= action  -> wf_render_actions:render_action(E);
% item(E) -> e(E).

% r([]) -> <<>>;
% r(undefined) -> <<>>;
% % r(<<E/binary>>) -> E;
% r(Elements) when is_list(Elements) ->
%   [ r(E) || E <- Elements, E /= undefined, E /= nil, E /= [], E /= <<>> ];
% r(E) when element(2,E) =:= element -> wf_render_elements:render_element(E);
% r(E) when element(2,E) =:= action  -> wf_render_actions:render_action(E);
% r(Any) -> e(Any).


% e([]) -> [];
% e(R) when is_binary(R) -> e(unicode:characters_to_list(R));
% e([$< | T]) -> "&lt;" ++ e(T);
% e([$> | T]) -> "&gt;" ++ e(T);
% e([$" | T]) -> "&quot;" ++ e(T);
% % e(<<$<, T/binary>>) -> <<"&lt;", (e(T))/binary>>;
% % e(<<$>,  T/binary>>) -> <<"&gt;", (e(T))/binary>>;
% e([H | T]) when is_list(H); is_binary(H) -> [e(H) | e(T)];
% e([H | T]) -> [H | e(T)];
% e(Any) -> nitro:to_binary(Any).
