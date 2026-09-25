---
name: storyboard-pipeline
description: Turn a live talk-through or a concepting-call transcript into a client-presentable, dark-themed Shot Board — a precise shot-by-shot breakdown with real AI-generated video for every shot. Use when asked to build a storyboard, previz a commercial/spot from a conversation, "turn this into shots," or produce a shot-by-shot dashboard with generated video. Also triggers on "shot board," "animate this scene," "storyboard skill."
---

# Storyboard Pipeline

Built the first time on the Sacramento spot session, 2026-09-25. That session is
the source of every gotcha below — read them, they cost real time to learn once.

## The actual differentiator — read this first

Script-to-shot-breakdown (a formatted screenplay in, AI-illustrated panels out)
is already commodity-solved elsewhere (LTX Studio, Katalist AI, Toon Boom Ember).
Per-shot image/video generation is commodity-solved (Nano Banana, Veo). **What
nobody does well is taking a raw, unstructured, multi-speaker conversation —
tangents, "what if we cut to...", half-finished thoughts — and inferring the
*precise* number and boundary of shots a team implicitly agreed on.** That
inference is this skill's job and its actual value. Everything else (stills,
video, the dashboard) is gluing together parts that already exist.

## Live session vs. transcript-driven — ask differently

- **Live** (voice or live chat, someone is right there to answer): the moment
  style/visual-direction language comes up (a color grade description, a
  reference show, "make it feel like X"), **stop and ask 2-4 tight clarifying
  questions before folding it into generation prompts.** Don't let momentum
  carry a vague description into five separate shot prompts as boilerplate —
  that produces weak, drifting consistency instead of a real locked look.
  Confirmed the hard way: skipped this once under "just show me" pressure and
  the result was noticeably inconsistent grade shot to shot.
- **Transcript-driven** (processing something already recorded, nobody to
  ask): infer the style lock from what's actually said rather than stalling
  on a question nobody can answer. The live-session rule does not apply here.

## Pipeline stages

### 1. Capture the brief

Read or listen for what actually carries shot information — camera framing,
action, duration/pacing cues, audio direction. A live rambling talk-through
condenses down to a handful of real sentences; keep those verbatim in the
Transcript panel (see template) so the source is auditable, not paraphrased
away.

### 2. Build the Shot List — Checkpoint 1, review before spending anything

For each shot, capture: shot size (WS/MS/MCU/CU/ECU/INSERT/OTS), camera move,
duration, one-line action, audio/Foley/VO note.

- **Durations**: if the brief describes pacing musically ("two dribbles on
  beat one") rather than in seconds, say so explicitly on the card — don't
  invent false clock precision. Flag it as an estimate to confirm against the
  final track/edit.
- **Ambiguity gets a visible ⚠ on the card**, not a silent guess. Location
  choices, cast identity, anything genuinely undecided — flag it, propose your
  best candidate with reasoning, and let the human resolve it in a follow-up.
  Remove the flag once confirmed; don't leave stale warnings on the board.
- **Research real facts, don't guess from training data** — current
  officeholders, real business names, real landmarks. A person's *title* can
  be stale even when their name isn't (an "interim" appointment, a recent
  election) — search for it live rather than asserting it.
- **Real, named people in the brief — this is a standing check, not a
  one-time question.** The moment a shot depicts an actual identifiable
  person (a public official, a named business owner), stop and ask how to
  handle it before generating anything:
  1. **Generic stand-in** (recommended default) — a "police chief type," not
     an attempt at the real person's face. Safe for internal pitch decks.
  2. **Attempt real likeness from public photos** — real right-of-publicity
     and implied-endorsement exposure, especially for public officials in a
     commercial. Only do this if the human explicitly says so *knowing the
     tradeoff* — state it plainly, don't bury it in a footnote.
  3. Skip the shot's real-person element entirely for now.
  Re-ask for each *new* real person who enters the brief — a decision on one
  person is not a standing policy for the next one, unless the human says so.

### 3. Style Lock — the step that's easy to skip under momentum

Proper Style Lock: generate **one reference image**, get explicit sign-off,
then condition every subsequent generation against *that actual image* (not
a repeated text description) for real cross-shot consistency. Text-repeated
"log-leaning color grade, rich saturation..." across five separate prompts is
much weaker than image-conditioning — the grade will visibly drift shot to
shot. If time pressure means skipping the real reference-image pass, ship the
result labeled "prompt-only consistency, not locked" on the board (see the
banner pattern in the template) rather than presenting it as final.

Ask (live sessions only, see above): aspect ratio, a specific film/show to
anchor the look to (much stronger than a text description alone), grain
intensity, any brand colors that must survive the grade untouched.

### 4. Generate stills

Model: **Nano Banana 2** (via the Gemini app or Google Flow — same underlying
model either way). Real people render as explicitly-labeled generic stand-ins
per the Checkpoint 2 decision above.

Mechanics, Google Flow specifically:
- The plain text composer generates a **still**, not a video, by default —
  there is no separate "just generate video from text" shortcut in the main
  composer. Animation is always a second, explicit step (see below).
- Google Flow shows a first-time multi-slide privacy/tour dialog with a
  "Continue" button that stays disabled until you scroll its text pane to the
  bottom — scroll before clicking, or it silently does nothing.
- A gallery template card can get accidentally attached to the prompt
  composer from a stray click — check for it (a small thumbnail chip above
  the text box) and remove it via its own X button before submitting, or it
  contaminates the generation.

