-module(testModule2).
-export([startSimpleTest/0]).
-export([startNPipes/1]).
-export([makePipes/3]).
-export([connectPipes/1]).
-export([stop/0, getAllConnectors/1]).

startSimpleTest() ->
	%survivor:start(),
	observer:start(),
	{ok, PipeTypePID} = resource_type:create(pipeTyp,[]),
	{ok,Pipe1InstPID} = resource_instance:create(pipeInst,[self(),PipeTypePID]),
	{ok,Pipe2InstPID} = resource_instance:create(pipeInst,[self(),PipeTypePID]),
	{ok,Pipe3InstPID} = resource_instance:create(pipeInst,[self(),PipeTypePID]),
	{ok,[P1C1,P1C2]} = resource_instance:list_connectors(Pipe1InstPID),
	{ok,[P2C1,P2C2]} = resource_instance:list_connectors(Pipe2InstPID),
	{ok,[P3C1,P3C2]} = resource_instance:list_connectors(Pipe3InstPID),
	
	connector:connect(P2C2,P3C1),
	connector:connect(P1C1,P3C2),
	connector:connect(P1C2,P2C1),
	
	Pipe1InstPID.

startNPipes(N) ->
	%This module strives to:
	%1) Create N pipe instances
	%2) Create a network containing all N pipes, connecting them in a circle
	% observer:start(),
	% survivor:start(),
	{ok,PipeTypePID} = resource_type:create(pipeTyp,[]),
	Pipes = makePipes(N,[], PipeTypePID),
	io:format("~p pipes are made ~n", [N]),
	%now all pipes are made, the need to be connected together
	%All pipes in the list are connected with the one behind and in front of it
	%The last and first pipe in the list are also connected
	connectPipes(Pipes).
	%ok = connectPipesCircle(Pipes),
	%{n_connected_circle,N,Pipes}.


%Recursive Function to make N amount of pipes
% makePipes(N,[], _PipeTypePID) when N =< 0 ->
% 	[];
%This adds the last pipe to the list
makePipes(1, PipeList, PipeTypePID) ->
	{ok,PipeInstPID} = resource_instance:create(pipeInst,[self(),PipeTypePID]),
	%PipeList = [PipeList | PipeInstPID];
	PipeList ++[PipeInstPID];

makePipes(N, PipeList, PipeTypePID) ->
	if N > 1 ->
		{ok,PipeInstPID} = resource_instance:create(pipeInst,[self(),PipeTypePID]),
		%PipeList = [PipeList | PipeInstPID],
		NewPipeList = PipeList ++[PipeInstPID],
		M = N-1,
		makePipes(M, NewPipeList, PipeTypePID);
	 true ->
		io:format("N has a negative value!~n"),
	 	{error, "N has a negative value"}
	end.

connectPipes([FirstPipe|OtherPipes]) ->
	connectPipes(FirstPipe, FirstPipe, OtherPipes).

connectPipes(FirstPipe, PipeToConnect, [MiddlePipe | OtherPipes]) ->
	%The PipeToConnect gets connected with the newt pipe in the list,
	%this is the MiddlePipe
	{ok,[_P1C1,P1C2]} = resource_instance:list_connectors(PipeToConnect),
	{ok,[P2C1,_P2C2]} = resource_instance:list_connectors(MiddlePipe),
	connector:connect(P1C2, P2C1),
	connectPipes(FirstPipe, MiddlePipe, OtherPipes);

connectPipes(FirstPipe, PipeToConnect, []) ->
	%If the List of to do Pipes is empty, the first and last Pipe need to be connected
	%The end connector of the first Pipe and the end connector of the last pipe
	%are already used! this means the other pipes need to be used
	{ok,[P1C1,_P1C2]} = resource_instance:list_connectors(FirstPipe),
	{ok,[_P2C1,P2C2]} = resource_instance:list_connectors(PipeToConnect),
	connector:connect(P1C1, P2C2).


stop() ->
	survivor ! stop,
	{ok, stopped}.
	
getAllConnectors(Pipes) ->
	getAllConnectors(Pipes,[]).
	
getAllConnectors([Pipe|OtherPipes],Connectors) ->
	{ok,Cs} = resource_instance:list_connectors(Pipe),
	getAllConnectors(OtherPipes,Connectors++Cs);
	
getAllConnectors([],Connectors) ->
Connectors.