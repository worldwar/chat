-module(chat_server).

-export([
	start/0,
	stop/0,
	say_hello/0,
	get_count/0
]).

-export([init/0, state/0]).

-define(SERVER, ?MODULE).

-record(state, {count}).

start() ->
	spawn(?MODULE, init, []).

stop() -> ?SERVER ! stop,
  ok.

say_hello() ->
	?SERVER ! say_hello,
	ok.

get_count() -> ?SERVER ! {self(), get_count},
  receive
	  {count, Value} -> Value
  end.

init() ->
	register(?SERVER, self()),
	loop(#state{count=0}).
	
state() -> #state{count=1}.
	
loop(#state{count=Count}) ->
	receive Msg ->
		case Msg of
			stop ->
				exit(normal);
			say_hello ->
				io:format("Hello~n");
			{From, get_count} ->
				io:format("I get the request!~n"),
				From ! {count, Count}
		end
	end,
	loop(#state{count = Count + 1}).
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
					

