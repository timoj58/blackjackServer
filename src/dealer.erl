%%%-------------------------------------------------------------------
%%% @author timmytime

%%% Created : 22. Apr 2016 15:45
%%%-------------------------------------------------------------------
-module(dealer).
-author("timmytime").

-behaviour(gen_server).

-include("records.hrl").

%% API
-export([start_link/0, open_table/0]).

%% gen_server callbacks
-export([init/1,
  handle_call/3,
  handle_cast/2,
  handle_info/2,
  terminate/2,
  code_change/3,
  join_table/1,
  leave_table/1,
  hit/1,
  stand/1,
  surrender/1,
  double_down/2,
  deal/2,
  split/1]).

-define(SERVER, ?MODULE).

-record(state, {}).

%%%===================================================================
%%% API
%%%===================================================================

open_table() ->
  gen_server:start_link(?MODULE, [],[]).

join_table(Player) -> gen_server:call(Player#player.id, {join, Player}).

leave_table(Player) -> gen_server:call(Player#player.id, {leave, Player}).

deal(Player, Wager) -> gen_server:call(Player#player.id, {deal, Player,  Wager}).

hit(Player) -> gen_server:call(Player#player.id, {hit, Player}).

stand(Player) -> gen_server:call(Player#player.id, {stand, Player}).

surrender(Player) -> gen_server:call(Player#player.id, {surrender, Player}).

split(Player) -> gen_server:call(Player#player.id, {split, Player}).

double_down(Player, Wager) -> gen_server:call(Player#player.id, {double_down, Wager}).


start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================


init([]) ->
  io:format("Started Dealer~n", []),
  {ok, DeckPid} =  deck_server:shuffle(),
  {ok, TablePid} = table_server:start_link(),
  {ok, {DeckPid, TablePid}}.


handle_call({join, Player}, _From,  {DeckPid, TablePid}) ->
  io:format("Join Table~s~n", [Player#player.name]),
  table_server:join_table(Player, TablePid),
  {reply,ok,  {DeckPid, TablePid}};

handle_call({leave, Player}, _From,  {DeckPid, TablePid}) ->
  table_server:leave_table(Player, TablePid),
  {reply, ok, {DeckPid, TablePid}};

handle_call({deal, Player, Wager}, _From, {DeckPid, TablePid}) ->
  Updated = player:set_wager(table_server:find_player(Player, TablePid), Wager),
  Updated2 = player:add_card([deck_server:get_card(DeckPid)], Updated),
  Updated3 = player:add_card([deck_server:get_card(DeckPid)], Updated2),
  table_server:update_player(Updated3, TablePid),

  {reply, Updated3#player.hand, {DeckPid, TablePid}};


handle_call({hit, Player}, _From,  {DeckPid, TablePid}) ->
  io:format("Hit~n", []),
  Card = deck_server:get_card(DeckPid),

  if(Player#player.split_hand == []) ->
    io:format("Normal Hand~n", []),
    UpdatedPlayer = player:add_card([Card], Player),
    table_server:update_player(UpdatedPlayer, TablePid),
    {reply, UpdatedPlayer#player.hand, {DeckPid, TablePid}};
   true ->
     io:format("Split Hand~n", []),
       Card2 = deck_server:get_card(DeckPid),
       UpdatedPlayer = player:add_card([Card,Card2], Player),
       table_server:update_player(UpdatedPlayer, TablePid),
     {reply,{UpdatedPlayer#player.hand,UpdatedPlayer#player.split_hand, {DeckPid, TablePid}}}
end;

%%handle_call({stand}, _From, State) -> {reply, ok, State};

%%handle_call({surrender}, _From, _) -> ;

%%handle_call({split}, _From, _) -> ;

%%handle_call({double_down, Wager}, _From, _) -> ;

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
