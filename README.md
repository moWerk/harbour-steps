# Steps

A step counter for Sailfish OS: today's steps inside a goal ring, the daily goal
(5 000 to 20 000 in steps of 1 000), the last weeks as a list, a cover, and a top
menu item that shows the count with its goal ring.

The app does not count. The phone's sensor hub does (through sensorfw's step counter
sensor), and [sensorlogd](https://github.com/AsteroidOS/asteroid-sensorlogd) by Arseniy
Movshev, ported to sensorfw, keeps the counter open and logs each day. Steps reads
the daemon's log and the live count from its QML module `org.asteroid.sensorlogd`.

Needs: `sensorlogd` (the Sailfish OS build), and a device whose sensorfw has a step
counter adaptor enabled (`stepcountersensor=True` in `/etc/sensorfw/sensord.conf.d/`,
`stepcounteradaptor = hybrisstepcounteradaptor` on hybris devices with an Android HAL
step counter). First used on the Jolla Phone 2026 (MediaTek SCP hub).

Top menu: Settings > Top menu > add "Steps". The item is installed as
`/usr/share/jolla-settings/entries/harbour-steps-topmenu.json`; lipstick picks it up at
its next start.

Because of the daemon and the top menu entry the package is for Chum and OpenRepos, not
the Jolla Store, and the app runs without the sandbox (the log is in the daemon's
directory).

## Authorship

Written by an LLM (Claude), directed and tested by the author on a Jolla Phone 2026.
Every commit carries an LLMGD disclosure line; the grading scheme is described at
[moWerk/llmgd-specs](https://github.com/moWerk/llmgd-specs).

## Licence

GPL-3.0-or-later.
