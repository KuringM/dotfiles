#!/bin/bash

# get NOTE ID
NOTE_ID="$1"

# Fetch front field
curl -s localhost:8765 -X POST -d "{
  \"action\": \"notesInfo\",
  \"version\": 6,
  \"params\": { \"notes\": [$NOTE_ID] }
}"

# Convert md to html
lua convert_md_to_html.lua front.md

# Read back edited content
UPDATED_FRONT=$(<front.html)

# Push update
jq -n --arg id "$NOTE_ID" --arg front "$UPDATED_FRONT" '{
  action: "updateNoteFields",
  version: 6,
  params: {
    note: {
      id: ($id | tonumber),
      fields: {
        Front: $front
      }
    }
  }
}' | curl -s localhost:8765 -X POST -d @- | jq
