%%%-------------------------------------------------------------------
%%% @author timmytime
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. Apr 2016 15:25
%%%-------------------------------------------------------------------
-module(blackjack_supervisor).
-author("timmytime").

-behaviour(supervisor).

%% API
-export([start_link/0, start_table/2, stop_table/1]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%%===================================================================
%%% API functions
%%%===================================================================


start_link() ->
  supervisor:start_link({local, blackjack}, ?MODULE, []).

start_table(Table, MFA) ->
  ChildSpec = {Table,
    {dealer_supervisor, start_table, [Table, MFA]},
     permanent, 2000, supervisor, [dealer_supervisor]},
  supervisor:start_child(blackjack, ChildSpec).

stop_table(Table) ->
   supervisor:terminate_child(blackjack, Table),
   supervisor:delete_child(blackjack, Table).


%%%===================================================================
%%% Supervisor callbacks
%%%===================================================================

init([]) ->
  RestartStrategy = one_for_one,
  MaxRestarts = 5,
  MaxSecondsBetweenRestarts = 3000,

  SupFlags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},

  Restart = permanent,
  Shutdown = 2000,
  Type = worker,

  {ok, {SupFlags, []}}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

