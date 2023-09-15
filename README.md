# docker-anarki

A Docker image file for deploying Hacker News like sites, based on the latest version of [Anarki](https://github.com/arclanguage/anarki) code and [Racket](https://racket-lang.org/) language runtime.

This Dockerfile is inspired by [docker-hn](https://github.com/fauria/docker-hn), and I have made some changes to make it work with the latest version of Anarki code.

## Usage

### Docker run

```bash
docker run -d -p 8080:8080 --name hn joyqi/anarki:latest
```

### docker-compose

```yaml
services:
  anarki:
    image: joyqi/anarki:latest
    ports:
      - 8080:8080
    volumes:
      - anarki:/anarki/apps/news/www
      - ./static:/anarki/apps/news/static
    environment:
      - "SITE_NAME=Nerd News"
      - "SITE_DESC=News for Nerds"
      - SITE_URL=https://news.joyqi.com
      - SITE_ADMIN=joyqi
      - SITE_COLOR=BBBBBB
      - PARENT_URL=https://joyqi.com
      - SITE_LOGO=https://joyqi.com/static/logo.png

volumes:
  anarki:
```