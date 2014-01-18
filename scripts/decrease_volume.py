#!/usr/bin/env python

import os
from gi.repository import Notify
import time

os.system("ponymix decrease 5%")

Notify.init("PulseAudio")
msg=Notify.Notification.new("Volume", "Volume decreased", "/usr/share/icons/gnome/scalable/devices/audio-speakers-symbolic.svg")
msg.show()
time.sleep(0.5)
msg.close()
