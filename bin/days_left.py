#!/usr/bin/env python3

import csv
import os
import datetime
import subprocess

def days_left(later_str: str):
    now = datetime.date.today()
    later = datetime.datetime.strptime(later_str, "%Y-%m-%d").date()
    return (later - now).days

if __name__ == "__main__":
    notification_seconds = 30
    datafile = os.path.join(os.path.expanduser("~"), ".days_left.sh.csv")
    with open(datafile, "r") as f:
        dates = list(csv.reader(f, delimiter=";"))
    days_left = [(days_left(t), e) for t, e in dates]
    lines = [f"{d: 3} - {c}" for d,c in days_left]; print("\n".join(lines))
    message = "\n".join(lines)
    subprocess.run([
        "notify-send",
        "--urgency=low",
        "--expire-time",
        str(notification_seconds * 1000),
        "Days left",
        message,
    ])
