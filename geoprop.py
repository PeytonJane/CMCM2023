import json
import csv

# Load GeoJSON file
geojson_path = 'counties.geojson'
with open(geojson_path, 'r') as geojson_file:
    geojson_data = json.load(geojson_file)

# Load CSV file
csv_path = 'output.csv'  # Replace with the actual path to your CSV file
with open(csv_path, 'r') as csv_file:
    csv_reader = csv.DictReader(csv_file)
    csv_data = {row['NAME']: row for row in csv_reader}

# Add new properties to GeoJSON features
for feature in geojson_data['features']:
    name = feature['properties']['NAME']  # Replace with the actual property name in your GeoJSON
    if name in csv_data:
        feature['properties']['slf'] = float(csv_data[name]['slf'])
        for i in range(1, 16):  # Assuming 'slf_t1' to 'slf_t15'
            property_name = 'slf_t{}'.format(i)
            feature['properties'][property_name] = float(csv_data[name][property_name])

# Save the updated GeoJSON file
output_geojson_path = 'output_geojson.geojson'
with open(output_geojson_path, 'w') as output_geojson_file:
    json.dump(geojson_data, output_geojson_file)
