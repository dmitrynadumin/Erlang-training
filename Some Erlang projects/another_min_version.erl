min([X]) -> X;

min([Head | [Head1 | Tail1] = Tail]) ->

               if

                              (Head1 < Head) -> min(Tail);

                              true -> min([Head | Tail1])

               end.
