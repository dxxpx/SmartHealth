import bodyParser from 'body-parser';
import axios from 'axios';
import express from 'express';
import { GoogleGenerativeAI } from "@google/generative-ai";
import cors from 'cors';

// Initialize Express app
const app = express();
const port = 3000;
const genAI = new GoogleGenerativeAI("AIzaSyBdM-zkMxxQhCkvept_nv0BIXtUTEwTOZ8");

app.use(bodyParser.json());
app.use(cors());

// Model configuration
var gemini_reply = "Loading";
let model;

async function initializeModel() {
    const generation_config = {
        temperature: 1,
        top_p: 0.95,
        top_k: 16,
        max_output_tokens: 200,
        response_mime_type: "application/json",
    };
    model = genAI.getGenerativeModel({
        model: "gemini-1.5-flash",
        generation_config,
    });
}

async function GeminiAi(params) {
    if (!model) {
        await initializeModel();
    }

    const result = await model.generateContent(params);
    const response = await result.response;
    gemini_reply = response.text();  // response.text() should be used with await
    console.log(response.text());
}

// Endpoint for water potability
app.post('/water/potability', async (req, res) => {
    try {
        const response = await axios.post('http://localhost:5000/predict', req.body);
        res.json(response.data);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Error connecting to the model server' });
    }
});

// Endpoint for handling AI requests
app.post("/api/data", async (req, res) => {
    console.log("Request from app : ", req.body);
    const user_prompt = req.body.prompt;
    await GeminiAi(user_prompt);
    res.status(200).json({
        success: true,
        status_code: 200,
        message: gemini_reply,
        user_prompt: req.body,
    });
});

// Simple GET endpoint
app.get("/api/data", (req, res) => {
    res.status(200).send("Hey, You are in my backend!!!");
});

// Start the server
app.listen(port, () => {
    console.log(`Server is running on https://ec8f-103-114-208-197.ngrok-free.app/api/data`);
});
