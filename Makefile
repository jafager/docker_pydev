build:
	docker build -t pydev -f Dockerfile .
	docker volume rm -f pydev

run:
	docker run -it --rm --mount source=pydev,target=/home/pydev pydev

fetch:
	curl -O https://www.python.org/ftp/python/3.7.3/Python-3.7.3.tgz
