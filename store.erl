-module(store).

-compile(export_all).

start() ->
	spawn(?MODULE, init, []).

init() ->
	register(store, self()),
	Table = ets:new(table, [public, named_table]),
	loop(Table).

loop(Table) ->
	receive
		{From, lookup, Nickname} ->
			io:format("~p asks address of ~s~n", [From, Nickname]),
			[{Nickname, Address}|_] = ets:lookup(Table, Nickname),
			From ! {address, {Nickname, Address}};
		{From, store, {Nickname, Address}} ->
			io:format("~p updates address of ~s to ~s~n", [From, Nickname, Address]),
			ets:insert(Table, {Nickname, Address}),
			From ! {ok, lists:flatten(io_lib:format("you have stored ~s with address: ~s~n", [Nickname, Address]))};
		_ ->
			io:format("no idea~n")
	end,
	loop(Table).

