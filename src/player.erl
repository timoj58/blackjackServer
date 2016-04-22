%%%-------------------------------------------------------------------
%%% @author timmytime
%%% @doc
%%%
%%% @end
%%% Created : 22. Apr 2016 14:00
%%%-------------------------------------------------------------------
-module(player).
-author("timmytime").

%% API
-export([]).
-compile(export_all).

-include("records.hrl").

create_player(Id, Name, Balance) -> #player{id=Id, name=Name, balance=Balance}.

%% some helper functions.  ie increase / decrease balance
add_to_balance(Player, Amount) ->
   Player#player{balance=Player#player.balance+Amount}.

take_from_balance(Player, Amount) ->
  Player#player{balance=Player#player.balance-Amount}.


