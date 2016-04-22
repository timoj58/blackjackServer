%%%-------------------------------------------------------------------
%%% @author timmytime
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. Apr 2016 16:15
%%%-------------------------------------------------------------------
-module(table_server).
-author("timmytime").

-behaviour(gen_server).

%% API
-export([start_link/0]).

-include("records.hrl").

%% gen_server callbacks
-export([init/1,
  handle_call/3,
  handle_cast/2,
  handle_info/2,
  terminate/2,
  code_change/3,
join_table/1,
leave_table/1,
update_player/1,
find_player/1]).

-define(SERVER, ?MODULE).

-record(state, {}).


start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

join_table(Player) -> gen_server:call(Player#player.id, {join, Player}).

leave_table(Player) -> gen_server:call(Player#player.id, {leave, Player}).

find_player(Player) -> gen_server:call(Player#player.id, {find, Player}).

update_player(Player) -> gen_server:call(Player#player.id, {update, Player}).

init([]) ->
  {ok, table:init_table()}.

handle_call({join, Player}, _From, Table) ->
  Updated = table:join_table(Player, Table),
  {reply, Updated, Updated};

handle_call({leave, Player}, _From, Table) ->
  Updated = table:leave_table(Player, Table) ,
  {reply, ok, Updated, Updated};

handle_call({update, Player}, _From, Table) ->
  table:update_player(Player, Table);

handle_call({find, Player}, _From, Table) ->
  table:find_player(Player, Table);

handle_call(_Request, _From, State) ->
  {reply, ok, State}.


handle_cast(_Request, State) ->
  {noreply, State}.


handle_info(_Info, State) ->
  {noreply, State}.


terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
