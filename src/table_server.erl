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
join_table/2,
leave_table/2,
update_player/2,
find_player/2]).

-define(SERVER, ?MODULE).

-record(state, {}).


start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

join_table(Player, Pid) -> gen_server:call(Pid, {join, Player}).

leave_table(Player, Pid) -> gen_server:call(Pid, {leave, Player}).

find_player(Player, Pid) -> gen_server:call(Pid, {find, Player}).

update_player(Player, Pid) -> gen_server:call(Pid, {update, Player}).

init([]) ->
  io:format("Table Started~n", []),
  {ok, table:init_table()}.

handle_call({join, Player}, _From, Table) ->
  io:format("Join Table ~s~n", [Player#player.name]),
  Updated = table:join_table(Player, Table),
  {reply, ok, Updated};

handle_call({leave, Player}, _From, Table) ->
  io:format("Leave Table ~s~n", [Player#player.name]),
  Updated = table:leave_table(Player, Table) ,
  {reply, ok, Updated};

handle_call({update, Player}, _From, Table) ->
  io:format("Update Player ~s~n", [Player#player.name]),
  Updated = table:update_player(Player, Table),
  {reply, ok, Updated};

handle_call({find, Player}, _From, Table) ->
  io:format("Find Player ~s~n", [Player#player.name]),
  {reply, table:find_player(Player, Table), Table};

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