### 5. Animate — turn a still into video

**Model choice matters a lot and is not the default.** In Flow's Agent
Settings (the slider icon near the composer), the video model defaults to
**Veo 3.1 Lite**. Switch it to **Omni 1.1 Flash**:

| Model | Cost | Minimum duration |
|---|---|---|
| Veo 3.1 Lite (default) | 10 credits | 10s floor |
| Omni 1.1 Flash | 7 credits | 4s floor |

Omni Flash is both cheaper and has a shorter floor — always prefer it unless
quality specifically demands Veo. **Neither model can generate a custom short
duration** (e.g. a native 2.2s clip) — 4s is the real floor even on the
cheapest/fastest model. Every generation gets trimmed down afterward (stage
6), never generated-to-length.

Mechanics:
1. Hover the still's thumbnail → the "⋯ More" menu → **Animate**. This
   auto-attaches the image as a reference in the composer.
2. If you `Reject` a pending generation and re-submit with a change, **the
   reference image does not persist** — re-attach it via the `+` → search
   your existing media before resubmitting, or the new generation loses the
   connection to the approved still.
3. Type a *motion-only* prompt (what moves, not what the scene looks like —
   that's already in the reference image).
4. Flow will state the exact credit cost and ask for approval
   ("Would you like me to kick off this video generation, costing N
   credits?"). **Always wait for and read this. Never pre-approve ("Always
   approve") without being asked to** — this is a real, metered spend each
   time, same as any other cost-gated generation.
5. Generations can sit in a "scheduled, waiting in queue due to high demand"
   state for 10-30+ seconds beyond the initial render — this is normal, not
   a failure; use the wait productively by starting the *next* shot's still
   generation in parallel rather than blocking on one at a time.
6. Downloads a `.zip` containing one `.mp4` (not a direct file) — unzip it
   before use.

### 6. Trim to the real spec

Every generated clip is longer than the shot actually needs (4-10s vs. a
typical 2-2.5s cut). Use `scripts/trim_clip.sh`:

```bash
# Look at the motion arc first — never blind-chop
trim_clip.sh sheet raw_clip.mp4 contact_sheet.jpg 8
# Read contact_sheet.jpg. Most generations have uniform/continuous motion
# throughout, so a front-loaded trim (start_offset 0) is usually right — but
# check for a dead/idle middle section before assuming that.
trim_clip.sh trim raw_clip.mp4 final_2.2s.mp4 2.2
```

Re-encodes (not stream-copy) so the cut lands frame-accurate rather than
snapping to the nearest keyframe.

### 7. Wire into the dashboard

Start from `templates/shot-board-template.html` for a new project (copy it,
don't rebuild the mechanics from scratch — the tabs, video/image/placeholder
priority rendering, and pipeline tracker are all already solved there).

- Requires the artifact's `assets` capability declared once:
  `capabilities: {assets: {}}` on first publish.
- Upload stills/videos via `upload_asset` (batch multiple files in one call
  with `file_paths` when uploading several at once).
- Each shot's data row is
  `[size, move, duration, action, audio, imgUrl?, videoUrl?]` — `imgUrl`/
  `videoUrl` are the `/_blob/...` URLs the upload returns. Card rendering
  priority is **video > image > gray placeholder**.
- Video tags: `autoplay loop muted playsinline` — this is what gives the
  "always moving, like a GIF" feel the dashboard is for.
- Update the banner text and the pipeline tracker stage states *every time*
  something real changes — a stale "SAMPLE DATA" banner sitting over real
  generated content, or vice versa, is a real trust problem for whoever's
  looking at the board next.
- Republish to the **same artifact URL** (pass `url:` on every subsequent
  publish) so the link stays stable across a whole working session — never
  let a re-publish accidentally create a second, separate artifact.

## Cost reality (verified 2026-09-25, will drift — re-verify live rather than trust this table blindly)

- Google Workspace's "AI Expanded Access" add-on (~$24/mo, ~$16.80 promo):
  **not worth it just to raise a daily video cap** — the math on Omni Flash's
  actual per-shot cost (7 credits) means the free daily allowance already
  covers a full scene; the paid tier's real unlock is model access (Nano
  Banana Pro, Gemini 3), not volume.
- The Gemini app's native video tool ("Create video") has its own **separate,
  much smaller daily cap** (hit a wall after 2 generations in testing) from
  Flow's credit system. If the Gemini app says "you've reached your video
  generation limit," **switch to Google Flow** — it's a different quota pool
  even though both ultimately call the same underlying models.
- Free Flow credits: 50/day baseline, no subscription required, refreshes
  daily, plus a monthly bonus tied to any paid tier. At 7 credits/generation
  on Omni Flash, that's ~7 free video generations/day with zero subscription.

## What this skill does not do (yet)

- No true multi-scene batching — each scene still goes through the full live
  conversation → shot list → generate → trim cycle. A full multi-scene spot
  in one sitting is a time constraint, not (currently) a technical one.
- No scripted/API-driven generation — everything above is browser-automation
  driven (Gemini app / Google Flow web UIs) because neither has a usable
  consumer-tier scripted path yet for this cost profile. If that changes,
  revisit — a scripted pipeline would remove the browser-automation gotchas
  in stage 4-5 entirely.
- Style Lock's real reference-image-conditioning mode has been described but
  not yet actually run end-to-end — the Sacramento session shipped with
  prompt-only consistency instead. First real run of this skill should try
  the full reference-conditioned Style Lock and update this doc with what
  actually happens.
