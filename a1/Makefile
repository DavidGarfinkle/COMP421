#CURDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CURDIR="/Users/davidgarfinkle/davidgarfinkle/comp421/a1"

initdb:
	docker run --mount type=bind,source=${CURDIR}/db,target=/docker-entrypoint-initdb.d/ postgres:latest
