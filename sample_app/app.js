const express = require('express');
const { Pool } = require('pg');
const client = require('prom-client');
const path = require('path');

const app = express();
const port = process.env.PORT || 3000;

// Enable default system metrics collection (CPU, Memory, Event Loop)
client.collectDefaultMetrics();

// Custom Prometheus metric to count HTTP requests
const httpRequestCounter = new client.Counter({
  name: 'http_requests_total',
  help: 'Total number of HTTP requests received',
  labelNames: ['method', 'route', 'status']
});

// Configure RDS PostgreSQL connection pool with SSL enabled
const dbPool = new Pool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  port: process.env.DB_PORT || 5432,
  connectionTimeoutMillis: 3000,
  ssl: {
    rejectUnauthorized: false
  }
});

// Structured JSON request logging middleware
app.use((req, res, next) => {
  res.on('finish', () => {
    httpRequestCounter.inc({
      method: req.method,
      route: req.path,
      status: res.statusCode
    });
    console.log(JSON.stringify({
      timestamp: new Date().toISOString(),
      method: req.method,
      path: req.path,
      status: res.statusCode,
      client_ip: req.ip
    }));
  });
  next();
});

// Serve static assets if any exist
app.use(express.static(__dirname));

// Root Route - Serves the HTML Control Panel Interface
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'index.html'));
});

// Health Check Route
app.get('/health', async (req, res) => {
  try {
    const dbResult = await dbPool.query('SELECT NOW()');
    res.status(200).json({
      status: 'healthy',
      database: 'connected',
      timestamp: dbResult.rows[0].now,
      uptime_seconds: process.uptime()
    });
  } catch (err) {
    console.error(JSON.stringify({ event: 'db_connection_error', error: err.message }));
    res.status(500).json({
      status: 'unhealthy',
      database: 'disconnected',
      error: err.message
    });
  }
});

// Metrics Endpoint for Prometheus / Grafana
app.get('/metrics', async (req, res) => {
  res.setHeader('Content-Type', client.register.contentType);
  res.send(await client.register.metrics());
});

app.listen(port, () => {
  console.log(JSON.stringify({
    event: 'server_started',
    port: port,
    environment: process.env.NODE_ENV || 'production'
  }));
});