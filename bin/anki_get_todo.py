#!/usr/bin/env python3

import os
from pathlib import Path
from anki.collection import Collection

def count_scheduled(deck):
    return deck.new_count + deck.learn_count + deck.review_count

if __name__ == "__main__":
    collection_path = os.path.join(Path.home(), ".local/share/Anki2/User 1/collection.anki2")
    collection = Collection(collection_path)
    root = collection.sched.deck_due_tree()
    active_deck, = [c for c in root.children if c.name == "Active"]
    print(count_scheduled(active_deck))
