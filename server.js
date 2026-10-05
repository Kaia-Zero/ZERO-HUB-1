const express = require("express");
const fs = require("fs");
const path = require("path");

const app = express();
const PORT = process.env.PORT || 3000;

// ==============================
// ZERO HUB API KEYS
// ==============================

const API_KEYS = new Set([
    "ZERO-123456",
    "ZERO-789012"
]);

// ==============================
// WEBSITE
// ==============================

app.use(express.static(__dirname));

app.get("/", (req, res) => {
    res.sendFile(path.join(__dirname, "index.html"));
});

// ==============================
// CHECK KEY
// ==============================

app.get("/api/check", (req, res) => {
    const key = req.query.key;

    if (!key) {
        return res.status(400).json({
            success: false,
            message: "Missing API key"
        });
    }

    if (!API_KEYS.has(key)) {
        return res.status(403).json({
            success: false,
            message: "Invalid API key"
        });
    }

    res.json({
        success: true,
        message: "Key valid"
    });
});

// ==============================
// RAW SCRIPT
// ==============================

app.get("/raw", (req, res) => {
    const key = req.query.key;

    if (!key || !API_KEYS.has(key)) {
        return res.status(403)
            .type("text/plain")
            .send("-- Access denied");
    }

    const scriptPath = path.join(__dirname, "script.lua");

    if (!fs.existsSync(scriptPath)) {
        return res.status(404)
            .type("text/plain")
            .send("-- Script not found");
    }

    const script = fs.readFileSync(scriptPath, "utf8");

    res
        .status(200)
        .type("text/plain")
        .send(script);
});

// ==============================
// API INFO
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
    console.log(`Zero HUB running on port ${PORT}`);
});
