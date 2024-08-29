// Connect to the Socket.IO server
const socket = io('http://localhost:3000'); // Adjust the URL if needed

// Get references to the form and updates list
const form = document.getElementById('locationForm');
const updatesList = document.getElementById('updatesList');

// Handle form submission
form.addEventListener('submit', (event) => {
    event.preventDefault();

    // Get user ID, latitude, and longitude values from input fields
    const userId = document.getElementById('userId').value;
    const latitude = parseFloat(document.getElementById('latitude').value);
    const longitude = parseFloat(document.getElementById('longitude').value);

    if (!userId || isNaN(latitude) || isNaN(longitude)) {
        alert('Please enter valid user ID, latitude, and longitude.');
        return;
    }

    // Send location update to the server
    socket.emit('update_location', {
        userId: userId,
        latitude: latitude,
        longitude: longitude,
    });

    // Clear the form inputs
    form.reset();
});

// Handle receiving location updates from the server
socket.on('location_update', (data) => {
    if (data.userId) {
        const listItem = document.createElement('li');
        listItem.textContent = `User: ${data.userId}, Latitude: ${data.latitude}, Longitude: ${data.longitude}`;
        updatesList.appendChild(listItem);
    } else {
        console.error('Received update with missing userId:', data);
    }
});
