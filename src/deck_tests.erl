%%%-------------------------------------------------------------------
%%% @author timmytime

%%% Created : 22. Apr 2016 11:23
%%%-------------------------------------------------------------------
-module(deck_tests).
-author("timmytime").

-include_lib("eunit/include/eunit.hrl").


create_deck_test() ->
  Deck = deck:get_deck(lists:seq(1,4),[]),
  ?assert(length(Deck) =:= 208).

shuffle_deck_test() ->
  Deck = deck:shuffle(lists:seq(1,1000),deck:get_deck(lists:seq(1,4),[])),
  ?assert(length(Deck) =:= 208).







