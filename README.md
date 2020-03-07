# docker-ttrss
[Docker] This Dockerfile installs Tiny Tiny RSS (TT-RSS) tt-rss.org


```
docker build -t ugeek/tt-rss:rpi .
```


```
docker create --name tt-rss  -p 81:80 -v $HOME/docker/tt-rss:/usr/html ugeek/tt-rss:rpi
```
