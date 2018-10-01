-module(ruzranosa).
-compile(export_all).

start_chat() ->
	register(chat, spawn(ruzranosa, chat, [])).

chat() ->
	receive
		bye ->
			io:format("goodbye~n");
		{ping, Ping_Pid} ->
			io:format("got da ping~n"),
			Ping_Pid ! pong,
			chat()
	end.

start_convo(Pong_Node) ->
	spawn(ruzranosa, convo, [3, Pong_Node]).

convo(0, Pong_Node) ->
	{pong, Pong_Node} ! bye,
	io:format("ping's done~n");

convo(N, Pong_Node) ->
	{pong, Pong_Node} ! {ping, self()},
	receive
		pong ->
			io:format("Ping trade pong~n")
	end, 
	convo(N-1, Pong_Node).