%%%-------------------------------------------------------------------
%%% @author timmytime

%%% Created : 22. Apr 2016 14:17
%%%-------------------------------------------------------------------
-module(table).
-author("timmytime").

%% API
-export([]).
-compile(export_all).

-include("records.hrl").

%% our table will consist of players...maximum of 4 per table.
init_table() -> maps:new().

join_table(Player, Table) -> maps:put(Player#player.id, Player, Table).

leave_table(Player, Table) -> maps:remove(Player#player.id, Table).

update_player(UpdatedPlayer, Table) ->
   maps:update(UpdatedPlayer#player.id, UpdatedPlayer, Table).

find_player(Player, Table) ->
  maps:get(Player#player.id, Table).
