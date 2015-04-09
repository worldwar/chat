-module(store).

-compile(export_all).

start() ->
	spawn(?MODULE, init, []).

init() ->
	%register(store, self()),
	Table = ets:new(table, []),
	loop(Table).

loop(Table) ->
	receive
		{From, lookup, {Nickname}} ->
			io:format("~w asks address of ~s~n", [From, Nickname]),
			case ets:lookup(Table, Nickname) of
				[{Nickname, Address}|_] ->
					From ! {address, {Nickname, Address}};
				[] ->
					From ! {notfound, {Nickname}}
			end;
		{From, store, {Nickname, Address}} ->
			io:format("~w updates address of ~s to ~s~n", [From, Nickname, Address]),
			ets:insert(Table, {Nickname, Address}),
			From ! {ok, lists:flatten(io_lib:format("you have stored ~s with address: ~s~n", [Nickname, Address]))};
		_ ->
			io:format("no idea~n")
	end,
	loop(Table).

