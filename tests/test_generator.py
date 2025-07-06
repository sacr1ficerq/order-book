import numpy as np
import sys

from typing import Tuple, List

import updates_pb2 as proto

N = 5_000
MAX_PRICE = 10**5
MAX_QUANTITY = 10**9
MAX_LEVELS = 400
MAX_SHARES = 10**9

DEBUG = 0

# N = 5
# MAX_PRICE = 10
# MAX_QUANTITY = 100
# MAX_LEVELS = 4
# MAX_SHARES = 10

FILENAME = 'input.txt'

def generate_snapshot() -> Tuple[dict, int]:
    new_active_n = np.random.randint(1, MAX_LEVELS)
    new_prices = np.random.choice(MAX_PRICE-1, new_active_n, replace=False)+1
    quantities = np.random.randint(1, MAX_QUANTITY+1, new_active_n)
    new_snapshot = dict(zip(new_prices, quantities))
    return new_snapshot, quantities.sum()

def get_update_row(old_snapshot: dict, new_snapshot: dict) -> proto.UpdateRow:
    update_dict = new_snapshot.copy()
    for p in old_snapshot:
        if p not in new_snapshot:
            update_dict[p] = 0
        else:
            if update_dict[p] == old_snapshot[p]:
                update_dict.pop(p)
    
    row = []
    temp = sorted(update_dict.items())
    if DEBUG: print(len(temp))
    for p, q in temp:
        u = proto.Update()
        u.price = p
        u.quantity = q
        if DEBUG:
            print(u.price, u.quantity)
        row.append(u)
    return row

def generate_update(old_snapshot: dict, updates: proto.Updates) -> dict:
    result = proto.UpdateRowWithShares()
    new_snapshot, total_shares = generate_snapshot()
    assert(len(new_snapshot) <= MAX_LEVELS)

    result.row.data.extend(get_update_row(old_snapshot, new_snapshot))
    result.shares = np.random.randint(1, min([total_shares+1, MAX_SHARES]))
    if DEBUG: print('Shares:', result.shares)

    updates.data.extend([result])
    return new_snapshot


def generate_test() -> proto.Updates:
    total_shares = 0
    old_snapshot = {}
    updates = proto.Updates()

    for row_i in range(N):
        new_snapshot = generate_update(old_snapshot, updates)
        old_snapshot = new_snapshot

    return updates

def save(test_data: proto.Updates, filename: str):
    with open(filename, 'wb+') as f:
        f.write(test_data.SerializeToString())

if __name__ == '__main__':
    if len(sys.argv) == 1:
        print(f"Usage: {sys.argv[0]} FILENAME1 FILENAME2 ...")
    else:
        for i in range(1, len(sys.argv)):
            updates = generate_test()
            save(updates, sys.argv[i])

