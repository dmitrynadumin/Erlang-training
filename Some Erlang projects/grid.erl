-module (grid).
-export([square/1,grid/2,square1/1,grid1/2]).

grid(A,Step) -> grid(A,Step,[]).

grid(A,Step,Acc)->
  if(A<1)->
    grid(A+Step,Step,[A|Acc]);
  true->
    [A|Acc]
  end.

square(N)->
  grid(-1,(1/N)*2).

grid1(A,Step) -> grid1(A,Step,[]).

grid1(A,Step,Acc)->
    if(A+Step)=<1 ->
      grid1(A+Step,Step,[A*A|Acc]);
    true ->
      [1|Acc]
    end.

square1(N)->
  lists:reverse(grid1(0,(1/N))).
