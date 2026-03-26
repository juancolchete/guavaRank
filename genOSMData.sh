touch merchant.md
AREA=3600059470
API_URL=https://overpass-api.de/api/interpreter
FILTER='.elements[] | "## \(.tags.name // "Unnamed Location")\n**Type:** \(.type)\n**ID:** \(.id)\n**Coordinates:** \(.lat), \(.lon)\n" + ([.tags["addr:street"], .tags["addr:housenumber"], .tags["addr:suburb"], .tags["addr:city"], .tags["addr:postcode"]] | map(select(. != null and . != "")) | join(", ") | if . != "" then "**Address:** " + . + "\n" else "" end) + "**Details:**\n" + (.tags | to_entries | map("- **\(.key):** \(.value)") | join("\n"))  + "\n\n**OpenStreetMap:** [View on OSM](https://www.openstreetmap.org/node/\(.id)) \n"'
curl --location \
$API_URL \
--header 'Content-Type:text/plain' \
--data '[out:json][timeout:180];area('$AREA')->.brazil;(node['$1'](area.brazil););out body;>;out skel qt;' > merchant.json  
jq -r $(echo -r $FILTER) merchant.json > merchant.md

