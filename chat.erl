-module(chat).
-compile(export_all).

start1()->
  register(user1, spawn(chat, user1, [])).

user1()->
  receive
    {User_Pid, input}->
      Input = io:get_line("Input: "),
      User_Pid ! {self(), input};
    {User_Pid, Message}->
      io:format(Message),
      Input = io:get_line("Input: "),
      User_Pid ! input
  end,
  user1() ! input.

start2(User_Pid)->
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
