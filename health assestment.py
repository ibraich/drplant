import requests
import base64

# Function to encode image to base64
def encode_image_to_base64(image_path):
    with open(image_path, 'rb') as image_file:
        encoded_string = base64.b64encode(image_file.read()).decode('utf-8')
    return encoded_string

# Your Plant.id API key
API_KEY = 'xCW2ZXhZgCLbyJQQJAgqsOWlGvtB9zWBy5fij72TRJKJMbxT5n'

# The endpoint URL
url = 'https://plant.id/api/v3/identification'

# The path to the image you want to identify
image_path = '/Users/ibrahimerdogan/Desktop/drplant/giyhub/drplant/pr-tn-roses-hot-pink.webp'

# Encode the image to base64
encoded_image = encode_image_to_base64(image_path)

# Prepare the payload for the request
payload = {
    'images': [encoded_image],
    'classification_level':'all',
    'similar_images':True,
    'health': 'only'
}

# Prepare the headers for the request
headers = {
    'Content-Type': 'application/json',
    'Api-Key': API_KEY
}

# Make the POST request to the Plant.id API
response = requests.post(url, json=payload, headers=headers)

# Check if the request was successful
if response.status_code == 201:
    # Parse the JSON response
    result = response.json()
    print("Plant identification result:")
    #print(result)
else:
    print(f"Error: {response.status_code}")
    #print(response.text)

disease_suggestions = result['result']['disease']['suggestions']

for suggestion in disease_suggestions:
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