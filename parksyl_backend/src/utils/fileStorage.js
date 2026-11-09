const fs = require('fs');
const path = require('path');
const { DATA_DIR } = require('../config/constants');

// Ensure data directory exists
if (!fs.existsSync(DATA_DIR)) {
  fs.mkdirSync(DATA_DIR, { recursive: true });
}

const writeQueues = {};

/**
 * Read JSON file safely
 * @param {string} filename 
 * @param {Array|Object} defaultValue 
 * @returns {Promise<Array|Object>}
 */
async function readJson(filename, defaultValue = []) {
  const filePath = path.join(DATA_DIR, filename);
  try {
    if (!fs.existsSync(filePath)) {
      await writeJson(filename, defaultValue);
      return defaultValue;
    }
    const data = await fs.promises.readFile(filePath, 'utf8');
    if (!data.trim()) return defaultValue;
    return JSON.parse(data);
  } catch (err) {
    console.error(`[fileStorage] Error reading ${filename}:`, err.message);
    return defaultValue;
  }
}

/**
 * Write JSON file safely with serialized queue per file
 * @param {string} filename 
 * @param {Array|Object} data 
 * @returns {Promise<boolean>}
 */
async function writeJson(filename, data) {
  const filePath = path.join(DATA_DIR, filename);
  
  if (!writeQueues[filename]) {
    writeQueues[filename] = Promise.resolve();
  }

  // Queue write operations for this file
  writeQueues[filename] = writeQueues[filename].then(async () => {
    try {
      const tempPath = `${filePath}.tmp_${Date.now()}_${Math.random().toString(36).substring(2, 7)}`;
      const jsonContent = JSON.stringify(data, null, 2);
      await fs.promises.writeFile(tempPath, jsonContent, 'utf8');
      await fs.promises.rename(tempPath, filePath);
      return true;
    } catch (err) {
      console.error(`[fileStorage] Error writing ${filename}:`, err.message);
      throw err;
    }
  });

  return writeQueues[filename];
}

module.exports = {
  readJson,
  writeJson,
};
