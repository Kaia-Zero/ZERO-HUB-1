const express = require("express");
const fs = require("fs");
const path = require("path");

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.static(__dirname));

app.get("/", (req, res) => {
    res.sendFile(path.join(__dirname, "index.html"));
});

app.get("/raw", (req, res) => {
    const scriptPath = path.join(__dirname, "script.lua");

    if (!fs.existsSync(scriptPath)) {
        return res
            .status(404)
            .type("text/plain")
            .send("-- Script not found");
    }

    const script = fs.readFileSync(scriptPath, "utf8");

    res
        .status(200)
        .type("text/plain")
        .send(script);
});

app.get("/api/info", (req, res) => {
    res.json({
        name: "Zero HUB",
        status: "online",
        raw: "/raw"
    });
});

app.listen(PORT, () => {
    console.log(`Zero HUB running on port ${PORT}`);
});