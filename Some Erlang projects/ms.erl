-module (ms).
-export ([start/1,get_pids/1,master/1,master_loop/2,slave_loop/1,to_slave/2]).

start(N)->
  if N<1->
    io:format("Should be at least 1 slave.~n",[]);
  true ->
    register(master, spawn(ms,master,[N]))
  end.

get_pids(N) -> get_pids(1,N,[]).

get_pids(N,N,Acc) -> [{N,spawn(ms,slave_loop,[N])} | Acc];

get_pids(I,N,Acc) ->
  get_pids(I+1,N,[{I,spawn(ms,slave_loop,[I])} | Acc]).

master(N)->
  Slaves = lists:reverse(get_pids(N)),
  io:format("~w",[Slaves]),
  master_loop(Slaves,N).

master_loop(Slaves,Slaves_Amount) ->
  receive
    {Pid,slave,Number,die} ->
      io:format("Master restarting dead slave ~w.~n",[Number]),
      master_loop([ {Number,spawn(ms,slave_loop,[Number])} | lists:delete({Number,Pid},Slaves) ], Slaves_Amount);

    {Message,N} ->
      if N>Slaves_Amount;N=<0 ->
        io:format("There is no such element~n.",[]),
        master_loop(Slaves,Slaves_Amount);
      true ->
        %io:format("~w",[element(2,lists:keyfind(N,1,Slaves))]),
        element(2,lists:keyfind(N,1,Slaves)) ! {master,Message},
        master_loop(Slaves, Slaves_Amount)
      end
  end.


slave_loop(Number)->
  receive
    {master,die} -> master ! {self(),slave,Number,die};
    {master,Message} -> io:format("Slave ~w got message ~w~n",[Number,Message]),
    slave_loop(Number)
  end.

to_slave(Message,N)->
  master ! {Message,N}.
