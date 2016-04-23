%%%-------------------------------------------------------------------
%%% @author timmytime
%%% Created : 22. Apr 2016 11:23
%%%-------------------------------------------------------------------
-module(dealer_tests).
-author("timmytime").

-include_lib("eunit/include/eunit.hrl").
-include("records.hrl").

dealer_server_test() ->
  {ok,Pid} = dealer_server:open_table(),
  Player = player:create_player(Pid, "Tim", 200),
  dealer_server:join_table(Player),
  Player2 = dealer_server:deal(Player, 10),
  ?assert(length(Player2#player.hand) =:= 2),
  Player3 = dealer_server:hit(Player2),
  ?assert(length(Player3#player.hand) =:= 3),
  Player4 = dealer_server:double_down(Player3, 20),
  ?assert(length(Player4#player.hand) =:= 4),
  ?assert(Player4#player.balance =:= 170),
  Player5 = dealer_server:surrender(Player4),
  ?assert(round(Player5#player.balance) =:= 185),


  Player6 = Player#player{hand=[#card{suit="Spades", value="Queen", numericValue={10,10}}, #card{suit="Spades", value="Queen", numericValue={10,10}}]},
  Player7 = dealer_server:split(Player6),
  ?assert(length(Player7#player.hand) == 1),
  ?assert(length(Player7#player.split_hand) == 1).

dealer_hand_test() ->
  %% we need a hand....so
  Card = card:create_card("Spades", "Queen"),
  Card2 = card:create_card("Spades", "Queen"),

  HandValue = dealer:get_hand_values([Card,Card2], [0]),
  ?assert(hd(HandValue) =:= 20),

  Card3 = card:create_card("Spades", "Ace"),
  Card4 = card:create_card("Spades", "Queen"),

  HandValue2 = dealer:get_hand_values([Card3,Card4], [0]),
  ?assert((hd(HandValue2) =:= 21)),
  ?assert((lists:nth(2,HandValue2) =:= 11)).


dealer_validate_bad_hand_test() ->

  Card = card:create_card("Spades", "Queen"),
  Card2 = card:create_card("Spades", "Queen"),
  Card3 = card:create_card("Spades", "Queen"),

  HandValue = dealer:get_hand_values([Card,Card2, Card3], [0]),

  Res = dealer:validate_hand_values(HandValue, "False"),

  ?assert(Res =:= "False").

dealer_validate_good_hand_test() ->

  Card = card:create_card("Spades", "Queen"),
  Card2 = card:create_card("Spades", 5),
  Card3 = card:create_card("Spades", 3),

  HandValue = dealer:get_hand_values([Card,Card2, Card3], [0]),

  Res = dealer:validate_hand_values(HandValue, "False"),

  ?assert(Res =:= "True").

dealer_validate_ace_hand_test() ->

  Card = card:create_card("Spades", "Queen"),
  Card2 = card:create_card("Spades", "Ace"),
  Card3 = card:create_card("Spades", 3),

  HandValue = dealer:get_hand_values([Card,Card2, Card3], [0]),

  Res = dealer:validate_hand_values(HandValue, "False"),

  ?assert(Res =:= "True").

dealer_validate_ace_fail_hand_test() ->

  Card = card:create_card("Spades", "Queen"),
  Card2 = card:create_card("Spades", "Ace"),
  Card3 = card:create_card("Spades", "King"),
  Card4 = card:create_card("Spades", 2),


  HandValue = dealer:get_hand_values([Card,Card2, Card3, Card4], [0]),

  Res = dealer:validate_hand_values(HandValue, "False"),

  ?assert(Res =:= "False").









