%%%-------------------------------------------------------------------
%%% @author timmytime
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. Apr 2016 11:23
%%%-------------------------------------------------------------------
-module(dealer_tests).
-author("timmytime").

-include_lib("eunit/include/eunit.hrl").
-include("records.hrl").

dealer_test() ->
  {ok,Pid} = dealer:open_table(),
  Player = player:create_player(Pid, "Tim", 200),
  dealer:join_table(Player),
  Cards = dealer:deal(Player, 10),
  ?assert(length(Cards) =:= 2),
  ?assert(length(dealer:hit(Player)) =:= 1).


%%double_down_test() -> .

%%split_test() -> .

%%surrender_test() -> .
