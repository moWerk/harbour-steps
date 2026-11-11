# Steps

A step counter for Sailfish OS: today's steps inside a goal ring, the daily goal
(5 000 to 20 000 in steps of 1 000), the last weeks as a list, a cover, and a top
menu item that shows the count with its goal ring.

The app does not count. The phone's sensor hub does (through sensorfw's step counter
sensor), and [sensorlogd](https://github.com/AsteroidOS/asteroid-sensorlogd) by Arseniy
Movshev, ported to sensorfw, keeps the counter open and logs each day. Steps reads
the daemon's log and the live count from its QML module `org.asteroid.sensorlogd`.

Needs `sensorlogd` (the Sailfish OS build; its packaging is the `sensorlogd/` directory
of this repository, upstream tree plus two patches, RPM attached to the releases) and a
device whose Android HAL has a step counter. The package ships
`/etc/sensorfw/sensord.conf.d/90-harbour-steps.conf`, which switches sensorfw's step
counter sensor on through the hybris adaptor, and restarts sensorfwd once on install.
Whether the HAL has one: as root,
`/system/bin/dumpsys android.hardware.sensors.ISensors/default | grep -i step` on an AIDL
HAL, `lshal debug android.hardware.sensors@2.1::ISensors/default` on a HIDL one. First
used on the Jolla Phone 2026, whose MediaTek SCP hub counts while the phone sleeps and
hands the count over in batches.

Top menu: Settings > Top menu > add "Steps". A tap on the ring opens the app. The item is
installed as `/usr/share/jolla-settings/entries/harbour-steps-topmenu.json`; lipstick picks
it up at its next start.

Because of the daemon and the top menu entry the package is for Chum and OpenRepos, not
the Jolla Store, and the app runs without the sandbox (the log is in the daemon's
directory).

## Authorship

Written by an LLM (Claude), directed and tested by the author on a Jolla Phone 2026.
Every commit carries an LLMGD disclosure line; the grading scheme is described at
[moWerk/llmgd-specs](https://github.com/moWerk/llmgd-specs).

## Licence

GPL-3.0-or-later.
