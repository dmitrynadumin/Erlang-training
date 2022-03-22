-module(mathStuff).
-export([perimeter/1]).

perimeter({square,Side})->4*Side;
perimeter({circle,Radius})->2*Radius*3.14;
perimeter({triangle,A,B,C})->A+B+C.
