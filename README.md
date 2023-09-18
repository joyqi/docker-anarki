# docker-anarki

A Docker image file for deploying Hacker News like sites, based on the latest version of [Anarki](https://github.com/arclanguage/anarki) code and [Racket](https://racket-lang.org/) language runtime.

This Dockerfile is inspired by [docker-hn](https://github.com/fauria/docker-hn), and I have made some changes to make it work with the latest version of Anarki code.

## What has been changed?

All changes can be found in `patch.diff`. There are two main changes:

1. Replace `tl-with-main-settings` function in `ac.krt` with a new one, which prevents default REPL from starting. This is because the default REPL will cause the container to exit immediately after starting. I just put a simple loop with `sleep` command in the new function, which will keep the container running.
2. Replace `email-forgotpw-link` function in `lib/app.arc` with a new one, which use system sendmail command to send emails. This is because the default function uses `smtp-send-message` to send emails, which misses some important options like TLS and STARTTLS.

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
      - ./news:/anarki/apps/news/www
      - ./static:/anarki/apps/news/static
    environment:
      - SITE_NAME=My Site
      - SITE_DESC=Hacker News
      - SITE_URL=https://news.ycombinator.com/
      - SITE_ADMIN=admin
      - SITE_COLOR=B4B4B4
      - PARENT_URL=https://www.ycombinator.com/
      - SITE_LOGO=arc.png
      - SMTP_HOST=smtp.example.com
      - SMTP_PORT=587
      - SMTP_USER=user
      - SMTP_PASS=pass
      - SMTP_FROM=no-reply@example.com
      - SMTP_TLS=true
      - SMTP_STARTTLS=true
```

## Environment variables

| Variable | Description | Default value |
| -------- | ----------- | ------------- |
| SITE_NAME | Site name | My Site |
| SITE_DESC | Site description | Hacker News |
| SITE_URL | Site URL | https://news.ycombinator.com/ |
| SITE_ADMIN | Site admin username | admin |
| SITE_COLOR | Site color | B4B4B4 |
| PARENT_URL | Parent site URL | https://www.ycombinator.com/ |
| SITE_LOGO | Site logo | arc.png |
| SMTP_HOST | SMTP host | smtp.example.com |
| SMTP_PORT | SMTP port | 587 |
| SMTP_USER | SMTP username | user |
| SMTP_PASS | SMTP password | pass |
| SMTP_FROM | SMTP from address | no-reply@example.com |
| SMTP_TLS | SMTP TLS | true |
| SMTP_STARTTLS | SMTP STARTTLS | true |

## Volumes

### /anarki/apps/news/www

The directory for storing news data.

### /anarki/apps/news/static

The directory for storing static files.