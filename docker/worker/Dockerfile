FROM php:8.2-cli

# Install supervisor + system deps
RUN apt-get update && apt-get install -y supervisor unzip git curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www

# Copy supervisor config
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
