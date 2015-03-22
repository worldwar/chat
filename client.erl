-module(client).
-compile(export_all).

start() ->
	spawn(?MODULE, receive_init, []).
	%spawn(?MODULE, send_loop, []).
	
receive_init() ->
	register(client_receiver, self()),
	receive_loop().

receive_loop() ->
	io:format('start to receive~n'),
	receive
		{login, ok, Names} -> 
			io:format('~p~n', [Names]);
		{message, Name, Message} ->
			io:format('~s had just send you a message: ~s ~n', [Name, Message]);
		{error, Message} ->
			io:format('some thing wrong; ~s ~n', [Message]);
		{buddies, Names} ->
			io:format('available buddies: ~p ~n', [Names]);
		_ ->
			io:format("on idea ^_^")
	end,
	receive_loop().

send_loop() ->
	{ok, [_|_]} = io:fread("Please say some words:", "~d"),
	io:format("start to send~n"),
	{world, 'server@pengmengqius-MacBook-Pro'} ! {{client_receiver, 'client@pengmengqius-MacBook-Pro'}, buddies},
	send_loop().
	
hello() ->
	io:format("hello~n").
	
login() ->
	{ok, [Name|_]} = io:fread("Please input your name:", "~s"),
	io:format("start to login as ~s~n", [Name]),
	server() ! {{Name, receiver()}, login}.
	
server() ->
	{world, 'server@pengmengqius-MacBook-Pro'}.
	
receiver() ->
	%{client_receiver, 'client@pengmengqius-MacBook-Pro'}.
	{client_receiver, node()}.
	
send_message(MyName, Name, Message) ->
	server() ! {{MyName, receiver()}, {message, Name, Message}}.
	
buddies() ->
	server() ! {{"Random", receiver()}, buddies}.