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
init_table() -> [].

join_table(Player, Table) -> [Player|Table].

leave_table(Player, Table) -> lists:delete(Player, Table).
