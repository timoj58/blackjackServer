%%%-------------------------------------------------------------------
%%% @author timmytime
%%% @doc
%%%
%%% @end
%%% Created : 22. Apr 2016 11:33
%%%-------------------------------------------------------------------
-module(deck_server).
-author("timmytime").

-behaviour(gen_server).

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1,
  handle_call/3,
  handle_cast/2,
  handle_info/2,
  terminate/2,
  code_change/3,
  get_card/1,
  shuffle/0]).

-define(SERVER, ?MODULE).

-record(state, {}).

%%%===================================================================
%%% API
%%%===================================================================

shuffle() ->
  gen_server:start_link(?MODULE, [],[]).

get_card(Pid) ->
   gen_server:call(Pid, {get}).


start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).


init([]) ->
  {ok,deck:shuffle(lists:seq(1,1000), deck:get_deck(lists:seq(1,4),[]))}.


handle_call({get}, _From, Cards) ->
  {reply, hd(Cards), tl(Cards)}.


handle_cast(_Request, State) ->
  {noreply, State}.


handle_info(_Info, State) ->
  {noreply, State}.


terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

