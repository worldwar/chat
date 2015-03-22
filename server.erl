-module(server).
-compile(export_all).

start() ->
	spawn(?MODULE, init, []).
	
init() ->
	register(world, self()),
	loop([]).
	
names(Peers) ->
	[Name||{Name, _} <- Peers].

address(_, []) -> undefined;
address(Name, [{Name, Address} | _]) -> Address;
address(Name, [_|Tail]) -> address(Name, Tail).

loop(Peers) ->
	receive
		{{_, From}, buddies} ->
			io:format("handling request of command buddies~n"),
			io:format("~p~n",[names(Peers)]),
			From ! {buddies, names(Peers)};
		{{Name, From}, login} ->
			io:format("~s has login in chat system!~n", [Name]),
			NewPeers = [{Name, From} | Peers],
			From ! {login, ok, names(NewPeers)},
			loop(NewPeers);
		{{Name, From}, {message, ToName, Message}} ->
			io:format("~s has send a message to ~s: ~s~n", [Name, ToName, Message]),
			Address = address(ToName, Peers),
			if
				Address =:= undefined -> From ! {error, "no buddy named " ++ ToName};
				true ->
					io:format("find address for ~s ~n", [ToName]),
					Address ! {message, Name, Message}
			end;
		_ -> io:format("no idea~n")
	end,
	loop(Peers).

