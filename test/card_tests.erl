%%%-------------------------------------------------------------------
%%% @author timmytime
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. Apr 2016 17:01
%%%-------------------------------------------------------------------
-module(card_tests).
-author("timmytime").

-include_lib("eunit/include/eunit.hrl").
-include("records.hrl").

card_test() ->

  King = card:create_card("Spades", "King"),
  ?assert(King#card.numericValue =:= {10,10}),

  Ace = card:create_card("Spades", "Ace"),
  ?assert(Ace#card.numericValue =:= {11,1}).

