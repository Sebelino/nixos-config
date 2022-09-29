#!/usr/bin/env python3

import sys
import csv
import yaml

def validate_table(table):
    for row in table[1:]:
        if row[4] != "minute":
            raise NotImplementedError("Unexpected unit")

def extract_relevant(row):
    # ['Date',       'Product', 'SKU',              'Quantity', 'Unit Type', 'Price Per Unit ($)', 'Multiplier', 'Owner',    'Repository Slug', 'Username', 'Actions Workflow',                    'Notes']
    # ['2022-09-15', 'Actions', 'Compute - UBUNTU', '5',        'minute',    '0.008',              '1.0',        'Sebelino', 'nixos-config',    'Sebelino', '.github/workflows/pull-request.yaml', '']
    (
        date,
        product,
        sku,
        quantity,
        unit_type,
        price_per_unit,
        multiplier,
        owner,
        repository_slug,
        username,
        actions_workflow,
        notes,
    ) = row
    return dict(
        date=date,
        quantity=quantity,
        repository_slug=repository_slug,
        username=username,
        actions_workflow=actions_workflow,
    )

def by_date(content):
    date2result = dict()
    for entry in content:
        date = entry["date"]
        date2result[date] = date2result.get(date, []) + [dict((k, v) for k, v in entry.items() if k != "date")]
    return date2result

def aggregate(date2result):
    aggregation = dict()
    for date, result_list in date2result.items():
        new_result = aggregate_result(result_list)
        aggregation[date] = new_result
    return aggregation

def aggregate_result(result_list):
    new_result = {
        "total": 0,
        "repositories": dict(),
    }
    for result in result_list:
        quantity = result["quantity"]
        new_result["total"] += int(quantity)
        user = result["username"]
        repo = result["repository_slug"]
        workflow = result["actions_workflow"]
        add_for_repo(new_result["repositories"], repo, workflow, user, quantity)
    return new_result

def add_for_repo(repos, repo, workflow, user, quantity):
    if repo not in repos:
        repos[repo] = dict()
    subject = f'{user}@{workflow}'
    repos[repo][subject] = int(quantity)

def print_bill(result):
    print(yaml.dump(result))

if __name__ == "__main__":
    with open(sys.argv[1], 'r') as csvfile:
        reader = csv.reader(csvfile)
        table = [row for row in reader]
    validate_table(table)
    table = table[1:]
    content = [extract_relevant(row) for row in table]
    date2result = by_date(content)
    aggregation = aggregate(date2result)
    print_bill(aggregation)
