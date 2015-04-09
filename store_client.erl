-module(store_client).

-compile(export_all).

lookup(Nickname) ->
	server() ! {self(), lookup, {Nickname}},
	receive
		{address, {Nickname, Address}} ->
			io:format("~s's address is ~s~n", [Nickname, Address]);
		{notfound, {Nickname}} ->
			io:format("Sorry, We can't find ~s's address~n", [Nickname]);
		_ -> ok
	end.

store(Nickname, Address) ->
	server() ! {self(), store, {Nickname, Address}}.


server() ->
	{supervision, 'server@sz-zhur'}.