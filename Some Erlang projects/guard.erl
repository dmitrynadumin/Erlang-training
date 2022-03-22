-module(guard).
-export([foo/1]).


% ; - означает ИЛИ. , - означает И.
foo(X) when X=:=dog;X=:=cat -> hello;
foo(X) when is_integer(X) -> X;
foo(X) -> hi.
