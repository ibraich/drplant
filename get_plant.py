import requests
# Your Plant.id API key
API_KEY = 'xCW2ZXhZgCLbyJQQJAgqsOWlGvtB9zWBy5fij72TRJKJMbxT5n'

# The endpoint URL
url = 'https://plant.id/api/v3/identification/GcBF2C7UvZ43ZAH'

headers = {
    'Content-Type': 'application/json',
    'Api-Key': API_KEY
}
response = requests.get(url, headers=headers)
if response.status_code == 200:
    # Parse the JSON response
    result = response.json()
    print("Plant identification result:")
    #print(result)
else:
    print(f"Error: {response.status_code}")
    #print(response.text)

suggestions = result['result']['classification']['suggestions']

for suggestion in suggestions:
    name = suggestion['name']
    probability = suggestion['probability']
    similar_images = suggestion['similar_images']

    # Printing the extracted information
    print(f"Name: {name}")
    print(f"Probability: {probability}")
    print("Similar Images:")
    for image in similar_images:
        print(f"  - {image['url']} (Similarity: {image['similarity']})")
    print()