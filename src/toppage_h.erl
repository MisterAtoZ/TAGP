%% Feel free to use, reuse and abuse the code in this file.

%% @doc Hello world handler.
-module(toppage_h).

-export([init/3, handle/2, terminate/3]).

init(_Type, Req0,_Opts) ->
	{ok, Req0, undefined_state}.

handle(Req0, State) ->
	{ok,Req} = cowboy_req:reply(200, {},
		{"/[...]", cowboy_static, {priv_dir, tagp, ""}}, Req0),
	{ok, Req, State}.

terminate(_Reason, _Req, _State) ->
	ok.