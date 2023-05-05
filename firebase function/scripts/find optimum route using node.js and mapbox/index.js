const axios = require("axios");
const turf = require("@turf/turf");

async function getDrivingDirections(source, destination) {
  const mapboxAccessToken =
    "pk.eyJ1IjoicGV0ZXJuYWR5IiwiYSI6ImNsZW12a3JqbjAxOHc0NnBhZmFhZWliOWMifQ.yImyNototbp36myOh1hjvg";

  // const url =
  // `https://api.mapbox.com/directions/v5/mapbox/driving/${source};${destination}?geometries=geojson&access_token=${mapboxAccessToken}`;
  const url = `https://api.mapbox.com/directions/v5/mapbox/driving/${source};${destination}?annotations=duration&overview=full&geometries=geojson&access_token=${mapboxAccessToken}`;

  try {
    const response = await axios.get(url);
    const coordinates = response.data.routes[0].geometry.coordinates;
    return coordinates;
  } catch (error) {
    console.error(error);
    return null;
  }
}

async function printCoordinatesWithVelocity(coordinates, velocity) {
  for (let i = 0; i < coordinates.length - 1; i++) {
    const from = turf.point(coordinates[i]);
    const to = turf.point(coordinates[i + 1]);
    const distance = turf.distance(from, to);

    const timeToWait = distance / velocity;
    console.log(timeToWait);
    console.log(`Coordinate ${i + 1}: ${coordinates[i]}`);

    await new Promise((resolve) => setTimeout(resolve, timeToWait * 3600000));
  }

  console.log(
    `Coordinate ${coordinates.length}: ${coordinates[coordinates.length - 1]}`
  );
}

async function main() {
  const source = "-122.4194,37.7749"; // San Francisco
  const destination = "-73.9352,40.7306"; // New York City
  const velocity = 30; // km/h

  const coordinates = await getDrivingDirections(source, destination);

  if (coordinates) {
    await printCoordinatesWithVelocity(coordinates, velocity);
  } else {
    console.log("Failed to get driving directions");
  }
}

main();
