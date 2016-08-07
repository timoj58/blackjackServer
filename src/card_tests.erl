%%%-------------------------------------------------------------------
%%% @author timmytime
%%% Created : 23. Apr 2016 17:01
%%%-------------------------------------------------------------------
-module(card_tests).
-author("timmytime").

-include_lib("eunit/include/eunit.hrl").
-include("records.hrl").

card_test() ->

  Jack = card:create_card("Spades", "Jack"),
  ?assert(Jack#card.numericValue =:= {10,10}),

  Queen = card:create_card("Spades", "Queen"),
  ?assert(Queen#card.numericValue =:= {10,10}),

  King = card:create_card("Spades", "King"),
  ?assert(King#card.numericValue =:= {10,10}),

  Ace = card:create_card("Spades", "Ace"),
  ?assert(Ace#card.numericValue =:= {11,1}),

  Numeric = card:create_card("Spades", 5),
  ?assert(Numeric#card.numericValue =:= {5,5}).

