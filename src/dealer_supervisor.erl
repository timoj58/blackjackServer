%%%-------------------------------------------------------------------
%%% @author timmytime
%%%
%%% Created : 22. Apr 2016 15:41
%%%-------------------------------------------------------------------
-module(dealer_supervisor).
-author("timmytime").

-behaviour(supervisor).

%% API
-export([start_link/2]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%%===================================================================
%%% API functions
%%%===================================================================


start_link(Table, MFA) ->
  supervisor:start_link({local, ?SERVER}, ?MODULE, [Table, MFA]).

%%%===================================================================
%%% Supervisor callbacks
%%%===================================================================


init([]) ->
  RestartStrategy = one_for_one,
  MaxRestarts = 1,
  MaxSecondsBetweenRestarts = 3600,

  SupFlags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},

  Restart = permanent,
  Shutdown = 2000,
  Type = worker,

  AChild = {dealer, {dealer, join_table, []},
    permanent, 1000, worker, [dealer]},

  {ok, {SupFlags, [AChild]}}.


