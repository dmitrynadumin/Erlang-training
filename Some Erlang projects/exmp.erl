-module (exmp).
-export ([start/1,loop/0]).

start(N)->
  spawn(exmp,central,[N-1])
central(0)->
  done;
central(N)->
  spawn(exmp,loop,[self()]),
  central(N-1).

loop(CentralPid)->
  Pid ! [self()],
  receive
    Response ->
      io:format("Done~n",[])
  end.

add_to_list()->
