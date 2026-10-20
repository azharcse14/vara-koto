// Writes assets/data/routes.json. "updated" (shown in the app's About screen)
// becomes today's date when the data changed, and stays as it was otherwise.

const fs = require('fs');

module.exports = (dest, data) => {
  let prev = null;
  try {
    prev = JSON.parse(fs.readFileSync(dest, 'utf8'));
  } catch (_) {}
  const strip = ({ updated, ...rest }) => JSON.stringify(rest);
  const today = new Date().toISOString().slice(0, 10);
  const same = prev && strip(prev) === strip(data);
  fs.writeFileSync(dest, JSON.stringify({ ...data, updated: (same && prev.updated) || today }));
};
