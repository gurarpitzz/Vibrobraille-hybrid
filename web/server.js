const express = require('express');
const http = require('http');
const WebSocket = require('ws');
const dotenv = require('dotenv');
const cors = require('cors');
const { GoogleGenerativeAI } = require('@google/generative-ai');

dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());
app.use(express.static('.')); // Serve index.html from current dir

const server = http.createServer(app);
const wss = new WebSocket.Server({ server });

const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY || 'MOCK_KEY');

// Session management
const sessions = new Map();

wss.on('connection', (ws) => {
    ws.on('message', (message) => {
        const data = JSON.parse(message);
        if (data.type === 'IDENTIFY') {
            sessions.set(data.sessionId, ws);
            console.log(`Session ${data.sessionId} identified`);
        }
    });

    ws.on('close', () => {
        // Clean up sessions
    });
});

// Gemini Simplification Logic
async function simplifyText(text) {
    if (process.env.GEMINI_API_KEY === 'MOCK_KEY') {
        return text.split('.').slice(0, 1).join('.'); // Simple mock
    }
    const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash-latest" });
    const prompt = `Simplify the following text for tactile reading (Braille). 
    Remove filler words, use short sentences, and preserve only the core meaning.
    Text: "${text}"`;

    const result = await model.generateContent(prompt);
    return result.response.text();
}

app.post('/process', async (req, res) => {
    const { text, sessionId } = req.body;

    // 1. Text Pipeline Pre-processing
    const cleanText = text.trim().replace(/\s+/g, ' ');

    // 2. Gemini AI Processing
    try {
        let simplified;
        try {
            const model = genAI.getGenerativeModel({ model: "gemini-pro" });
            const prompt = `Simplify the following text for tactile reading (Braille). 
            Remove filler words, use short sentences, and preserve only the core meaning.
            Do NOT use markdown. Just plain text.
            Text: "${cleanText}"`;

            const result = await model.generateContent(prompt);
            simplified = result.response.text();
        } catch (apiError) {
            console.error("Gemini API Error:", apiError.message);
            console.log("Falling back to local processing...");
            simplified = cleanText; // Fallback to original text if AI fails
        }

        // 3. Relay to Phone via WebSocket
        const targetWs = sessions.get(sessionId);
        if (targetWs && targetWs.readyState === WebSocket.OPEN) {
            targetWs.send(JSON.stringify({ type: 'BRAILLE_TEXT', payload: simplified }));
            res.json({ success: true, processed: simplified, note: "Processed" });
        } else {
            res.status(404).json({ success: false, error: 'Session not found or inactive' });
        }
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
});

const PORT = process.env.PORT || 3000;
server.listen(PORT, '0.0.0.0', () => {
    console.log(`VibroBraille Brain running on port ${PORT}`);
    console.log(`Local Access: http://localhost:${PORT}`);
    console.log(`Network Access: http://192.168.0.103:${PORT} (or your local IP)`);
});
