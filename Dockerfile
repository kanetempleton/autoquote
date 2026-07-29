FROM ruby:3.2-slim

# Install system deps needed by native gems + Playwright browsers later if needed
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    libyaml-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install gems first (better layer caching)
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy the rest of the app
COPY . .

# Expose the port the app listens on
EXPOSE 43595

# Default command: start the Sinatra app
CMD ["ruby", "app/app.rb"]