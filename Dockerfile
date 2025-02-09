# Use an official Node.js runtime as a parent image
FROM node:18-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json to leverage Docker caching
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the entire project into the container
COPY . .

# Expose the application port
EXPOSE 3000

# Define environment variables (useful for Kubernetes)
ENV NODE_ENV=production

# Start the application
CMD ["npm", "start"]
