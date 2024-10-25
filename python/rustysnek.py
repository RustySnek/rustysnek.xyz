import time


def sleepy_constrictor(name: bytes, amount: bytes):
    time.sleep(int(amount))
    return f"{name.decode()} Returned!".encode("utf-8")
