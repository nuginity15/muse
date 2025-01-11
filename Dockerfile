# Base image for muse
FROM ubuntu:20.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    iproute2 \
    nodejs \
    npm \
    python3 \
    iputils-ping \
    git && \
    rm -rf /var/lib/apt/lists/*

# Install warp
RUN curl -fsSL https://pkg.cloudflareclient.com/install.sh | bash && apt-get install -y cloudflare-warp


RUN echo "net.ipv6.conf.all.disable_ipv6=0" >> /etc/sysctl.conf && \
    echo "net.ipv4.conf.all.src_valid_mark=1" >> /etc/sysctl.conf

# Create directories for warp and muse
WORKDIR /app

# Install muse
RUN git clone https://github.com/museofficial/muse.git /app/muse
WORKDIR /app/muse
RUN npm install


# Expose warp port
EXPOSE 1080

# Copy supervisord configuration
RUN apt-get install -y supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Command to start both services
CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
