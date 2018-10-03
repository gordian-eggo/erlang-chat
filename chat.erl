-module(chat).
-compile(export_all).

% use -sname when running para kumabit yung net_adm:ping()

start1()->        % run in first terminal
  register(user1, spawn(chat, user1, [])).

user1()->         % run in first terminal
  % Debug = "debug string~n",
  % Debug,
  receive
    {User_Pid, Input}->
      Input = io:get_line("Input: "),
      User_Pid ! {self(), input};
    {User_Pid, Message}->
      io:format(Message),
      Input = io:get_line("Input: "),
      User_Pid ! Input
  end,
  user1() ! Input.

start2(User_Pid)->          % start second chat member
  spawn(chat, user2, [1, User_Pid]).

user2(0, User_Pid)->
  {user1, User_Pid} ! bye,
  io:format("Chat has been terminated. ~n");

user2(1, User_Pid)->
  {user1, User_Pid} ! {self(), input};

user2(2, User_Pid)->
  receive
    {User_Pid, Message}->
      io:format(Message),
      Input = io:get_line("Input: "),
      {user1, User_Pid} ! {self(), Input}
  end,
  user2(2, User_Pid).
