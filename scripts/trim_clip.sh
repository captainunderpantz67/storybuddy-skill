#!/bin/bash
# Storyboard pipeline: inspect and trim a raw AI-generated video clip down to
# its real shot duration. Every generation runs at the model's floor length
# (4s on Omni Flash, 10s on Veo 3.1 Lite) — never ship that raw length as a
# shot card video. Always look at the motion arc before picking an in-point;
# some clips have a dead/idle middle that shouldn't be included.
#
# Usage:
#   trim_clip.sh sheet <input.mp4> <output.jpg> [num_frames]
#     Builds a contact sheet (evenly spaced frames across the whole clip) so
#     you can see the actual motion arc before deciding where to cut.
#     Read the output with the Read tool. Default num_frames: 8.
#
#   trim_clip.sh trim <input.mp4> <output.mp4> <duration> [start_offset]
#     Re-encodes (not stream-copy) so the cut point is frame-accurate rather
#     than snapping to the nearest keyframe. duration and start_offset are in
#     seconds, e.g. 2.2. start_offset defaults to 0 (front-loaded — the right
#     default when the clip's motion is uniform/continuous throughout).
#
# Example: chief steps out of a cruiser, 4s raw generation, real shot is 2.2s
#   trim_clip.sh sheet chief_raw.mp4 chief_sheet.jpg 8
#   # ...look at chief_sheet.jpg, decide the action completes by ~2.2s...
#   trim_clip.sh trim chief_raw.mp4 chief_2.2s.mp4 2.2

set -euo pipefail

cmd="${1:-}"

case "$cmd" in
  sheet)
    input="$2"
    output="$3"
    n="${4:-8}"
    duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$input")
    # fps chosen so n frames span the full clip: n frames / duration seconds
    fps=$(python3 -c "print(${n} / ${duration})")
    ffmpeg -y -i "$input" -vf "fps=${fps},scale=200:-1,tile=${n}x1" -frames:v 1 "$output"
    echo "Contact sheet ($n frames across ${duration}s) written to $output — read it before picking a trim window."
    ;;

  trim)
    input="$2"
    output="$3"
    duration="$4"
    start="${5:-0}"
    ffmpeg -y -ss "$start" -i "$input" -t "$duration" -c:v libx264 -crf 18 -preset fast -c:a aac "$output"
    actual=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$output")
    echo "Trimmed to ${actual}s (requested ${duration}s from offset ${start}s) — written to $output"
    ;;

  *)
    echo "Usage:"
    echo "  $0 sheet <input.mp4> <output.jpg> [num_frames]"
    echo "  $0 trim <input.mp4> <output.mp4> <duration> [start_offset]"
    exit 1
    ;;
esac
