-module(start_two_proc).
-export([start/2,client/3,server/0]).

start(Message,Times)->
  Server_Pid = spawn(start_two_proc,server,[]),
  spawn(start_two_proc,client,[Message,Times,Server_Pid]).

client(Message,0,Server_Pid)->
  Server_Pid ! finished,
  io:format("The client has been finished.~n",[]);
client(Message,Times,Server_Pid)->
  Server_Pid ! {self(),Message},
  receive
    {Server_Pid,Message}->
      io:format("The message has been delivered and returned.~n",[])
  end,
  client(Message,Times - 1,Server_Pid).

server()->
  receive
    finished ->
      io:format("The server has been finished.~n",[]);
    {Client_Pid,Message} ->
      Client_Pid ! {self(),Message},
      server()
  end.
