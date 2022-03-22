-module(lists1).
-export([my_min/1]).
-export([my_min/2]).
-export([my_max/1]).
-export([my_max/2]).
-export([min_max/1]).

my_min([])-> io:format("Empty list~n");
my_min([H|T])  ->
        my_min(H, T).

my_min(Min, [H|T]) ->
        case Min < H of
                true -> my_min(Min, T);
                false -> my_min(H, T)
        end;

my_min(Min, []) -> Min.

my_max([])-> io:format("Empty list~n~n");
my_max([H|T])->my_max(H, T).

my_max(Max, [H|T])     ->
                        case Max > H of
                        true    -> my_max(Max, T);
                        false   -> my_max(H, T)
                        end;
my_max(Max, [])        -> Max.


min_max([])->io:format("Empty list");
min_max(L)->{my_min(L),my_max(L)}.
