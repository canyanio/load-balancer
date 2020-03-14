.PHONY: dockerfile
dockerfile:
	docker build -t canyan/load-balancer:latest -f .
