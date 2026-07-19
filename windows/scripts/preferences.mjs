import fs from "node:fs/promises";
import path from "node:path";

const [mode, ...args] = process.argv.slice(2);

function valueFor(name) {
  const index = args.indexOf(`--${name}`);
  if (index < 0 || !args[index + 1]) throw new Error(`Missing --${name}`);
  return args[index + 1];
}

function normalizeNickname(value) {
  const nickname = String(value ?? "").normalize("NFC").trim();
  if (!nickname) return "李嘉图";
  if ([...nickname].length > 24) throw new Error("Nickname must be 24 characters or fewer.");
  if (/[\u0000-\u001f\u007f]/.test(nickname)) throw new Error("Nickname contains unsupported control characters.");
  return nickname;
}

if (mode !== "set-nickname") {
  throw new Error("Usage: preferences.mjs set-nickname --path <file> --nickname <name>");
}

const outputPath = path.resolve(valueFor("path"));
const nickname = normalizeNickname(valueFor("nickname"));
let current = {};
try {
  const parsed = JSON.parse(await fs.readFile(outputPath, "utf8"));
  if (parsed && typeof parsed === "object" && !Array.isArray(parsed)) current = parsed;
} catch (error) {
  if (error.code !== "ENOENT") throw error;
}
const preferences = { ...current, schemaVersion: 1, nickname };
await fs.mkdir(path.dirname(outputPath), { recursive: true, mode: 0o700 });
const temporary = `${outputPath}.${process.pid}.tmp`;
try {
  await fs.writeFile(temporary, `${JSON.stringify(preferences, null, 2)}\n`, { mode: 0o600 });
  await fs.rename(temporary, outputPath);
  await fs.chmod(outputPath, 0o600);
} finally {
  await fs.rm(temporary, { force: true }).catch(() => {});
}
console.log(nickname);
