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
  Player2 = dealer:deal(Player, 10),
  ?assert(length(Player2#player.hand) =:= 2),
  Player3 = dealer:hit(Player2),
  ?assert(length(Player3#player.hand) =:= 3),
  Player4 = dealer:double_down(Player3, 20),
  ?assert(length(Player4#player.hand) =:= 4),
  ?assert(Player4#player.balance =:= 170),
  Player5 = dealer:surrender(Player4),
  ?assert(round(Player5#player.balance) =:= 185).





%%double_down_test() -> .

%%split_test() -> .

%%surrender_test() -> .
