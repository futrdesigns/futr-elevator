// FUTR Elevator - UI Script
let currentBuilding = null;
let currentFloorName = null;

// Listen for messages from game
window.addEventListener('message', (event) => {
    const data = event.data;

    if (data.action === 'open') {
        openElevatorUI(data);
    } else if (data.action === 'close') {
        closeElevatorUI();
    }
});

// Open the elevator UI
function openElevatorUI(data) {
    const { building, currentFloor } = data;
    currentBuilding = building;
    currentFloorName = currentFloor;

    // Set building info
    const iconElement = $('#buildingIcon');
    
    // Check if building has a custom icon
    if (building.icon && building.icon.trim() !== '') {
        // If it's an image path (ends with image extension)
        if (building.icon.match(/\.(png|jpg|jpeg|svg|gif)$/i)) {
            // Replace with img tag
            iconElement.html(`<img src="${building.icon}" alt="Building Icon" style="width: 100%; height: 100%; object-fit: contain;">`);
        } else {
            // It's an emoji or text, replace the entire content
            iconElement.html(`<span style="font-size: 36px;">${building.icon}</span>`);
        }
    }
    // Otherwise keep the default SVG icon that's already in the HTML
    
    $('#buildingName').text(building.name);
    $('#currentFloor').text(currentFloor);

    // Filter out current floor and render floor buttons
    const availableFloors = building.floors.filter(floor => floor.name !== currentFloor);
    renderFloors(availableFloors);

    // Show UI
    setUIVisible(true);
}

// Close the elevator UI
function closeElevatorUI() {
    setUIVisible(false);
    
    // Reset icon to default SVG when closing
    setTimeout(() => {
        const iconElement = $('#buildingIcon');
        iconElement.html(`
            <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M12 3L4 7V17L12 21L20 17V7L12 3Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                <path d="M12 21V11" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                <path d="M4 7L12 11L20 7" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                <path d="M8 9.5V14.5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
                <path d="M16 9.5V14.5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
            </svg>
        `);
    }, 300);
}

// Render floor buttons
function renderFloors(floors) {
    const container = $('#floorsContainer');
    container.empty();

    floors.forEach((floor, index) => {
        const button = $(`
            <div class="floor-button" data-floor-index="${index}">
                <span class="floor-name">${floor.name}</span>
                <span class="floor-description">${floor.description || 'Select to travel'}</span>
            </div>
        `);

        button.on('click', function() {
            selectFloor(floor);
        });

        container.append(button);
    });
}

// Handle floor selection
function selectFloor(floor) {
    // Send to game
    fetch('https://futr-elevator/floorSelected', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8'
        },
        body: JSON.stringify({
            coords: floor.coords
        })
    }).then(res => res.json())
      .then(data => {
          if (data === 'OK') {
              closeElevatorUI();
          }
      })
      .catch(err => console.error('Error selecting floor:', err));
}

// Close button handler
$('#closeButton').on('click', function() {
    fetch('https://futr-elevator/close', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8'
        }
    }).then(res => res.json())
      .then(data => {
          if (data === 'OK') {
              closeElevatorUI();
          }
      })
      .catch(err => console.error('Error closing UI:', err));
});

// ESC key handler
document.addEventListener('keyup', (event) => {
    if (event.key === 'Escape') {
        fetch('https://futr-elevator/close', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8'
            }
        }).then(res => res.json())
          .then(data => {
              if (data === 'OK') {
                  closeElevatorUI();
              }
          })
          .catch(err => console.error('Error closing UI:', err));
    }
});

// Set UI visibility
function setUIVisible(visible) {
    const body = document.getElementsByTagName('body')[0];
    body.style.display = visible ? 'block' : 'none';
}

// Initialize
$(document).ready(function() {
    console.log('FUTR Elevator UI initialized');
});