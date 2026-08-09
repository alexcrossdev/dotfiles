#!/usr/bin/env python3

import os
import json
import time
import pyinotify

MOUNT_DIR = "/run/media/alex"
DEFAULT_MOUNT = "/dev/media/alex"

FASTFETCH_CONFIG = os.path.expanduser(
    "~/.config/fastfetch/config.jsonc"
)

def get_mounts():
    if not os.path.exists(MOUNT_DIR):
        return []

    return sorted([
        os.path.join(MOUNT_DIR, entry)
        for entry in os.listdir(MOUNT_DIR)
        if os.path.isdir(os.path.join(MOUNT_DIR, entry))
    ])


def update_fastfetch():
    mounts = get_mounts()

    if not mounts:
        mounts = [DEFAULT_MOUNT]

    if not os.path.exists(FASTFETCH_CONFIG):
        print("Config missing:", FASTFETCH_CONFIG)
        return

    with open(FASTFETCH_CONFIG, "r") as f:
        config = json.load(f)

    found = False

    for module in config.get("modules", []):
        if (
            isinstance(module, dict)
            and module.get("type") == "disk"
            and module.get("keyColor") == "green"
            and "key" not in module
        ):
            module["folders"] = mounts
            found = True
            print("Updated disk module:", mounts)

    if found:
        with open(FASTFETCH_CONFIG, "w") as f:
            json.dump(config, f, indent=2)
    else:
        print("No matching green disk module found")


class MountHandler(pyinotify.ProcessEvent):

    def process_IN_CREATE(self, event):
        update_fastfetch()

    def process_IN_MOVED_TO(self, event):
        update_fastfetch()

    def process_IN_DELETE(self, event):
        update_fastfetch()

    def process_IN_MOVED_FROM(self, event):
        update_fastfetch()


if __name__ == "__main__":
    print("Starting watcher")

    update_fastfetch()

    while not os.path.exists(MOUNT_DIR):
        print("Waiting for", MOUNT_DIR)
        time.sleep(5)

    wm = pyinotify.WatchManager()

    wm.add_watch(
        MOUNT_DIR,
        pyinotify.IN_CREATE |
        pyinotify.IN_MOVED_TO |
        pyinotify.IN_DELETE |
        pyinotify.IN_MOVED_FROM
    )

    notifier = pyinotify.Notifier(
        wm,
        MountHandler()
    )

    print("Watching", MOUNT_DIR)
    notifier.loop()
