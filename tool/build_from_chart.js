// Replaces routes in assets/data/routes.json with the BRTA chart of 22 Sep 2026
// (notice 35.00.0000.020.26.005.16-540), transcribed in tool/data/brta_chart_2026-09-22.json.
//
// Usage: node tool/build_from_chart.js   (export_data.js also runs it)
//
// A route whose number is in the chart takes the chart's stops and printed
// fares (all variants with that number are replaced by the one chart route),
// unless the earlier route runs on a road the chart doesn't have (see inChart).
// Routes the chart doesn't list keep their earlier data. New chart routes are
// placed in route-number order.
//
// tool/data/chart_stop_names.json gives every chart stop (as printed) its
// English name and the Bangla name the app shows, so reruns give the same
// result. A printed name missing there stops the build; add it to the file.

const fs = require('fs');
const path = require('path');

const dest = path.join(__dirname, '..', 'assets', 'data', 'routes.json');
const data = JSON.parse(fs.readFileSync(dest, 'utf8'));
const chart = require('./data/brta_chart_2026-09-22.json');
const names = require('./data/chart_stop_names.json');

const BN_DIGITS = '০১২৩৪৫৬৭৮৯';
const toBn = (s) => String(s).replace(/[0-9]/g, (d) => BN_DIGITS[d]);
const routeNum = (no) => Number(no.replace(/[^0-9০-৯]/g, '').replace(/[০-৯]/g, (c) => BN_DIGITS.indexOf(c)));

// Aliases already in routes.json for each English stop name.
const aliasesOf = new Map();
for (const route of data.routes) {
  for (const s of route.stops) {
    if (!aliasesOf.has(s.nameEn)) aliasesOf.set(s.nameEn, new Set());
    s.aliases.forEach((a) => aliasesOf.get(s.nameEn).add(a));
  }
}

// Plus every spelling the chart prints, collected before any route is built
// so every route gets the same alias list.
for (const c of chart.routes) {
  for (const { nameBn: printed } of c.stops) {
    const name = names[printed];
    if (!name) throw new Error(`No name for chart stop "${printed}"; add it to chart_stop_names.json`);
    if (!aliasesOf.has(name.en)) aliasesOf.set(name.en, new Set([name.en.toLowerCase(), name.bn]));
    aliasesOf.get(name.en).add(printed);
  }
}

const stopFor = (printedBn, index) => {
  const name = names[printedBn];
  return { id: index, nameEn: name.en, nameBn: name.bn, aliases: [...aliasesOf.get(name.en)] };
};

const fromChart = new Map();
for (const c of chart.routes) {
  const n = c.stops.length;
  c.rows.forEach((row, i) => {
    if (row.length !== i) throw new Error(`${c.routeNo}: row ${i} has ${row.length} fares`);
  });
  const stops = c.stops.map((s, i) => stopFor(s.nameBn, i));
  const fareMatrix = stops.map((_, i) => stops.map((_, j) => (i === j ? 0 : i > j ? c.rows[i][j] : c.rows[j][i])));
  const num = routeNum(c.routeNo);
  fromChart.set(num, {
    id: `A${num}`,
    routeNo: `এ-${toBn(num)}`,
    nameBn: `${stops[0].nameBn} → ${stops[n - 1].nameBn}`,
    nameEn: `${stops[0].nameEn} → ${stops[n - 1].nameEn}`,
    totalKm: c.stops[n - 1].km,
    stops,
    fareMatrix,
  });
}

const routes = [];
const placed = new Set();
const insertNewUpTo = (num) => {
  for (const [n, r] of [...fromChart].sort((a, b) => a[0] - b[0])) {
    if (n < num && !placed.has(n) && !data.routes.some((o) => routeNum(o.routeNo) === n)) {
      routes.push(r);
      placed.add(n);
    }
  }
};
// An earlier route is in the chart when a chart route shares 60% of its stops,
// or the chart route with its number has the same two ends. Otherwise the
// chart reused its number for another road (A380 was Khilgaon → Pallabi, the
// chart's A-380 is Shialbari → Kamalapur), so the earlier route stays too.
const sameStop = (a, b) =>
  a.nameEn === b.nameEn || a.aliases.includes(b.nameEn.toLowerCase()) || b.aliases.includes(a.nameEn.toLowerCase());
const shared = (a, b) => {
  const names = new Set(b.stops.map((s) => s.nameEn));
  const n = new Set(a.stops.map((s) => s.nameEn).filter((s) => names.has(s))).size;
  return n / Math.max(new Set(a.stops.map((s) => s.nameEn)).size, names.size);
};
const sameEnds = (a, b) => {
  const [a0, a1, b0, b1] = [a.stops[0], a.stops.at(-1), b.stops[0], b.stops.at(-1)];
  return (sameStop(a0, b0) && sameStop(a1, b1)) || (sameStop(a0, b1) && sameStop(a1, b0));
};
const inChart = (old, num) =>
  [...fromChart.values()].some((r) => shared(old, r) >= 0.6) || sameEnds(old, fromChart.get(num));

let keptOld = 0;
for (const old of data.routes) {
  const num = routeNum(old.routeNo);
  if (num) insertNewUpTo(num);
  if (!fromChart.has(num)) {
    routes.push(old);
    continue;
  }
  if (!placed.has(num)) {
    routes.push(fromChart.get(num));
    placed.add(num);
  }
  // An _OLD route was judged on an earlier run, before stop names were merged.
  if (old.id.endsWith('_OLD') || !inChart(old, num)) {
    routes.push({ ...old, id: old.id.endsWith('_OLD') ? old.id : `${old.id}_OLD` });
    keptOld++;
  }
}
insertNewUpTo(Infinity);

// One place, one English name: stops with the same Bangla name ("শাহবাগ" as
// Shahbag and Shahbagh) take the name most stops use, and keep the other as
// an alias. Otherwise the app lists them as two stops and finds half the routes.
const bnKey = (s) => s.normalize('NFD').replace(/[\s()\-.:ঃ,‌‍]/g, '');
const counts = new Map();
for (const r of routes) {
  for (const s of r.stops) {
    const k = bnKey(s.nameBn);
    if (!counts.has(k)) counts.set(k, new Map());
    counts.get(k).set(s.nameEn, (counts.get(k).get(s.nameEn) || 0) + 1);
  }
}
const canonical = (s) => [...counts.get(bnKey(s.nameBn))].sort((a, b) => b[1] - a[1] || a[0].localeCompare(b[0]))[0][0];
const merged = new Map();
for (const r of routes) {
  for (const s of r.stops) {
    if (!merged.has(canonical(s))) merged.set(canonical(s), new Set());
    [s.nameEn.toLowerCase(), ...s.aliases].forEach((a) => merged.get(canonical(s)).add(a));
  }
}
data.routes = routes.map((r) => ({
  ...r,
  stops: r.stops.map((s) => ({ ...s, nameEn: canonical(s), aliases: [...merged.get(canonical(s))] })),
}));
data.source = `${chart.source}. Routes not in that chart keep the earlier chart's fares.`;
require('./write_routes')(dest, data);
console.log(
  `${fromChart.size} routes from the chart, ${routes.length - fromChart.size} kept from earlier data ` +
    `(${keptOld} on a road the chart gave another route's number), ${routes.length} in all.`,
);
