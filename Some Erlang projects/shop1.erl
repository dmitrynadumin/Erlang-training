-module(shop1).
-export([total/1]).
total([{What, N}|T]) -> shop:cost(What) * N + total(T);
total([]) -> 0.
%Это рекурсивная функция, которая проходится по всему списку и находит общую стоимость
