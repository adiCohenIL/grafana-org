#import json
#import sys
#
## Get the filename from command-line arguments
#if len(sys.argv) != 2:
#    print(json.dumps({"error": "Usage: python read_json.py <filename>"}))
#    sys.exit(1)
#
#filename = sys.argv[1]
#
## Load the JSON file
#try:
#    with open(filename, "r") as f:
#        data = json.load(f)
#    print(json.dumps(data))
#except Exception as e:
#    print(json.dumps({"error": str(e)}))

import json
import sys

if len(sys.argv) != 2:
    print(json.dumps({"error": "Usage: python read_oauth_settings.py <filename>"}))
    sys.exit(1)

filename = sys.argv[1]

try:
    with open(filename, "r") as f:
        data = json.load(f)

    # Access flat key directly
    oauth_settings = data.get("auth.generic_oauth", {})


    # Flatten and stringify all values
    result = {k: str(v) for k, v in oauth_settings.items()}

    print(json.dumps(result))
except Exception as e:
    print(json.dumps({"error": str(e)}))