%%%-------------------------------------------------------------------
%%% @author timmytime
%%% @doc
%%% 4 sets of cards, shuffled randomly
%%% @end
%%% Created : 22. Apr 2016 11:14
%%%-------------------------------------------------------------------
-module(deck).
-author("timmytime").

%% API
-export([]).
-compile(export_all).

-include("records.hrl").

get_deck([], Acc) -> lists:reverse(Acc);
get_deck([Deck|Tail], Acc) ->
  get_deck(Tail, lists:append(Acc, create_deck(["Spades", "Hearts", "Diamonds", "Clubs"],[]))).

create_deck([], Acc) -> lists:reverse(Acc);
create_deck([Suit|Tail], Acc) ->
  create_deck(Tail, create_suit(lists:seq(2,10),Suit, Acc)).

create_suit([],Suit, Acc) ->
%% add in our face cards and ace.
  lists:reverse([#card{suit=Suit, value="Jack", numericValue={10,10}},
    #card{suit=Suit, value="Queen", numericValue={10,10}},
    #card{suit=Suit, value="King", numericValue={10,10}},
    #card{suit=Suit, value="Ace", numericValue={11,1}}|Acc]);
create_suit([Value|Rest], Suit, Acc) ->
  create_suit(Rest, Suit, [#card{suit=Suit, value=Value, numericValue={Value,Value}}|Acc]).

shuffle([],Deck) -> lists:reverse(Deck);
shuffle([Shuffle|Tail], Deck) ->
  random:seed(erlang:monotonic_time()),
%% need to randomly shuffle cards..we dont want to split at 52 clearly. hence take 1 off.
  {First, Second} = lists:split(random:uniform(length(Deck)-1), Deck),
  {Third, Fourth} = lists:split(random:uniform(length(First)), First),
  {Fifth, Sixth} = lists:split(random:uniform(length(Second)), Second),

  shuffle(Tail, lists:append(lists:append(Sixth, Third),lists:append(Fifth, Fourth))).