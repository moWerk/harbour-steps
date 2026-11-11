Steps 0.1.0, the first release: today's steps from the phone's sensor hub, counted in the background, with a daily goal, a history and a top menu ring.

**What it does**
- The count comes from the real step counter: the sensor hub counts (on the Jolla Phone 2026 the MediaTek SCP), also while the phone sleeps, and sensorfw's step counter sensor delivers it. No accelerometer polling, no running app needed.
- `sensorlogd` (Arseniy Movshev's AsteroidOS step logger, built for Sailfish OS) keeps the counter open and logs each day; it starts with the user session.
- The app: the count inside a goal ring, the goal from 5 000 to 20 000 in steps of 1 000, the last 30 days with a goal bar, a cover with the ring.
- Top menu: a "Steps" item (Settings > Top menu) with the count in its goal ring, laid out like the stock toggles; a tap opens the app.
- The day closes at 00:00 (and at the first wake after it), so the count starts from zero every day; app, cover and top menu read the same live number from the moment they start.

**Install**
Both RPMs, `sensorlogd` first: `pkcon install-local` as root, or Storeman from a local file. The package enables sensorfw's step counter (`/etc/sensorfw/sensord.conf.d/90-harbour-steps.conf`) and restarts sensorfwd once. Reboot after installing both (the daemon starts with the user session, the top menu entry with lipstick), then add "Steps" in Settings > Top menu.

**Needs**
Sailfish OS 5.x, aarch64, and an Android HAL with a step counter. Tested on the Jolla Phone 2026 (5.2.0.22) only, for one day so far: the daemon's first day change is still ahead of it. A device without a HAL step counter gets an app that stays at zero.

**Authorship**
Written by an LLM (Claude), directed and tested by the author on a Jolla Phone 2026. Each commit carries an LLMGD disclosure line (github.com/moWerk/llmgd-specs). sensorlogd is GPL-3.0-or-later by Arseniy Movshev (dodoradio); its Sailfish OS packaging (upstream tree plus two patches) is the sensorlogd/ directory of this repository.
