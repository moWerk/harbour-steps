Steps 0.1.0, the first release: today's steps from the phone's sensor hub, counted in the background, with a daily goal, a history and a top menu ring.

**What it does**
- The count comes from the real step counter: the sensor hub counts (on the Jolla Phone 2026 the MediaTek SCP), also while the phone sleeps, and sensorfw's step counter sensor delivers it. No accelerometer polling, no running app needed.
- `sensorlogd` (Arseniy Movshev's AsteroidOS step logger, built for Sailfish OS) keeps the counter open and logs each day; it starts with the user session.
- The app: the count inside a goal ring, the goal from 5 000 to 20 000 in steps of 1 000, the last 30 days with a goal bar, a cover with the ring.
- Top menu: a "Steps" item (Settings > Top menu) with the count in its goal ring, laid out like the stock toggles.

**Install**
Both RPMs, `sensorlogd` first: `pkcon install-local` as root, or Storeman from a local file. The package enables sensorfw's step counter (`/etc/sensorfw/sensord.conf.d/90-harbour-steps.conf`) and restarts sensorfwd once. Then add "Steps" in Settings > Top menu; the item appears after the next lipstick start (a reboot does it).

**Needs**
Sailfish OS 5.x, aarch64, and an Android HAL with a step counter. Tested on the Jolla Phone 2026 (5.2.0.22) only. A device without a HAL step counter gets an app that stays at zero.

**Authorship**
Written by an LLM (Claude), directed and tested by the author on a Jolla Phone 2026. Each commit carries an LLMGD disclosure line (github.com/moWerk/llmgd-specs). sensorlogd is GPL-3.0-or-later by Arseniy Movshev (dodoradio); the Sailfish OS port of it lives in the sailfishos-pro1x-mainline repository, packages/sensorlogd.
