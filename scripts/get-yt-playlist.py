# To configure the YOUR_CLIENT_SECRETS_FILE.json file for your Google
# API credentials, you'll need to create a new project in the Google
# Cloud Console and enable the YouTube Data API v3. Here are the steps
# you can follow:
#
#    1. Go to the Google Cloud Console: https://console.cloud.google.com/
#
#    2. Create a new project by clicking the project dropdown menu at the top of the page and selecting "New Project".
#
#    3. Enter a name for your project and click "Create".
#
#    4. Once your project is created, go to the "APIs & Services" page and click "Dashboard".
#
#    5. Click the "Enable APIs and Services" button at the top of the page.
#
#    6. Search for "YouTube Data API v3" and click on it.
#
#    7. Click the "Enable" button.
#
#    8. Go to the "Credentials" page and click "Create Credentials" -> "OAuth client ID".
#
#    9. Select "Desktop App" as the application type.
#
#   10. Enter a name for your OAuth client ID and click "Create".
#
#   11. On the next page, click "Download" to download the client secrets JSON file.
#
#   12. Move the downloaded JSON file to the same directory as your
#       Python script and rename it to YOUR_CLIENT_SECRETS_FILE.json.
#
# Once you've completed these steps, you should be able to run the
# Python script with your updated YOUR_CLIENT_SECRETS_FILE.json file.

import os
import sys
import google.auth.transport.requests
import google.oauth2.credentials
import google_auth_oauthlib.flow
import googleapiclient.discovery
import googleapiclient.errors

# Replace with your own API credentials
os.environ["OAUTHLIB_INSECURE_TRANSPORT"] = "1"
api_service_name = "youtube"
api_version = "v3"

client_secrets_file = os.getenv("HOME")+"/personal/keys/YTPlaylist_Secret.json"
credential_file = os.getenv("HOME")+"/personal/keys/YTPlaylist_Credential.json"

# ID of the YouTube playlist you want to convert
playlist_url = sys.argv[1]
id_pos = playlist_url.find("?list=")
if id_pos < 0:
    playlist_id = playlist_url
else:
    playlist_id = playlist_url[id_pos+len('?list='):]

print(f"Extracting playlist id {playlist_id}",file=sys.stderr)

# Load existing credentials (if available)
creds = None
if os.path.exists(credential_file):
    creds = google.oauth2.credentials.Credentials.from_authorized_user_file(credential_file)

# Authorize the API client (using refresh token if available)
if not creds or not creds.valid:
    if creds and creds.expired and creds.refresh_token:
        creds.refresh(google.auth.transport.requests.Request())
    else:
        flow = google_auth_oauthlib.flow.InstalledAppFlow.from_client_secrets_file(
            client_secrets_file, ["https://www.googleapis.com/auth/youtube.readonly"]
        )
        creds = flow.run_local_server()
    # Save credentials for next run
    with open(credential_file, "w") as token:
        token.write(creds.to_json())

youtube = googleapiclient.discovery.build(
    api_service_name, api_version, credentials=creds
)



# # Authorize the API client
# flow = google_auth_oauthlib.flow.InstalledAppFlow.from_client_secrets_file(
#     client_secrets_file, ["https://www.googleapis.com/auth/youtube.readonly"]
# )
# credentials = flow.run_local_server()
# youtube = googleapiclient.discovery.build(
#     api_service_name, api_version, credentials=credentials
# )

# Retrieve playlist title
playlist_request = youtube.playlists().list(
    part="snippet",
    id=playlist_id
)
playlist_response = playlist_request.execute()
playlist_title = playlist_response["items"][0]["snippet"]["title"]

# Retrieve playlist items and save to a text file
next_page_token = ""
f = sys.stdout
f.write(f"#+title: {playlist_title}\n\n")
while True:
    request = youtube.playlistItems().list(
        part="snippet",
        playlistId=playlist_id,
        maxResults=50,
        pageToken=next_page_token,
    )
    response = request.execute()

    for item in response["items"]:
        title = item["snippet"]["title"]
        video_id = item["snippet"]["resourceId"]["videoId"]
        url = f"https://www.youtube.com/watch?v={video_id}"
        description = item["snippet"]["description"]
        f.write(f"* {title}\n\n  url: {url}\n\n")
        f.write(f"{description}\n\n\n")

    next_page_token = response.get("nextPageToken")
    if not next_page_token:
        break
