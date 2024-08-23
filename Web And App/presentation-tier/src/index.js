import express from 'express';
import fetch from 'node-fetch';

const PORT = process.env.PORT || 80

let app = express()
const APPLICATION_LOAD_BALANCER = process.env.APPLICATION_LOAD_BALANCER;

import { exec } from 'child_process';

// GET IP
app.get('/', async (req, res) => {
  exec('wget -qO- ifconfig.me', (error, stdout) => {
    res.send(`Hello from ${stdout.trim()}`);
  });
})

app.get('/init', async (req, res) => {
  fetch(`http://${APPLICATION_LOAD_BALANCER}/init`).then(async (response) => {
    const data = await response.json();
    res.send(data)
  })	
})

app.get('/users', async (req, res) => {
  fetch(`http://${APPLICATION_LOAD_BALANCER}/users`).then(async (response) => {
    const data = await response.json();
    res.send(data)
  })
})

// Custom 404 route not found handler
app.use((req, res) => {
  res.status(404).send('404 not found')
})

app.listen(PORT, () => {
  console.log(`Listening on PORT ${PORT}`);
})
