%%%-------------------------------------------------------------------
%%% @author timmytime
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. Apr 2016 16:56
%%%-------------------------------------------------------------------
-module(card).
-author("timmytime").

%% API
-export([]).

-compile(export_all).

-include("records.hrl").

create_card(Suit, Value) ->
  if Value =:= "Jack" -> #card{suit=Suit, value=Value, numericValue={10,10}};
     Value =:= "Queen" -> #card{suit=Suit, value=Value, numericValue={10,10}};
     Value =:= "King" -> #card{suit=Suit, value=Value, numericValue={10,10}};
     Value =:= "Ace" -> #card{suit=Suit, value=Value, numericValue={11,1}};
  true ->  #card{suit=Suit, value=Value, numericValue={Value,Value}}
end.

