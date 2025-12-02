# Use official R Shiny base image
FROM rocker/shiny:4.3.1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

# Install R packages
RUN R -e "install.packages(c('shiny', 'httr', 'jsonlite', 'dotenv'), repos='https://cloud.r-project.org/')"

# Create app directory
RUN mkdir -p /app

# Set working directory
WORKDIR /app

# Copy app files
COPY . /app

# Expose port
EXPOSE 5000

# Set environment variable for port
ENV PORT=5000

# Run the app
CMD ["Rscript", "run.R"]