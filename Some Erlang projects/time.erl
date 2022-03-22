-module(time).
-export([swedish_date/0]).

swedish_date()->
{Y,M,D}=date(),
Y1 = Y rem 100,
case M < 10 of
      true ->
                case D < 10 of
                true -> lists:concat([Y1,0,M,0,D]);
                false -> lists:concat([Y1,0,M,D])
                end;
      false ->
                case D < 10 of
                true -> lists:concat([Y1,M,0,D]);
                false -> lists:concat([Y1,M,D])
                end
end.
