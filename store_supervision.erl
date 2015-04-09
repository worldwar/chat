-module(store_supervision).

-compile(export_all).

init(N) ->
	register(supervision, self()),
	Pids = [store:start() || _ <- lists:seq(1, N)],
	io:format("Pids:"),
	lists:foreach(fun(Pid) -> io:format(" ~p", [Pid]) end, Pids),
	io:format("~n"),
	loop(Pids, 1, N).

loop(Pids, Index, N) ->
	receive
		{From, lookup, {Nickname}} ->
			lists:nth(Index, Pids) ! {From, lookup, {Nickname}};
		{From, store, {Nickname, Address}} ->
			lists:foreach(fun(Pid) -> {Pid ! {From, store, {Nickname, Address}}} end, Pids);
		_ ->
			io:format("no idea~n")
	end,
	loop(Pids, (Index rem N) + 1, N).