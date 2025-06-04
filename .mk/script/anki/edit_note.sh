#!/bin/bash
NOTE_ID="$1"

# Fetch front field
curl -s localhost:8765 -X POST -d "{
  \"action\": \"notesInfo\",
  \"version\": 6,
  \"params\": { \"notes\": [$NOTE_ID] }
}" | jq -r '.result[0].fields.Front.value' > front.md

# Edit with vim
nvim front.md

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
