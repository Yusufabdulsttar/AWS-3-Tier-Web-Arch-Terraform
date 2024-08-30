import express from 'express';
import mysql from 'mysql';

// Set up environment variables
const PORT = process.env.PORT || 80;
const {
  RDS_HOSTNAME,
  RDS_USERNAME,
  RDS_PASSWORD,
  RDS_PORT,
  RDS_DB_NAME
} = process.env;

// Validate environment variables
if (!RDS_HOSTNAME || !RDS_USERNAME || !RDS_PASSWORD || !RDS_PORT || !RDS_DB_NAME) {
  throw new Error('One or more required environment variables are missing.');
}

// Create a MySQL connection
const connection = mysql.createConnection({
  host: RDS_HOSTNAME,
  user: RDS_USERNAME,
  password: RDS_PASSWORD,
  port: RDS_PORT,
  database: RDS_DB_NAME 
});

// Connect to the database and handle any errors
connection.connect((err) => {
  if (err) {
    console.error('Error connecting to the database:', err.message);
    process.exit(1); // Exit if the connection fails
  }
  console.log('Connected to the MySQL database.');
});

// Initialize Express app
const app = express();

// Root route
app.get('/', async (req, res) => {
  res.send({ message: 'Hello world' });
});

// Initialization route to set up the database
app.get('/init', async (req, res) => {
  try {
    connection.query('CREATE TABLE IF NOT EXISTS users (id INT(5) NOT NULL AUTO_INCREMENT PRIMARY KEY, lastname VARCHAR(40), firstname VARCHAR(40), email VARCHAR(30));', (err, result) => {
      if (err) throw err;
      console.log('Table created or already exists.');
    });

    connection.query('INSERT INTO users (lastname, firstname, email) VALUES ("Yusuf", "Abdulsttar", "yusufabdulsttar@whatever.com"), ("Engy", "mahmoud", "engy@whatever.com"), ("Ibrahim", "ibrahim", "ibrahim@whatever.com");', (err, result) => {
      if (err) throw err;
      console.log('Sample data inserted.');
    });

    res.send({ message: "Init step done" });
  } catch (error) {
    console.error('Error during /init operation:', error.message);
    res.status(500).send({ error: 'An error occurred during initialization.' });
  }
});

// Route to get all users from the database
app.get('/users', async (req, res) => {
  connection.query('SELECT * from users', (error, results) => {
    if (error) {
      console.error('Error fetching users:', error.message);
      res.status(500).send({ error: 'An error occurred while fetching users.' });
      return;
    }
    res.send(results);
  });
});

// Custom 404 route not found handler
app.use((req, res) => {
  res.status(404).send('404 not found');
});

// Start the server
app.listen(PORT, () => {
  console.log(`Listening on PORT ${PORT}`);
});