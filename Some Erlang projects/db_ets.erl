-module (db_list).
-export ([start/0,stop/0,insert/3,where_is/1,remove/1,located_at/1,server/1,get_all_located/2]).

start() ->
  register(db_server,spawn(db_list,server,
  [ets:new(db,[bag,{keypos,2}])])),
  ok.


stop() ->
  db_server ! stop,
  server_terminated.

insert(Name,Location,Company) ->
  db_server ! {self(),insert,Name,Location,Company},
  receive
    ok -> ok;
    already_inserted -> already_inserted
  end.

where_is(Name)->
  db_server ! {self(),where_is,Name},
  receive
    no_such_name -> {no_such_name,Name};
    Location -> Location
  end.

remove(Name) ->
  db_server ! {remove,Name},
  ok.

located_at(Location) ->
  db_server ! {self(),located_at,Location},
  receive
    [] -> none;
    Names -> Names
  end.

working_at(Company)->




get_all_located(DB,Location) -> get_all_located(DB,Location,[]).

get_all_located([],Location,Names) ->
  Names;
get_all_located([H | T],Location,Names)->
  if element(2,H)=:=Location ->
    get_all_located(T,Location,[element(1,H) | Names]);
  true ->
    get_all_located(T,Location,Names)
  end.

get_loc([H|T])-> H.

server(DataBase) ->
  %io:format("Current data base ~n~w~n",[DataBase]),
  receive
    stop -> done;
    {From,insert,Name,Location,Company} ->
      case ets:match_object(DataBase,{{name,Name},{location,Location},{company,Company}}) of
          [_,_,_]->
          From ! already_inserted,
          %io:format("already inserted~n",[]),
          server(DataBase);
          [] ->
          From ! ok,
          %io:format("ok~n"),
          ets:insert(DataBase,{{name,Name},{location,Location},{company,Company}}),
          server(DataBase)
      end;
    {From,where_is,Name} ->
    if ets:match(Id,{{name,Name},{location,'$1'},'_'})=:=[] ->

    %case ets:match(Id,{{name,Name},{location,'$1'},'_'}) of
    %  [] ->
        From ! no_such_name,
        %io:format("no such name ~w~n",[Name]),
        server(DataBase);
  %  {Name,Location} ->
    true->
      From
  %      From ! Location,
        %element(2,lists:keyfind(Name,1,DataBase)),
        %io:format("~w~n",[element(2,lists:keyfind(Name,1,DataBase))]),
        server(DataBase)
    end;
     {remove,Name} ->
        server(lists:keydelete(Name,1,DataBase));
     {From,located_at,Location}->
       From ! get_all_located(DataBase,Location),
       server(DataBase)

    end.
