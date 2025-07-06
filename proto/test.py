import updates_pb2

update = updates_pb2.Update()
update.price = 10
update.quantity = 1

update_row = updates_pb2.UpdateRow()
update_row.row.extend([update])

updates = updates_pb2.Updates()
updates.data.extend([update_row])

import struct
with open('input', 'wb') as f:
    f.write(updates.SerializeToString())

