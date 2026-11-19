from pydantic import ValidationError
from contract import Machine

# valid row
print(Machine(machine_id=1, serial_no="SN-88120", site="Gütersloh", installed="2019-03-11"))

# the legacy bad row: installed = 'unknown'
try:
    Machine(machine_id=4, serial_no="SN-90000", site="Gütersloh", installed="unknown")
except ValidationError as e:
    print("Rejected:", e.errors()[0]["msg"])

# bad serial prefix
try:
    Machine(machine_id=5, serial_no="XX-123", site="Bielefeld", installed="2021-07-02")
except ValidationError as e:
    print("Rejected:", e.errors()[0]["msg"])