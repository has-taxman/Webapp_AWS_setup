// index.js
const http = require('http');
const express = require('express');
const app = express();
const port = 80;

// Change 'localhost' to '0.0.0.0' to make it accessible externally
app.listen(port, '0.0.0.0', () => {
  console.log(`🚀 Server running at http://0.0.0.0:${port}`);
});

app.get('/', (req, res) => {
  res.send('Hello from Node.js on AWS!');
});
