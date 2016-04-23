%%%-------------------------------------------------------------------
%%% @author timmytime

%%% Created : 22. Apr 2016 15:45
%%%-------------------------------------------------------------------
-module(dealer_server).
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


%%%===================================================================
%%% API
%%%===================================================================

open_table() ->
  gen_server:start_link(?MODULE, [],[]).

join_table(Player) -> gen_server:call(Player#player.id, {join, Player}).

leave_table(Player) -> gen_server:call(Player#player.id, {leave, Player}).

deal(Player, Wager) -> gen_server:call(Player#player.id, {deal, Player,  Wager}).

hit(Player) -> gen_server:call(Player#player.id, {hit, Player}).

stand(Player) -> gen_server:call(Player#player.id, {stand}).

surrender(Player) -> gen_server:call(Player#player.id, {surrender, Player}).

split(Player) -> gen_server:call(Player#player.id, {split, Player}).

double_down(Player, Wager) -> gen_server:call(Player#player.id, {double_down, Player,  Wager}).


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
  io:format("player wager is ~w~n", [Updated#player.wager]),
  Updated2 = player:add_card([deck_server:get_card(DeckPid)], Updated),
  Updated3 = player:add_card([deck_server:get_card(DeckPid)], Updated2),
  table_server:update_player(Updated3, TablePid),

  {reply, Updated3, {DeckPid, TablePid}};


handle_call({hit, Player}, _From,  {DeckPid, TablePid}) ->
  io:format("Hit~n", []),
  Card = deck_server:get_card(DeckPid),

  if(Player#player.split_hand == []) ->
    io:format("Normal Hand ~w~n", [length(Player#player.hand)]),
    UpdatedPlayer = player:add_card([Card], Player),
    table_server:update_player(UpdatedPlayer, TablePid),
    {reply, UpdatedPlayer, {DeckPid, TablePid}};
   true ->
     io:format("Split Hand ~n", []),
       Card2 = deck_server:get_card(DeckPid),
       UpdatedPlayer = player:add_card([Card,Card2], Player),
       table_server:update_player(UpdatedPlayer, TablePid),
     {reply,UpdatedPlayer, {DeckPid, TablePid}}
end;

handle_call({stand}, _From, State) -> {reply, ok, State};

handle_call({surrender, Player}, _From, {DeckPid, TablePid}) ->
 %%return half the bet.
  UpdatedPlayer = player:add_to_balance(Player, Player#player.wager/2),
  io:format("player balance is now ~w~n", [UpdatedPlayer#player.balance]),
  table_server:update_player(Player, TablePid),
  {reply, UpdatedPlayer, {DeckPid, TablePid}};

handle_call({split, Player}, _From, {DeckPid, TablePid}) ->
 [Card1, Card2 | _] = Player#player.hand,
  if Card1#card.value == Card2#card.value ->
    %% simply split the deck...by doing following.
    UpdatedPlayer = player:split_deck(Player),
    table_server:update_player(UpdatedPlayer, TablePid),
    {reply, UpdatedPlayer, {DeckPid, TablePid}};
    true -> {reply, io:format("You can not split deck~n", []), {DeckPid, TablePid}}
end;

handle_call({double_down, Player, Wager}, _From, {DeckPid, TablePid}) ->
  UpdatedPlayer = player:increase_wager(Player, Wager),
  UpdatedPlayer2 = player:add_card([deck_server:get_card(DeckPid)], UpdatedPlayer),
  table_server:update_player(Player, TablePid),
  {reply, UpdatedPlayer2, {DeckPid, TablePid}};

handle_call(_Request, _From, State) ->
  {reply, ok, State}.

handle_cast(_Request, State) ->
  {noreply, State}.


handle_info(_Info, State) ->
  {noreply, State}.


terminate(_Reason, {DeckPid,TablePid}) ->
  table_server:cast(DeckPid, terminate),
  deck_server:cast(TablePid, terminate),
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
