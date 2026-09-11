FROM node:18-alpine

WORKDIR /app

# Copy package files first to leverage Docker layer caching
COPY package*.json ./
RUN npm install --production

# Copy app code
COPY app.js ./

EXPOSE 3000

CMD ["node", "app.js"]