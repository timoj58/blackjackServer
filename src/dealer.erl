%%%-------------------------------------------------------------------
%%% @author timmytime
%%%
%%% Dealer will hold the dealer rules of play...ie decide if its bust, win, and handle game hands by dealer and players, players can validate there own hands
%%% but we need to know if they are sending us crap and tell them so.
%%%
%%% Created : 23. Apr 2016 16:20
%%%-------------------------------------------------------------------
-module(dealer).
-author("timmytime").

-include("records.hrl").

%% API
-export([]).
-compile(export_all).

%% get the values of the hand.
get_hand_values([], Acc) ->
  lists:reverse(Acc);
get_hand_values([Card|Hand], Acc) ->
  {Value,AltValue} = Card#card.numericValue,
  if Value /= AltValue ->
     io:format("its an Ace~n", []),
    %% if our acc is empty, then need to add a value to it.
    HandValues = lists:append(add_hand_value(Acc, Value, []),add_hand_value(Acc, AltValue, []));
    true ->
      io:format("its not an Ace~n", []),
      HandValues = add_hand_value(Acc, Value, [])
  end,
  get_hand_values(Hand, HandValues).


add_hand_value([],_, Acc) -> lists:reverse(Acc);
add_hand_value([Hand|Alt], Value, Acc) ->
  add_hand_value(Alt, Value, lists:append(Acc, [Hand + Value])).


validate_hand_values([], Valid) -> Valid;
validate_hand_values([Hand|Rest], _) ->
  if Hand > 21 -> validate_hand_values(Rest, "False");
    true -> "True"
  end.



