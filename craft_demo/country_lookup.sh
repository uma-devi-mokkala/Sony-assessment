#!/bin/bash

# Define the API endpoint and the local data file
API_URL="https://www.travel-advisory.info/api"
LOCAL_DATA_FILE="data.json"

# Function to fetch data from the API and save it to a local file
fetch_data() {
     curl -s "$API_URL" > "$LOCAL_DATA_FILE"
}

# Function to lookup country names by country code
lookup_country() {
     local country_code="$1"
     local country_name=$(jq -r ".data[\"$country_code\"].name" "$LOCAL_DATA_FILE")
     echo "$country_name"
}

# Ensure the data file exists or fetch it
if [ ! -f "$LOCAL_DATA_FILE" ]; then
     fetch_data
fi

# Command line arguments
while [ $# -gt 0 ]; do
    case "$1" in
        --countryCode)
          for country_code in "${@:2}"; do
            lookup_country "$country_code"
          done
            exit 0
            ;;
        *)
            echo "Usage: $0 --countryCode <COUNTRY_CODE>"
            exit 1
            ;;
    esac
done

