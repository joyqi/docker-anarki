FROM racket/racket:latest

ENV SITE_NAME="My Site"
ENV SITE_URL="https://news.ycombinator.com"
ENV SITE_DESC="Hacker News"
ENV SITE_ADMIN="admin"
ENV SITE_COLOR="B4B4B4"
ENV PARENT_URL="https://www.ycombinator.com"
ENV LOGO_URL="arc.png"

WORKDIR /anarki

RUN apt update && apt install --no-install-recommends -y git rlwrap dma \
    && git clone --depth 1 https://github.com/arclanguage/anarki.git . \
    && raco pkg install --auto sha \
    && ./arc.sh tests.arc && rm -rf ./www \
    && mv ./apps/news/static ./apps/news/static-copy \
    && apt purge -y --auto-remove git

# Copy entrypoint script
COPY entrypoint.sh .

VOLUME [ "/anarki/apps/news/www", "/anarki/apps/news/static" ]

EXPOSE 8080

CMD ["./entrypoint.sh"]