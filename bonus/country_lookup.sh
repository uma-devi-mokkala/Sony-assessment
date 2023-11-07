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
     if [ "$country_name" = "null" ]; then
        country_name="Invalid country code"
     fi
     echo "Country code: $country_code, Country Name: $country_name"
}
# Function to check the service health
check_health() {
    echo "Service is healthy"
}

# Function to check the API status
check_api_status() {
    api_status=$(curl -s "https://www.travel-advisory.info/api")
    if [ $? -eq 0 ]; then
        echo "API status: $api_status"
    else
        echo "API status: Service unavailable"
    fi
}

# Function to convert country name to country code
convert_country_name() {
    # Ensure the data file exists or fetch it
    if [ ! -f "$LOCAL_DATA_FILE" ]; then
        fetch_data
    fi
    # Loop through the provided country codes and lookup their names
    for country_code in "${@:2}"; do
        lookup_country "$country_code"
    done
}

# Main script
case "$1" in
    /health)
        check_health
        ;;
    /diag)
        check_api_status
        ;;
    /convert)
        country_code="$2"
        if [ -z "$country_code" ]; then
            echo "Usage: $0 /convert <country_code>"
            exit 1
        fi
        convert_country_name "$@" #"$country_code"
        ;;
    *)
        echo "Usage: $0 {/health|/diag|/convert}"
        exit 1
esac
