const express = require("express");
const fs = require("fs");
const path = require("path");
const crypto = require("crypto");

const app = express();
const PORT = process.env.PORT || 3000;

// ==============================
// CONFIG
// ==============================

const ADMIN_PASSWORD = process.env.ADMIN_PASSWORD;

if (!ADMIN_PASSWORD) {
    console.error("ADMIN_PASSWORD is not configured.");
}

// ==============================
// FILES
// ==============================

const KEYS_FILE = path.join(__dirname, "keys.json");
const SCRIPT_FILE = path.join(__dirname, "script.lua");

// ==============================
// MIDDLEWARE
// ==============================

app.use(express.json());
app.use(express.static(__dirname));

// ==============================
// KEY DATABASE
// ==============================

function loadKeys() {
    try {
        if (!fs.existsSync(KEYS_FILE)) {
            fs.writeFileSync(
                KEYS_FILE,
                JSON.stringify({ keys: [] }, null, 2)
            );
        }

        return JSON.parse(
            fs.readFileSync(KEYS_FILE, "utf8")
        );
    } catch {
        return { keys: [] };
    }
}

function saveKeys(data) {
    fs.writeFileSync(
        KEYS_FILE,
        JSON.stringify(data, null, 2)
    );
}

// ==============================
// GENERATE KEY
// ==============================

function generateKey() {
    return "ZERO-" +
        crypto.randomBytes(12)
            .toString("hex")
            .toUpperCase();
}

// ==============================
// CHECK KEY
// ==============================

function findValidKey(key) {
    const database = loadKeys();

    const item = database.keys.find(
        x => x.key === key
    );

    if (!item) {
        return null;
    }

    if (!item.enabled) {
        return null;
    }

    if (item.expiresAt !== null) {
        const expired =
            new Date(item.expiresAt).getTime() <= Date.now();

        if (expired) {
            return null;
        }
    }

    return item;
}

// ==============================
// ADMIN AUTH
// ==============================

function adminAuth(req, res, next) {
    const password = req.headers["x-admin-password"];

    if (!ADMIN_PASSWORD ||
        password !== ADMIN_PASSWORD) {

        return res.status(401).json({
            success: false,
            message: "Unauthorized"
        });
    }

    next();
}

// ==============================
// HOME
// ==============================

app.get("/", (req, res) => {
    res.sendFile(
        path.join(__dirname, "index.html")
    );
});

// ==============================
// CHECK API KEY
// ==============================

app.get("/api/check", (req, res) => {

    const key = req.query.key;

    if (!key) {
        return res.status(400).json({
            success: false,
            message: "Missing key"
        });
    }

    const valid = findValidKey(key);

    if (!valid) {
        return res.status(403).json({
            success: false,
            message: "Invalid or expired key"
        });
    }

    res.json({
        success: true,
        expiresAt: valid.expiresAt
    });
});

// ==============================
// RAW SCRIPT
// ==============================

app.get("/raw", (req, res) => {

    const key = req.query.key;

    if (!key) {
        return res.status(403)
            .type("text/plain")
            .send("-- Access denied");
    }

    const valid = findValidKey(key);

    if (!valid) {
        return res.status(403)
            .type("text/plain")
            .send("-- Invalid or expired key");
    }

    if (!fs.existsSync(SCRIPT_FILE)) {
        return res.status(404)
            .type("text/plain")
            .send("-- Script not found");
    }

    const script = fs.readFileSync(
        SCRIPT_FILE,
        "utf8"
    );

    res
        .status(200)
        .type("text/plain")
        .send(script);
});

// ==============================
// ADMIN: LIST KEYS
// ==============================

app.get(
    "/api/admin/keys",
    adminAuth,
    (req, res) => {

        const database = loadKeys();

        res.json({
            success: true,
            keys: database.keys
        });
    }
);

// ==============================
// ADMIN: CREATE KEY
// ==============================

app.post(
    "/api/admin/keys",
    adminAuth,
    (req, res) => {

        const days = Number(req.body.days);

        if (!Number.isInteger(days) || days < 0) {
            return res.status(400).json({
                success: false,
                message: "Invalid days"
            });
        }

        const database = loadKeys();

        const key = generateKey();

        let expiresAt = null;

        if (days > 0) {
            expiresAt = new Date(
                Date.now() +
                days * 24 * 60 * 60 * 1000
            ).toISOString();
        }

        database.keys.push({
            key,
            enabled: true,
            createdAt: new Date().toISOString(),
            expiresAt
        });

        saveKeys(database);

        res.json({
            success: true,
            key,
            expiresAt
        });
    }
);

// ==============================
// ADMIN: ENABLE / DISABLE
// ==============================

app.patch(
    "/api/admin/keys/:key",
    adminAuth,
    (req, res) => {

        const database = loadKeys();

        const item = database.keys.find(
            x => x.key === req.params.key
        );

        if (!item) {
            return res.status(404).json({
                success: false,
                message: "Key not found"
            });
        }

        item.enabled =
            req.body.enabled === true;

        saveKeys(database);

        res.json({
            success: true,
            key: item.key,
            enabled: item.enabled
        });
    }
);

// ==============================
// ADMIN: DELETE KEY
// ==============================

app.delete(
    "/api/admin/keys/:key",
    adminAuth,
    (req, res) => {

        const database = loadKeys();

        const before = database.keys.length;

        database.keys =
            database.keys.filter(
                x => x.key !== req.params.key
            );

        if (database.keys.length === before) {
            return res.status(404).json({
                success: false,
                message: "Key not found"
            });
        }

        saveKeys(database);

        res.json({
            success: true,
            message: "Key deleted"
        });
    }
);

// ==============================
// INFO
// ==============================

app.get("/api/info", (req, res) => {
    res.json({
        name: "Zero HUB",
        status: "online",
        version: "1.0.0"
    });
});

// ==============================
// START
// ==============================

app.listen(PORT, () => {
    console.log(
        `Zero HUB running on port ${PORT}`
    );
});
