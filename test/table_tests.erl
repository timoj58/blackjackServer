%%%-------------------------------------------------------------------
%%% @author timmytime

%%% Created : 22. Apr 2016 11:23
%%%-------------------------------------------------------------------
-module(table_tests).
-author("timmytime").

-include_lib("eunit/include/eunit.hrl").
-include("records.hrl").


table_test() ->
  Table = table:init_table(),
  ?assert(length(table:init_table()) =:= 0),
  ?assert(length(table:join_table( player:create_player(<<10,22,33>>, "Tim", 200), Table)) =:= 1),
  ?assert(length(table:leave_table( player:create_player(<<10,22,33>>, "Tim", 200), Table)) =:= 0).

multi_people_table_test() ->
  Table = table:init_table(),
  Table2 = table:join_table( player:create_player(<<10,22,33>>, "Tim", 200), Table),
  Table3 = table:join_table( player:create_player(<<11,21,31>>, "James", 200), Table2),
  ?assert(length(Table3) =:= 2),
  Table4 = table:leave_table( player:create_player(<<10,22,33>>, "Tim", 200), Table3),
  ?assert(length(Table4) =:= 1),
  Player = hd(Table4),
  ?assert(Player#player.name =:= "James").





