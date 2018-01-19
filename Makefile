run:
	docker-compose up

build:
	docker-compose build

clean:
	-rm -rf webapp/node_modules

node-cmd:
	docker-compose run node bash
