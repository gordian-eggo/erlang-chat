-module(ruzranosa).
-import(string, [chomp/1]).
-compile(export_all).

% start_chat() ->
% 	register(chat, spawn(ruzranosa, chat, [])).

% get_username_and_password() ->
% 	Temp_User = io:get_line("Enter username: "),
% 	% Temp_Pass = io:get_line("Enter password: "),
% 	Username = string:chomp(Temp_User),
% 	io:format("~s~n", [Username]). 

% ^ tangina niyan forever huhu move on muna ako

host_chat(Node) ->									% error in these succeeding blocks
	net_adm:ping(Node),								% wala pang exit so tinry ko muna i-quit using q().		
	start_pong(),									% magku-quit siya sa terminal na nagjoin pero hindi sa terminal na naghost ng chat
	start_ping(Node).

join_chat(Node) ->
	start_pong(),
	start_ping(Node).

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

% QUESTIONS:

%	> kailangan bang may function para kunin yung pid ng pc? kasi diba
%	  required yung long name/short name para makapagpasa ng messages, so
%	  do we need a function that does that automatically?