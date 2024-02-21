import json
from google.oauth2 import service_account
import google.auth.transport.requests
import requests
import pandas as pd

###### START OF VARIABLES TO EDIT #############################################################################################################

# Replace the following with your service account JSON file path
SERVICE_ACCOUNT_FILE = '/Users/gabriellatan/Documents/python scripts/ecoring-indexing-api-6248b5acd1cc.json'

excel_file_path = "/Users/gabriellatan/Documents/python scripts/ecoring-URLs.xlsx" # Replace with path to excel file

sheet_name = "Sheet1" # Replace with sheet name

url_column_name = "URLs" # Replace with name of column containing URLs

####### END OF VARIABLES TO EDIT #############################################################################################################

# Replace with your specific scope for the Indexing API
SCOPES = ['https://www.googleapis.com/auth/indexing']

# Load the service account credentials
credentials = service_account.Credentials.from_service_account_file(
    SERVICE_ACCOUNT_FILE, scopes=SCOPES)

# Request an access token
request = google.auth.transport.requests.Request()
credentials.refresh(request)

# Define the headers for the Indexing API request
headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ' + credentials.token,
}

df = pd.read_excel(excel_file_path, sheet_name=sheet_name)

urls = df[url_column_name].tolist()

# The endpoint for the Indexing API
api_url = "https://indexing.googleapis.com/v3/urlNotifications:publish"

# Loop through the URLs and send POST requests
for url in urls:
    payload = json.dumps({
        "url": url,
        "type": "URL_UPDATED"  # Use URL_DELETED for removing URLs
    })

    response = requests.post(api_url, headers=headers, data=payload)
    print(f"URL: {url}, Response: {response.text}")
