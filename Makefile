PHP_VERSION := "7.0"
NAME := "pldin601/php-with-nginx:$(PHP_VERSION)"

build:
	docker build --build-arg PHP_VERSION=$(PHP_VERSION) -t $(NAME) .

run:
	docker run -it --rm -p 5050:80 $(NAME)

push:
	docker push $(NAME)

attach:
	docker run -it --rm $(NAME) bash
