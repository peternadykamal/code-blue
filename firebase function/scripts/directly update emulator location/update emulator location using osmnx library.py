import osmnx as ox
from geopy.distance import distance
import subprocess
import time
import os

adb_path = os.path.join(os.environ['USERPROFILE'], 'AppData', 'Local', 'Android', 'Sdk', 'platform-tools', 'adb')

# Set emulator location update interval in seconds
LOCATION_UPDATE_INTERVAL = 2

# Set velocity in km/h
VELOCITY = 50

# Set start and end points
start_point = (31.247189, 29.973925)
end_point = (31.240736, 29.987423)

graph = ox.graph_from_point(start_point, dist=2000, network_type='drive')

# Get the nearest network nodes to the start and end points
start_node = ox.distance.nearest_nodes(graph, start_point[1], start_point[0])
end_node = ox.distance.nearest_nodes(graph, end_point[1], end_point[0])

# Find the shortest path between the start and end nodes
route = ox.shortest_path(graph, start_node, end_node, weight='length')

# Iterate through the route nodes
prev_node = None
for node in route:
    # Get latitude and longitude of current node
    lat, lon = graph.nodes[node]['y'], graph.nodes[node]['x']

    # Send geo fix command to emulator
    cmd = f'{adb_path} emu geo fix "{lon} {lat}"'
    subprocess.call(cmd, shell=True)

    # Wait for OK response from emulator
    while True:
        response = subprocess.check_output(cmd, shell=True)
        if response.strip() == b'OK':
            break
        time.sleep(0.1)

    # Calculate time difference
    if prev_node:
        distance_in_km = distance((lat, lon), (graph.nodes[prev_node]['y'], graph.nodes[prev_node]['x'])).km
        time_diff = (distance_in_km / VELOCITY) * 3600
        print(f'Waited for {time_diff} seconds, moved to ({lat}, {lon})')
        time.sleep(max(LOCATION_UPDATE_INTERVAL, time_diff))

    # Update previous node
    prev_node = node
