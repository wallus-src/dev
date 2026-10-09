---
title: 'The Case for Slow Software'
description: 'Speed is the only metric the industry agrees on, and it is quietly ruining the way we build. An argument for software made at the pace of understanding.'
pubDate: 'Oct 08 2026'
tags: ['craft', 'software']
featured: true
heroImage: '../../assets/covers/slow-software.jpg'
heroAlt: 'A ceramic hourglass in terracotta on cream paper'
---

There is a version of the history of software in which every decade is a story about acceleration. Faster compilers, faster networks, faster frameworks, faster releases — and now faster code generation, which promises to remove the last slow thing in the pipeline: the programmer.

It is worth asking what all that speed was *for*. Not whether it made us more productive — it plainly did — but what it did to the shape of the things we produce. Because software, like furniture and like prose, tends to inherit the pace at which it was made.

## Velocity is a design decision

Every codebase carries the fingerprints of its schedule. You can read a file and tell whether it was written in a sprint or a sabbatical. The hurried file is additive: new flags, new special cases, new helpers wrapped around the old helpers it didn't have time to understand. The unhurried file is subtractive: fewer concepts, better names, an interface that feels inevitable in hindsight.

> The most expensive code is not the code that is slow to write. It is the code that is slow to *understand* — because understanding is the thing every future change will have to pay for first.

This is why "move fast" is not actually a technical value. It is a business value wearing a technical costume, and it has a cost that lands precisely where accountants don't look: in the legibility of the system three years from now.

## Slowness is not the opposite of speed

The slow web, the slow food movement, slow thinking — none of these are about doing things lethargically. They are about doing things at the pace at which they can be done *well*. Slow software doesn't mean releases every eighteen months. It means:

- **Refactoring as you go**, not as a separate "debt sprint" that never gets scheduled.
- **Deleting more than you add.** The fastest-growing metric in most codebases should be the number of lines removed per feature.
- **Letting interfaces mature.** An API that sat unchanged for a year was not neglected; it was earning trust.
- **Writing down the why.** A commit message that explains intent is worth more than ten that describe mechanics.

The paradox is that slow practices compound into fast outcomes. A codebase you can hold in your head is a codebase you can change quickly — and keep changing quickly, year after year, while the "fast" team is busy scheduling its third rewrite.

## An hourglass, not a stopwatch

A stopwatch measures elapsed time against an external standard. An hourglass just asks: has enough sand fallen for this? Some changes need an hour of thought. Some need a week of sitting in the back of your mind while you do other things. The skill is not speed; it is knowing which kind of change you're holding.

Slow software is a posture, not a methodology. It is the decision — made daily, cheaply, boringly — to leave the code a little more comprehensible than you found it. Do that for long enough and speed stops being a goal, because it has become a side effect.
