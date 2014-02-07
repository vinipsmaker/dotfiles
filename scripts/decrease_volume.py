#!/usr/bin/env python

import subprocess as sub
import re
from gi.repository import Notify
import time

output = sub.check_output(["ponymix", "decrease", "5%"])
volume = re.search('\\d+', str(output)).group()

Notify.init("PulseAudio")
msg = Notify.Notification.new("Volume decreased", volume + '%', "/usr/share/icons/gnome/scalable/devices/audio-speakers-symbolic.svg")
msg.show()
time.sleep(0.75)
msg.close()
