#!/usr/bin/env python3

import os
import sys
from anki.storage import Collection
from datetime import datetime, timezone

# 1. Point this at your Anki collection file on Linux:
#    Usually ~/.local/share/Anki2/<profile>/collection.anki2
COL_PATH = os.path.expanduser("~/.local/share/Anki2/User 1/collection.anki2")

# 2. Open the collection
col = Collection(COL_PATH)

# 3. Lookup the deck ID by its full name
deck_name = "Active::Academic::CIMIMS::Theoretical questions"
deck_id = col.decks.id(deck_name)
if not deck_id:
    print(f"Deck not found: {deck_name}", file=sys.stderr)
    sys.exit(1)

# 4. Query for all card IDs in that deck, ordered by creation time
rows = col.db.execute(
    "SELECT id FROM cards WHERE did = ? ORDER BY id",
    deck_id
)

# 5. Print them out
print(f"Cards in deck “{deck_name}” sorted by creation date:\n")
for (cid,) in rows:
    card = col.get_card(cid)
    note = card.note()

    nt = note.note_type()
    note_id = ""
    for fld_def, val in zip(nt['flds'], note.fields):
        if fld_def['name'] == "Note ID":
            note_id = val
            break

    ts_seconds = cid / 1000.0
    created = datetime.fromtimestamp(ts_seconds, timezone.utc)
    created_str = created.strftime("%Y-%m-%d %H:%M:%S %Z")
    front = note.fields[0]
    print(f"- {created} | Note ID: {note_id}")

# 6. Close the collection
col.close()
