import numpy as np
import sys

from typing import Tuple

N = 50_000
MAX_PRICE = 10**5
MAX_QUANTITY = 10**9
MAX_LEVELS = 400
MAX_SHARES = 10**9

FILENAME = 'input.txt'

def generate_snapshot() -> Tuple[dict, int]:
    new_active_n = np.random.randint(1, MAX_LEVELS)
    new_prices = np.random.choice(MAX_PRICE-1, new_active_n, replace=False)+1
    quantities = np.random.randint(1, MAX_QUANTITY+1, new_active_n)
    new_snapshot = dict(zip(new_prices, quantities))
    return new_snapshot, quantities.sum()

def get_update(old_snapshot: dict, new_snapshot: dict) -> dict:
    update = new_snapshot.copy()
    for p in old_snapshot:
        if p not in new_snapshot:
            update[p] = 0
        else:
            if update[p] == old_snapshot[p]:
                update.pop(p)
    return update
   
def generate_test(filename: str):
    with open(filename, 'w+') as f:
        total_shares = 0
        f.write(f'{N}\n')
        old_snapshot = {}
        new_snapshot = {}

        for row_i in range(N):
            new_snapshot, total_shares = generate_snapshot()
            # assert(total_shares <= 2*10**9)
            update = get_update(old_snapshot, new_snapshot)

            f.write(f'{len(update)}\n')
            items = list(update.items())
            items.sort()

            for p, q in items:
                f.write(f'{p} {q}\n')

            shares = np.random.randint(1, min([total_shares+1, MAX_SHARES]))
            f.write(f'{shares}\n')
            assert(len(new_snapshot) <= MAX_LEVELS)
            old_snapshot = new_snapshot
if __name__ == '__main__':
    if len(sys.argv) == 1:
        print(f"Usage: {sys.argv[0]} FILENAME1 FILENAME2 ...")
    else:
        for i in range(1, len(sys.argv)):
            generate_test(sys.argv[i])

