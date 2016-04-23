%%%-------------------------------------------------------------------
%%% @author timmytime
%%% @doc
%%%
%%% @end
%%% Created : 22. Apr 2016 11:22
%%%-------------------------------------------------------------------
-author("timmytime").

-record(card, {suit, value, numericValue, faceDown=true}).

-record(player, {name, id, balance, hand=[], split_hand=[], wager=0}).
