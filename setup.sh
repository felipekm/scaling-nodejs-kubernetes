#!/bin/bash

set -e  # Exit on error

echo "🚀 Setting up the environment for Scaling Node.js with Kubernetes..."

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# 1️⃣ Install Docker
if command_exists docker; then
    echo "✅ Docker is already installed."
else
    echo "📦 Installing Docker..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install --cask docker
        open /Applications/Docker.app
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo apt update
        sudo apt install -y docker.io
        sudo systemctl start docker
        sudo systemctl enable docker
    fi
    echo "✅ Docker installed successfully!"
fi

# 2️⃣ Install Kubernetes CLI (kubectl)
if command_exists kubectl; then
    echo "✅ kubectl is already installed."
else
    echo "📦 Installing kubectl..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install kubectl
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo apt update
        sudo apt install -y kubectl
    fi
    echo "✅ kubectl installed successfully!"
fi

# 3️⃣ Install Minikube
if command_exists minikube; then
    echo "✅ Minikube is already installed."
else
    echo "📦 Installing Minikube..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install minikube
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
        sudo install minikube-linux-amd64 /usr/local/bin/minikube
    fi
    echo "✅ Minikube installed successfully!"
fi

# 4️⃣ Install Node.js & NPM
if command_exists node; then
    echo "✅ Node.js is already installed."
else
    echo "📦 Installing Node.js..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install node
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo apt update
        sudo apt install -y nodejs npm
    fi
    echo "✅ Node.js installed successfully!"
fi

# 5️⃣ Install PostgreSQL
if command_exists psql; then
    echo "✅ PostgreSQL is already installed."
else
    echo "📦 Installing PostgreSQL..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install postgresql
        brew services start postgresql
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo apt update
        sudo apt install -y postgresql postgresql-contrib
        sudo systemctl start postgresql
    fi
    echo "✅ PostgreSQL installed successfully!"
fi

# 6️⃣ Install Redis
if command_exists redis-cli; then
    echo "✅ Redis is already installed."
else
    echo "📦 Installing Redis..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install redis
        brew services start redis
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo apt update
        sudo apt install -y redis-server
        sudo systemctl start redis
    fi
    echo "✅ Redis installed successfully!"
fi

# 7️⃣ Install Project Dependencies
echo "📦 Installing project dependencies..."
npm install

# 8️⃣ Setup Environment Variables
echo "📦 Setting up environment variables..."
cat > .env <<EOL
DB_HOST=127.0.0.1
DB_USER=postgres
DB_PASS=password
DB_NAME=node_scaling
DB_PORT=5432
REDIS_HOST=127.0.0.1
REDIS_PORT=6379
EOL
echo "✅ .env file created."

# 9️⃣ Run Database Migrations (if necessary)
echo "📦 Creating PostgreSQL database..."
psql -U postgres -c "CREATE DATABASE node_scaling;" || echo "Database already exists."

# 1️⃣0️⃣ Start the API
echo "🚀 Starting the Fastify API..."
npm start &

echo "✅ Setup complete! Your API is running. You can now access it at http://localhost:3000"
