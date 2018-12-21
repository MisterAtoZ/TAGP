%% Feel free to use, reuse and abuse the code in this file.

%% @doc Hello world handler.
-module(toppage_h).

-export([init/2]).

init(Req0, Opts) ->
	Req = cowboy_req:reply(200, #{
		<<"content-type">> => <<"text/plain">>
	}, {"/", cowboy_static, {priv_file, tagp, "static/index.html"}}, Req0),
	{ok, Req, Opts}.
