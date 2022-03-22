%% ---
%%  Excerpted from "Programming Erlang",
%%  published by The Pragmatic Bookshelf.
%%  Copyrights apply to this code. It may not be used to create training material,
%%  courses, books, articles, and the like. Contact us if you are in doubt.
%%  We make no guarantees that this code is fit for any purpose.
%%  Visit http://www.pragmaticprogrammer.com/titles/jaerlang for more book information.
%%---
-module(area_server0).
-export([loop/0]).

loop() ->
    receive
	{From,{rectangle, Width, Ht}} ->
	    From ! Width * Ht,
	    loop();
	{From,{circle, R}} ->
	    From ! 3.14159 * R * R,
	    loop()
    end.
