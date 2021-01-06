

docker_name=nmrpro
port=-p 127.0.0.1:8000:8000
log_path=/var/log/nmrpro.log
WEB_TAG=1.0.1
WEB_TARGET=emetabohub/${docker_name}:${WEB_TAG}

re:clean docker

push_hub: docker hub_login do_push remove_hub_credentials

do_push:
	docker push ${WEB_TARGET}

hub_login:
	cat .password | docker login --username=$$(cat ./.username) --password-stdin

remove_hub_credentials:hub_logout
	rm ~/.docker/config.json

hub_logout:
	docker logout

docker_logout:
	docker logout

docker:
	@docker build -t $(docker_name) .
	@docker tag ${docker_name}:latest ${WEB_TARGET}

clean:
	docker kill `docker ps | grep -Poe '[a-z0-9]{12}'` || true
	docker container prune
	docker rmi $(docker_name) || true


it:
	docker run -it $(port) $(docker_name)

d:
	docker run -d $(port) $(docker_name)

sh:
	docker exec -i `docker ps | grep -Poe '^[a-z0-9]{12}'` bash

log:
	docker exec `docker ps | grep -Poe '^[a-z0-9]{12}'` tail -f $(log_path)


.PHONY:log R

