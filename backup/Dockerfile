FROM postgres:15-alpine
RUN apk add --no-cache dcron
COPY backup.sh /usr/local/bin/backup.sh
RUN chmod +x /usr/local/bin/backup.sh
# Run daily at 02:00 UTC
RUN echo "0 2 * * * /usr/local/bin/backup.sh >> /var/log/backup.log 2>&1" \
    | crontab -
CMD ["crond", "-f", "-d", "8"]
