%%%-------------------------------------------------------------------
%%% @author timmytime
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. Apr 2016 11:23
%%%-------------------------------------------------------------------
-module(player_tests).
-author("timmytime").

-include_lib("eunit/include/eunit.hrl").
-include("records.hrl").

create_player_test() -> Player = player:create_player(<<10,22,33>>, "Tim", 200),
  ?assert(Player#player.name =:= "Tim"),
  ?assert(Player#player.id =:= <<10,22,33>>),
  ?assert(Player#player.balance =:= 200).

inc_balance_test() -> Player = player:create_player(<<10,22,33>>, "Tim", 200),
   Player2 = player:add_to_balance(Player, 200),
  ?assert(Player2#player.balance =:= 400).

dec_balance_test() -> Player = player:create_player(<<10,22,33>>, "Tim", 200),
  Player2 = player:take_from_balance(Player, 100),
  ?assert(Player2#player.balance =:= 100).

add_card_test() -> Player = player:create_player(<<10,22,33>>, "Tim", 200),
    Player2 = player:add_card([#card{suit="Aces", value="Queen", numericValue={10,10}}], Player),
   ?assert(length(Player2#player.hand) =:= 1),
  %% now add to split hand as well
  Player3 = player:add_card([#card{suit="Aces", value="Queen", numericValue={10,10}}, #card{suit="Aces", value="Queen", numericValue={10,10}}], Player),
  ?assert(length(Player3#player.split_hand) =:= 1),
  Player4 = player:clear_hands(Player3),
  ?assert(Player4#player.split_hand =:= []).

