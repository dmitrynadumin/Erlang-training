-module (star).
-export([make_pid_list/1,stop/1,start/3,central_proc/3,central_loop/4,loop/1,get_ack/1,send_msg/2]).


start(N,Message,Times)->
  if N<2;Times<1->
    io:format("To create a star, you need at least 2 nodes and 1 times.~n");
  true->
    spawn(star,central_proc,[N,Message,Times])
  end.

central_proc(N,Message,Times)->
      io:format("Central process created. Its PID is ~w~n~n",[self()]),
      PIDs = make_pid_list(N-1),
      io:format("PIDs of other processes are ~w~n",[PIDs]),
      central_loop(PIDs,Message,Times,N-1),
      stop(PIDs),
      io:format("The process ~w has been stopped.~n",[self()]).

stop([])->
  done;
stop([H|T])->
  H ! {self(),stop},
  stop(T).

get_ack(0)->
  done;
get_ack(Ack_amount)->
  receive
    {From,ack} -> io:format("The process ~w received the message from ~w.~n",[From,self()])
  end,
  get_ack(Ack_amount-1).

central_loop(PIDs,Message,0,Ack_amount)->
  done;
central_loop(PIDs,Message,Times,Ack_amount)->
  send_msg(PIDs,Message),
  get_ack(Ack_amount),
  central_loop(PIDs,Message,Times - 1,Ack_amount).

send_msg([],Message)->
  done;
send_msg([H|T],Message)->
  H ! {self(),Message},
  send_msg(T,Message).

make_pid_list(1)->
  [spawn(star,loop,[self()])];
make_pid_list(N)->
  [spawn(star,loop,[self()])|make_pid_list(N-1)].



loop(CentralPid)->
  receive
    {CentralPid,stop}->
      io:format("The process ~w has been stopped.~n",[self()]);
    {CentralPid,Message} ->
      io:format("A message <~w> has received from ~w to ~w.~n",[Message,CentralPid,self()]),
      CentralPid ! {self(),ack},
      loop(CentralPid)
end.
