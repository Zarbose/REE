source config

NBRETRY=3

_host() { cut -f 1 -d : <<< "$1"; }
_port() { cut -f 2 -d : <<< "$1"; }

_send() {
    [ $# -lt 2 ] && echo "Usage: $FUNCNAME host:port message" >&2 && return 1
    local HOST=$(_host $1)
    local PORT=$(_port $1)

    local _i

    for ((_i=0;_i<$NBRETRY;++_i)); do
	nc $HOST $PORT <<< "$2" -q 0 2> /dev/null && break
    done
}


recv() {
    [ $# -lt 1 ] && echo "Usage: $FUNCNAME host:port" >&2 && return 1
    local PORT=$(_port $1)
    nc -l -p $PORT -q 0
}

send() {
    [ $# -lt 1 ] && echo "Usage: $FUNCNAME host:port" >&2 && return 1

 	_send $1 $2
 } 
