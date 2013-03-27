ERLANG := erl -pa ebin -pa deps/*/ebin -smp enable -s lager -setcookie ejis_cookie ${ERL_ARGS}

all: clean
	rebar get-deps && rebar --verbose compile

erl:
	rebar skip_deps=true --verbose compile

clean:
	rebar clean

build_plt: erl
	dialyzer --verbose --build_plt --apps kernel stdlib sasl erts ssl tools os_mon runtime_tools \
				    compiler --output_plt .ejis.plt -pa deps/*/ebin ebin

analyze: erl
	dialyzer --verbose -pa deps/*/ebin --plt .ejis.plt -Werror_handling ebin

xref: all
	rebar skip_deps=true xref

shell: erl
	if [ -n "${NODE}" ]; then ${ERLANG} -name ${NODE}@`hostname` -boot start_sasl; \
	else ${ERLANG} -name ejis@`hostname` -boot start_sasl; \
	fi

run: erl
	if [ -n "${NODE}" ]; then ${ERLANG} -name ${NODE}@`hostname` -boot start_sasl -s ejis; \
	else ${ERLANG} -name ejis@`hostname` -boot start_sasl -s ejis; \
	fi

doc: erl
	rebar skip_deps=true doc