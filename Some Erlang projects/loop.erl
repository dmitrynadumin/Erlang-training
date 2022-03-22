-module (loop).
-export ([for/1,loop1/0]).


loop1()->
  done.

for(1)->
  [spawn(loop,loop1,[])];
for(N)->
  [spawn(loop,loop1,[])|for(N-1)].
