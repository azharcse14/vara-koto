// Converts the web project's server/data/fareData.js into assets/data/routes.json.
//
// Usage (from the Flutter project root):
//   node tool/export_data.js ../DHAKA_LOCAL_BUS_VARA/server/data/fareData.js
//
// The same JSON shape is what GET /api/routes should return once the app
// switches to server mode, so the app never needs two data formats.

const fs = require('fs');
const path = require('path');

const src = process.argv[2];
if (!src) {
  console.error('Usage: node tool/export_data.js <path to fareData.js> [version]');
  process.exit(1);
}

const { routes } = require(path.resolve(src));
const version = process.argv[3] || new Date().toISOString().slice(0, 10);

let fixedNulls = 0;
const cleaned = routes.map((r) => ({
  id: r.id,
  routeNo: r.routeNo,
  nameBn: r.nameBn,
  nameEn: r.nameEn,
  totalKm: r.totalKm,
  stops: r.stops.map((s, i) => {
    if (s.id !== i) throw new Error(`Route ${r.id}: stop id ${s.id} is not at index ${i}`);
    return { id: s.id, nameEn: s.nameEn, nameBn: s.nameBn, aliases: s.aliases };
  }),
  // A few matrices use null on the diagonal (stop to itself). Store 0 instead.
  fareMatrix: r.fareMatrix.map((row, i) =>
    row.map((f, j) => {
      if (typeof f === 'number') return f;
      if (i !== j) throw new Error(`Route ${r.id}: missing fare at [${i}][${j}]`);
      fixedNulls++;
      return 0;
    })
  ),
}));

const out = {
  version,
  source: 'BRTA diesel bus fare chart, notice no. 35.00.0000.020.26.005.16-540',
  routes: cleaned,
};

const dest = path.join(__dirname, '..', 'assets', 'data', 'routes.json');
fs.mkdirSync(path.dirname(dest), { recursive: true });
fs.writeFileSync(dest, JSON.stringify(out));

const kb = (fs.statSync(dest).size / 1024).toFixed(0);
console.log(`Wrote ${cleaned.length} routes to ${dest} (${kb} KB), fixed ${fixedNulls} null diagonal cells.`);
