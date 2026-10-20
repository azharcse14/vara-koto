// Adds the bus (operator) list from tool/data/bus_routes.csv to assets/data/routes.json.
//
// Usage: node tool/add_buses.js
//
// bus_routes.csv is "Dhaka Local Bus Route" by Mahabub Hasan Mamun on Kaggle
// (kaggle.com/datasets/mahabub001cs/dhaka-local-bus-route), CDLA-Sharing-1.0.
// It is crowd-compiled, has no BRTA route numbers, and may be out of date, so
// the app shows it as unofficial and only for buses that serve both chosen stops.
//
// Each bus stop is stored as every English stop name in routes.json it matches
// (by name or alias), so a bus listing "Paltan" matches routes spelling it "Palton".
// Stops that match nothing are dropped; that can only hide a bus, never add a wrong one.

const fs = require('fs');
const path = require('path');

// Same place, different spelling in the CSV. Only certain matches belong here.
const SPELLING = {
  'Jashimuddin (Uttara)': 'Jashimuddin',
  Sayapabad: 'Sayedabad',
  Bashundhara: 'Basundhara',
  'Shonir Akhra': 'Shanir Akhra',
  Kakali: 'Kakoli',
  Mogbazar: 'Moghbazar',
  Baipayl: 'Baipail',
  'Zirani Bazar': 'Jirani Bazar',
  Nobinagar: 'Nabinagar',
  Bashabo: 'Basabo',
  Chiriyakhana: 'Chiriakhana',
  'Gazipur Chourasta': 'Gazipur Chowrasta',
  Katabon: 'Kataban',
  'Dainik Bangla Moor': 'Dainik Bangla',
  Zirabo: 'Jirabo',
  Rajarbag: 'Rajarbagh',
  Dayagonj: 'Dayaganj',
  'Golshan 1': 'Gulshan-1',
  Dhour: 'Dhaur',
  Vulta: 'Bhulta',
  'Ittefaq Moor': 'Ittefaq',
  'Proshika Moor': 'Proshika',
  Vashantek: 'Bhashantek',
  Duairipara: 'Duyaripara',
  'Shiyal Bari': 'Shialbari',
  Sonargao: 'Sonargaon',
  Fakirapul: 'Fakirapool',
};

// Extra routes.json names for a CSV stop: places routes.json spells two ways
// without linking them, and Fulbaria, which it joins to Gulistan through its
// "Gulistan (Fulbaria)" stop (D Link ends at "Fulbaria" in the CSV).
const SAME_PLACE = {
  Fulbaria: ['Gulistan'],
  Shewrapara: ['Sheorapara'],
  Paltan: ['Palton'],
  Shahbag: ['Shahbagh'],
  Kallyanpur: ['Kalyanpur'],
  Jigatola: ['Jhigatola'],
};

const key = (s) => s.toLowerCase().replace(/[^a-z0-9]/g, '');

const dest = path.join(__dirname, '..', 'assets', 'data', 'routes.json');
const data = JSON.parse(fs.readFileSync(dest, 'utf8'));

const namesByKey = new Map();
for (const route of data.routes) {
  for (const stop of route.stops) {
    for (const k of [stop.nameEn, ...stop.aliases].map(key)) {
      if (!namesByKey.has(k)) namesByKey.set(k, new Set());
      namesByKey.get(k).add(stop.nameEn);
    }
  }
}

const csv = fs.readFileSync(path.join(__dirname, 'data', 'bus_routes.csv'), 'utf8');
let matched = 0;
let total = 0;
data.buses = csv
  .trim()
  .split(/\r?\n/)
  .slice(1)
  .map((line) => {
    const m = line.match(/^"(.*?)","(.*)"$/);
    if (!m) throw new Error(`Bad CSV line: ${line}`);
    const stops = new Set();
    for (const raw of m[2].split(',').map((s) => s.trim())) {
      total++;
      const names = namesByKey.get(key(SPELLING[raw] || raw));
      if (!names) continue;
      matched++;
      names.forEach((n) => stops.add(n));
      for (const other of SAME_PLACE[raw] || []) {
        namesByKey.get(key(other))?.forEach((n) => stops.add(n));
      }
    }
    return { name: m[1].trim(), stops: [...stops] };
  });

require('./write_routes')(dest, data);
console.log(`Added ${data.buses.length} buses, matched ${matched}/${total} of their stops.`);
