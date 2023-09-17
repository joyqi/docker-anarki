FROM debian:stable-slim

ENV SITE_NAME="My Site"
ENV SITE_URL="https://news.ycombinator.com"
ENV SITE_DESC="Hacker News"
ENV SITE_ADMIN="admin"
ENV SITE_COLOR="B4B4B4"
ENV PARENT_URL="https://www.ycombinator.com"
ENV SITE_LOGO="arc.png"
ENV SMTP_HOST="smtp.example.com"
ENV SMTP_PORT="587"
ENV SMTP_USER="user"
ENV SMTP_PASS="pass"
ENV SMTP_FROM="no-reply@example.com"
ENV SMTP_TLS="true"
ENV SMTP_STARTTLS="true"

WORKDIR /anarki

RUN apt update && apt install --no-install-recommends -y racket git ca-certificates sqlite3 dma \
    && git clone --depth 1 https://github.com/arclanguage/anarki.git . \
    && raco pkg install --auto sha \
    && ./arc.sh -n tests.arc && rm -rf ./www \
    && mv ./apps/news/static ./apps/news/static-copy

# Copy entrypoint script
COPY entrypoint.sh .
COPY patch.diff .

VOLUME [ "/anarki/apps/news/www", "/anarki/apps/news/static", "/etc/dma" ]

EXPOSE 8080

CMD ["./entrypoint.sh"]
