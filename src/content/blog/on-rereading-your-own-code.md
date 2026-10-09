---
title: 'On Rereading Your Own Code'
description: 'We treat writing code as the skill and reading it as the cost. Six months later your own code reads like a stranger wrote it — that is precisely the opportunity.'
pubDate: 'Sep 03 2026'
tags: ['reading', 'craft']
featured: false
heroImage: '../../assets/covers/rereading-code.jpg'
heroAlt: 'Concentric pencil circles layered like a palimpsest, one filled in terracotta'
---

Every working programmer knows the feeling: you open a file you wrote six months ago and it reads like a stranger's code. The variable names are halfway reasonable. The structure has a logic you can almost reconstruct. Whoever wrote this was thinking about something you no longer remember.

The standard response is mild embarrassment and a quick refactor. But the distance between you and your past code is not a defect — it is the single best instrument you own for measuring how much you have learned.

## The stranger review

Code review culture assumes an external reader: a teammate, a reviewer, a static analyzer. Rereading your own code supplies something rarer — a reviewer who shares your context but not your memory. You know what the code was *supposed* to do. You no longer know why it does it that way. That gap is exactly where the interesting questions live:

- Does the code explain itself, or did it rely on context that evaporated?
- Which parts still read cleanly — and what made them durable?
- Where did you paper over confusion with a comment instead of a better name?

> If you can't understand your own code after six months, neither can anyone else. The difference is that everyone else was never going to understand it in the first place.

The pattern that survives the stranger review is almost always the same: *plain structure, boring names, explicit intent*. The clever parts — the abstraction that felt elegant at 1 a.m. — are precisely the parts that age into riddles.

## Reading is the training data

We spend our careers writing code and almost none of it practicing reading. Yet the ratio of reading to writing in real work is something like ten to one — every fix, every feature, every review starts with comprehension. Writers know this instinctively: you cannot write well without reading enormously. Programmers somehow believe they can.

The practice is cheap. Once a month, pick a file you wrote a year ago — not the one you're ashamed of, a *normal* one — and read it like a manuscript. Don't fix anything on the first pass. Just mark, in the margin, where you stumbled.

## Layers of the palimpsest

A palimpsest is a manuscript that has been scraped and overwritten, the old text ghosting through the new. Every long-lived codebase is one: the original design is still faintly legible under the accumulated revisions, if you know how to read for it.

Rereading teaches you to write for that future reading — to leave the next layer clean enough that the ghost beneath still shows through. It is the closest thing our craft has to revision, and revision, not writing, is where prose gets good.

Your old code is the cheapest writing teacher you will ever hire. All it asks is that you come back and read.
