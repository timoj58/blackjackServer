%%%-------------------------------------------------------------------
%%% @author timmytime
%%%
%%% Created : 22. Apr 2016 15:24
%%%-------------------------------------------------------------------
-module(blackjack_app).
-author("timmytime").

-behaviour(application).

%% Application callbacks
-export([start/2,
  stop/1,
start_table/2,
stop_table/1]).

%%%===================================================================
%%% Application callbacks
%%%===================================================================


start(_StartType, _StartArgs) ->
  case blackjack_supervisor:start_link() of
    {ok, Pid} ->
      {ok, Pid};
    Error ->
      Error
  end.


stop(_State) ->
  ok.

start_table(Table, {M,F,A}) ->
  blackjack_supervisor:start_table(Table, {M,F,A}).

stop_table(Table) -> blackjack_supervisor:stop_table(Table).



