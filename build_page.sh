#!/usr/bin/env bash

# Configuration
URL="https://www.tesco.com/fuel_prices/fuel_prices_data.json"
HTML_FILE="index.html"
# Example: Fetching the 'E10' price for the first station in the list
# You can change the filter to match a specific 'site_id' or 'postcode'
TARGET_STATION_INDEX=0
FUEL_TYPE="E10"

echo "Fetching fuel data..."

# 1. Fetch JSON and extract the price using jq
# This path navigates: stations -> specific index -> prices -> specific fuel type
PRICE=$(curl -s "$URL" | jq -r ".stations[$TARGET_STATION_INDEX].prices.$FUEL_TYPE")

# 2. Check if we actually got a price
if [ "$PRICE" == "null" ] || [ -z "$PRICE" ]; then
    echo "Error: Could not retrieve price for $FUEL_TYPE at station index $TARGET_STATION_INDEX"
    exit 1
fi

echo "Found price: £$PRICE. Updating $HTML_FILE..."

# 3. Use sed to replace the placeholder in the HTML file
# We use a backup extension (.bak) for safety; it can be removed if not needed
sed -i.bak "s/###FUEL_PRICE###/$PRICE/g" "$HTML_FILE"

echo "Update complete!"
