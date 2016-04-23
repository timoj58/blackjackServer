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
  io:format("amout to add is ~w~n",[Amount]),
   Player#player{balance=Player#player.balance+Amount}.

take_from_balance(Player, Amount) ->
  io:format("wager is now is ~w~n",[Player#player.wager]),
  Player#player{balance=Player#player.balance-Amount}.

set_wager(Player, Wager) ->
  take_from_balance(Player#player{wager=Wager}, Wager).

increase_wager(Player, Wager) ->
  take_from_balance(Player#player{wager=Wager+Player#player.wager}, Wager).

clear_hands(Player) ->
  Player#player{hand=[], split_hand=[]}.

split_deck(Player) ->
  Player#player{hand=[hd(Player#player.hand)],split_hand=[tl(Player#player.hand)]}.


add_card(Cards, Player) ->
  if length(Cards) =:= 1 -> Player#player{hand=[hd(Cards)|Player#player.hand]};
    true -> Player#player{hand=[hd(Cards)|Player#player.hand], split_hand=[tl(Cards)|Player#player.split_hand]}
  end.


