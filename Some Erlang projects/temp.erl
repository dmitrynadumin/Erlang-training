-module(temp).
-export([convert/1]).

convert({c,C})->{f,C*9/5+32};
convert({f,F})->{c,(F-32)*5/9}.
