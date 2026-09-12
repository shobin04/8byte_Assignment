FROM node:22-alpine

# Set container working directory
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install --production

# Copy all application files (app.js, index.html, etc.)
COPY . .

# Expose container port
EXPOSE 3000

# Start the application
CMD ["npm", "start"]