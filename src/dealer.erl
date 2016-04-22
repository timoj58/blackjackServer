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

deal(Player, Wager) -> gen_server:call(Player#player.id, {hit, Wager}).

hit(Player) -> gen_server:call(Player#player.id, {hit}).

stand(Player) -> gen_server:call(Player#player.id, {stand}).

surrender(Player) -> gen_server:call(Player#player.id, {surrender}).

split(Player) -> gen_server:call(Player#player.id, {split}).

double_down(Player, Wager) -> gen_server:call(Player#player.id, {double_down, Wager}).


start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================


init([]) ->
  %% so: we need to initialise the table, and the cards.
  %% so firstly.  start the supervisor.  This does not work properly so need to review it further.
  %% need a better handle on supervisors...start with Deck variant.  Need to start child as well.
  deck_supervisor:start_link(),
  table_supervisor:start_link(),
  deck_server:shuffle(),
  table_server:start_link(),
  {ok, #state{}}.


handle_call({join, Player}, _From,  State) ->
  {reply, table_server:join_table(Player), State};

%%handle_call({leave, Player}, _From,  State) ->
%%  {reply, ok, table_server:leave_table(Player)};

handle_call({deal, Player, Wager}, _From, State) ->
  Updated = player:set_wager(table_server:find_player(Player), Wager),
  Updated2 = player:add_card(deck_server:get_card(_From), Updated),
  Updated3 = player:add_card(deck_server:get_card(_From), Updated2),

  {reply, Updated3#player.hand, table_server:update_player(Updated3, State)};

%% do not process any rules at this point as there are multiple players (bar going bust obviously).
%%handle_call({hit}, _From, _) -> ;

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
