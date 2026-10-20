// Lists stops whose English name is an alias of a differently named stop on
// another route, i.e. one place spelled two ways ("Palton" / "Paltan").
// Usage: node tool/find_spelling_variants.js [path to routes.json]

const fs = require('fs');
const path = require('path');

const file = process.argv[2] || path.join(__dirname, '..', 'assets', 'data', 'routes.json');
const { routes } = JSON.parse(fs.readFileSync(file, 'utf8'));

const names = new Set(routes.flatMap((r) => r.stops.map((s) => s.nameEn)));
const pairs = new Map();

for (const route of routes) {
  for (const stop of route.stops) {
    for (const alias of stop.aliases) {
      for (const name of names) {
        if (name !== stop.nameEn && name.toLowerCase() === alias.toLowerCase()) {
          const key = `${name}  ->  ${stop.nameEn}`;
          if (!pairs.has(key)) pairs.set(key, new Set());
          pairs.get(key).add(route.id);
        }
      }
    }
  }
}

console.log(`${pairs.size} names that are also an alias of a different stop:\n`);
for (const [key, ids] of [...pairs].sort()) {
  console.log(`${key}   (${[...ids].join(', ')})`);
}
