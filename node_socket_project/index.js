const express = require('express');
const http = require('http');
const socketIo = require('socket.io');
const mongoose = require('mongoose');
const path = require('path');

const app = express();
const server = http.createServer(app);
const io = socketIo(server);

// Serve static files from the 'public' directory
app.use(express.static(path.join(__dirname, 'public')));

// Connect to MongoDB
mongoose.connect('mongodb://localhost:27017/live_location', { useNewUrlParser: true, useUnifiedTopology: true });

// Define a schema and model for storing location
const locationSchema = new mongoose.Schema({
    userId: String,
    latitude: Number,
    longitude: Number,
    updatedAt: { type: Date, default: Date.now }
});

const Location = mongoose.model('Location', locationSchema);

const userSockets = {}; // To keep track of userId and their socket ids

io.on('connection', (socket) => {
    console.log('New client connected');

    // Handle joining a specific user
    socket.on('join', (userId) => {
        userSockets[userId] = socket.id; // Track userId with the socket id
        console.log(`Client with socket ${socket.id} joined for user: ${userId}`);
    });

    // Listening for location updates from a client
    socket.on('update_location', async (data) => {
        const { userId, latitude, longitude } = data;
        await Location.findOneAndUpdate(
            { userId },
            { latitude, longitude, updatedAt: new Date() },
            { upsert: true, new: true }
        );

        // Emit the location update to the specific user only
        if (userSockets[userId]) {
            io.to(userSockets[userId]).emit('location_update', data);
        }
    });

    // Send the last known location when a client requests it
    socket.on('get_last_location', async (userId) => {
        const lastLocation = await Location.findOne({ userId });
        if (lastLocation) {
            socket.emit('last_location', lastLocation);
        }
    });

    socket.on('disconnect', () => {
        console.log('Client disconnected');
        // Remove socket from userSockets when disconnected
        for (const [userId, socketId] of Object.entries(userSockets)) {
            if (socketId === socket.id) {
                delete userSockets[userId];
                break;
            }
        }
    });
});

server.listen(3000, () => console.log('Server running on port 3000'));
