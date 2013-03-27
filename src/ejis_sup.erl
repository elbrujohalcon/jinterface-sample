%%%-------------------------------------------------------------------
%%% @author Fernando Benavides <elbrujohalcon@inaka.net>
%%% @doc JInterface Sample Application Main Supervisor
%%% @end
%%%-------------------------------------------------------------------
-module(ejis_sup).
-author('elbrujohalcon@inaka.net').

-behaviour(supervisor).

-export([start_link/0, init/1]).

%%-------------------------------------------------------------------
%% PUBLIC API
%%-------------------------------------------------------------------
%% @doc  Starts a new supervisor
-spec start_link() -> {ok, pid()}.
start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%%-------------------------------------------------------------------
%% SUPERVISOR API
%%-------------------------------------------------------------------
%% @hidden
%%NOTE: If the process dies... it can't be restarted, because all information
%%		stored in the java process may or may not be lost.
-spec init([]) -> {ok, {{one_for_one, 0, 1}, [supervisor:child_spec()]}}.
init([]) ->
  {ok,
    {_SupFlags = {one_for_one, 0, 1},
      [
        {ejis_java, {ejis_java, start_link, []}, permanent, 2000, worker, [ejis_java]}
      ]}}.