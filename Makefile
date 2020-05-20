all: test check

test:
	./test.sh

check:
	shellcheck echo.sh spec/*.sh

debian: debian-2.2 debian-3.0 debian-3.1 debian-4.0 debian-5.0 debian-6.0 \
				debian-7 debian-8 debian-9 debian-10

debian-2.2:
	docker run -it $$(docker build -q -f dockerfiles/$@ .)

debian-3.0:
	docker run -it $$(docker build -q -f dockerfiles/$@ .)

debian-3.1:
	docker run -it $$(docker build -q -f dockerfiles/$@ .)

debian-4.0:
	docker run -it $$(docker build -q -f dockerfiles/$@ .)

debian-5.0:
	docker run -it $$(docker build -q -f dockerfiles/$@ .)

debian-6.0:
	docker run -it $$(docker build -q -f dockerfiles/$@ .)

debian-7:
	docker run -it $$(docker build -q -f dockerfiles/$@ .)

debian-8:
	docker run -it $$(docker build -q -f dockerfiles/$@ .)

debian-9:
	docker run -it $$(docker build -q -f dockerfiles/$@ .)

debian-10:
	docker run -it $$(docker build -q -f dockerfiles/$@ .)

schily:
	docker run -it $$(docker build --build-arg=TAG=2018-10-30 -q -f dockerfiles/$@ .)
