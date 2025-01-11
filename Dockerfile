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

# Set up warp environment
ENV WARP_SLEEP=2
ENV WARP_LICENSE_KEY=S219k3pz-r1Uj6K79-1zkO062H
RUN echo "net.ipv6.conf.all.disable_ipv6=0" >> /etc/sysctl.conf && \
    echo "net.ipv4.conf.all.src_valid_mark=1" >> /etc/sysctl.conf

# Create directories for warp and muse
WORKDIR /app

# Install muse
RUN git clone https://github.com/museofficial/muse.git /app/muse
WORKDIR /app/muse
RUN npm install

# Environment variables for muse
ENV DISCORD_TOKEN=OTMwODczNzcxNjYzOTgyNjEy.GNZSra.FTYJWzl2I9vQDVD4OUuMwYPX_B-SY0KWddqeSE
ENV YOUTUBE_API_KEY=AIzaSyC3hur5C3PRknA3rKaXIErdFasebVb7Y7E
ENV ENABLE_SPONSORBLOCK=true
ENV BOT_STATUS=online
ENV BOT_ACTIVITY_TYPE=WATCHING
ENV BOT_ACTIVITY=/play untuk memutar lagu

# Expose warp port
EXPOSE 1080

# Copy supervisord configuration
RUN apt-get install -y supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Command to start both services
CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
