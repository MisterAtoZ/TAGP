%% Feel free to use, reuse and abuse the code in this file.

%% @private
-module(tagp_app).
-behaviour(application).

%% API.
-export([start/2]).
-export([stop/1]).

%% API.

start(_Type, _Args) ->
	%Waarde = 2+2,
	%io:format("hier is de survivor normaal gestart~n",[]),
	survivor:start(),
	observer:start(),
	%testModule:start(),
	testModule2:startNPipes(5),
	Dispatch = cowboy_router:compile([
		{'_', [
			{"/[...]", cowboy_static, {priv_dir, tagp, ""}},
			%{"/[...]", cowboy_static, {priv_file, tagp, "priv/index.html"}}
			%{"/[...]", toppage_h, []}
			{"/numberOfPipes?numberOfPipes=5", cowboy_static, {priv_dir, tagp, ""}}
		]}
	]),
	{ok, _} = cowboy:start_clear(my_http_listener, [{port, 8080}], #{
		env => #{dispatch => Dispatch}
	}),
	% {ok, _} = cowboy:start_clear(http, [{port, 8080}], #{
	% 	env => #{dispatch => Dispatch}
	% }),
	tagp_sup:start_link().

stop(_State) ->
	ok.
