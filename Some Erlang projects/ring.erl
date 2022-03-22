-module (ring).
-export([start/3,start_proc/3,first_proc/3,first_loop/3,loop/2]).

start(N,Message,Times)->
  spawn(ring,first_proc,[N,Message,Times]).

first_proc(N,Message,Times)->
  if
    N<2;Times<1 ->
      io:format("To create a ring, you need at least 2 nodes and 1 times.~n");
    true ->
      io:format("First process was created.~n"),
      Next_Pid = spawn(ring,start_proc,[N-1,self(),Times]),
      first_loop(Next_Pid,Times,Message),
      io:format("All created process was closed.~n")
  end.

first_loop(Next_Pid,Times,Message)->
  io:format("~w from ~w~n",[Message,self()]),
  case Times of
    Times when Times>1 ->
      Next_Pid ! Message,
      receive
        Message ->
          io:format("The message passed through the ring.~n"),
          first_loop(Next_Pid,Times - 1,Message)
      end;
    Times when Times =:=1 ->
          Next_Pid ! Message,
          receive
            Message->
              io:format("The message passed through the ring.~n")
          end
  end.

loop(Next_Pid,Times)->
  case Times of
    Times when Times>1 ->
      receive
        Message ->
          io:format("~w from ~w~n",[Message,self()]),
          Next_Pid ! Message,
          loop(Next_Pid,Times - 1)
        end;
    Times when Times =:=1 ->
      receive
        Message ->
          io:format("~w from ~w~n",[Message,self()]),
          Next_Pid ! Message
      end
  end.






start_proc(1,First_Pid,Times)->
  loop(First_Pid,Times);

start_proc(N,First_Pid,Times)->
  Next_Pid = spawn(ring,start_proc,[N-1,First_Pid,Times]),
  loop(Next_Pid,Times).
