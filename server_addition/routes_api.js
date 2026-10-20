// GET /api/routes — the full fare dataset for the Flutter app's server mode.
//
// Setup in the web project (DHAKA_LOCAL_BUS_VARA/server):
//   1. Copy this file to server/routes/routes_api.js
//   2. Copy the app's assets/data/routes.json to server/data/routes.json
//   3. In server.js, next to the other routes:
//        app.use('/api', require('./routes/routes_api'));
//   4. Optional, shrinks the download from ~260 KB to ~42 KB:
//        npm install compression
//        app.use(require('compression')());   // before the routes
//
// To publish new fares: regenerate routes.json with a newer "version"
// (node tool/export_data.js <fareData.js> 2026-12-01) and replace the file.
// Apps pick it up on their next launch; no app update needed.

const express = require('express');
const path = require('path');

const router = express.Router();
const dataFile = path.join(__dirname, '../data/routes.json');

router.get('/routes', (req, res) => {
  res.set('Cache-Control', 'public, max-age=3600');
  res.sendFile(dataFile, (err) => {
    if (err && !res.headersSent) {
      res.status(500).json({ error: 'Fare data is not available right now.' });
    }
  });
});

module.exports = router;
