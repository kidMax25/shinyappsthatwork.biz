FROM rocker/shiny:4.3.1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install R packages (dotenv is optional, will only be used if .env exists)
RUN R -e "install.packages(c('shiny', 'httr', 'jsonlite'), repos='https://cloud.r-project.org/')"

# Create app directory
WORKDIR /app

# Copy app files (excluding .env via .dockerignore)
COPY . /app

# Create data directory for newsletter subscribers
RUN mkdir -p /app/data

# Expose port (will be overridden by Render)
EXPOSE 10000

# Set default port
ENV PORT=10000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s \
  CMD curl -f http://localhost:${PORT}/ || exit 1

# Run the app
CMD ["Rscript", "run.R"]