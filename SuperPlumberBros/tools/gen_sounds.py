#!/usr/bin/env python3
"""Generate chiptune-style WAV sound effects + music loop for Super Plumber Bros.

All sounds are original compositions synthesized with square/triangle waves +
noise, loosely in the spirit of 8-bit platformer audio. No copyrighted samples.
"""
import math
import os
import random
import struct
import wave

SR = 22050  # sample rate
OUT = os.path.join(os.path.dirname(__file__), "..", "SuperPlumberBros", "Resources", "Sounds")
os.makedirs(OUT, exist_ok=True)

random.seed(7)


def midi(n):
    return 440.0 * 2 ** ((n - 69) / 12.0)


def square(t, f, duty=0.5):
    ph = (t * f) % 1.0
    return 1.0 if ph < duty else -1.0


def tri(t, f):
    ph = (t * f) % 1.0
    return 4 * ph - 1 if ph < 0.5 else 3 - 4 * ph


def noise():
    return random.uniform(-1, 1)


def env(t, dur, attack=0.005, release=0.04):
    """Simple linear attack + exponential-ish release envelope."""
    if t < attack:
        return t / attack
    remaining = dur - t
    if remaining < release:
        return max(0.0, remaining / release)
    return 1.0


def render(dur, fn, name, vol=0.5):
    n = int(SR * dur)
    frames = bytearray()
    for i in range(n):
        t = i / SR
        v = fn(t) * env(t, dur) * vol
        v = max(-1.0, min(1.0, v))
        frames += struct.pack("<h", int(v * 32767))
    path = os.path.join(OUT, name + ".wav")
    with wave.open(path, "wb") as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(SR)
        w.writeframes(bytes(frames))
    print("wrote", name)


def sweep(f0, f1, dur, name, duty=0.5, vol=0.5, shape=square):
    def fn(t):
        f = f0 + (f1 - f0) * (t / dur)
        return shape(t, f, duty) if shape == square else shape(t, f)
    render(dur, fn, name, vol)


def arp(notes, note_dur, name, vol=0.5, shape=square, duty=0.5, gap=0.0):
    dur = len(notes) * (note_dur + gap)
    def fn(t):
        idx = min(int(t / (note_dur + gap)), len(notes) - 1)
        return shape(t, midi(notes[idx]), duty) if shape == square else shape(t, midi(notes[idx]))
    render(dur, fn, name, vol)


# --- SFX ---
sweep(300, 900, 0.18, "jump_small", vol=0.35)          # classic rising jump chirp
sweep(220, 700, 0.25, "jump_big", vol=0.35)
arp([95, 100], 0.09, "coin", vol=0.4)                   # B5 -> E6-ish ding
render(0.12, lambda t: noise() * (1 - t / 0.12) + square(t, 120, 0.5) * 0.5, "stomp", vol=0.5)
sweep(180, 60, 0.12, "bump", vol=0.5, shape=tri)
render(0.35, lambda t: noise() * (1 - t / 0.35), "break", vol=0.45)
arp([72, 79, 84, 88, 91, 96], 0.07, "powerup", vol=0.4)
arp([72, 76, 79, 84, 88, 91], 0.06, "grow", vol=0.4)
arp([91, 84, 79, 72], 0.09, "shrink", vol=0.4)
sweep(700, 80, 0.35, "fireball", vol=0.3)
sweep(600, 1400, 0.09, "kick", vol=0.45)
arp([96, 91, 88, 84, 79, 76, 72], 0.05, "oneup", vol=0.4)
arp([84, 79, 76, 72, 67, 64, 60], 0.16, "death", vol=0.4, duty=0.25)
arp([91, 88, 84, 79, 76, 72, 67, 64, 60], 0.07, "flagpole", vol=0.4)
arp([72, 76, 79, 84], 0.12, "gameover", vol=0.4, duty=0.25)
sweep(200, 1200, 0.1, "pause", vol=0.35)

# --- Music loop (original overworld-ish melody, 8 bars) ---
# Melody (midi, duration in beats). Original tune, bouncy major key.
melody = [
    (76, .5), (79, .5), (84, 1), (79, .5), (81, .5), (84, 1),
    (79, .5), (76, .5), (72, 1), (72, .5), (76, .5), (79, 1),
    (77, .5), (79, .5), (81, 1), (81, .5), (79, .5), (77, .5),
    (76, 1), (76, .5), (79, .5), (84, 1), (88, .5), (86, .5), (84, .5),
    (81, 1), (79, .5), (76, .5), (72, 1),
]
bass = [
    (48, .5), (55, .5), (48, .5), (55, .5), (45, .5), (52, .5), (45, .5), (52, .5),
    (41, .5), (48, .5), (41, .5), (48, .5), (43, .5), (50, .5), (43, .5), (50, .5),
    (48, .5), (55, .5), (48, .5), (55, .5), (45, .5), (52, .5), (45, .5), (52, .5),
    (41, .5), (48, .5), (43, .5), (50, .5), (48, .5), (55, .5), (48, .5), (55, .5),
]
BEAT = 0.14  # ~107 bpm *2 (eighth-feel)
total_beats = sum(d for _, d in melody)
dur = total_beats * BEAT


def music_fn(t):
    beat = t / BEAT
    # melody
    acc = 0.0
    m = 60
    for note, d in melody:
        if acc <= beat < acc + d:
            m = note
            break
        acc += d
    lead = square(t, midi(m), 0.5) * 0.30
    # bass
    accb = 0.0
    b = 36
    for note, d in bass:
        if accb <= beat < accb + d:
            b = note
            break
        accb += d
    lo = tri(t, midi(b)) * 0.35
    # hats: short noise tick every beat
    tick = noise() * 0.10 if (beat % 1.0) < 0.08 else 0.0
    return lead + lo + tick


render(dur + 0.05, music_fn, "overworld", vol=0.9)
print("done")
