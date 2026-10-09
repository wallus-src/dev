---
title: 'What a Good README Actually Does'
description: 'The README is the most-read file in any repository and the least seriously written. Here is what it is really for — and why most of them fail at it.'
pubDate: 'Oct 01 2026'
tags: ['writing', 'software']
featured: false
heroImage: '../../assets/covers/readme.jpg'
heroAlt: 'An open book with one amber-lit page and a ribbon bookmark'
---

Every repository has a front door. In most projects it is the README — a file that will be read orders of magnitude more often than it will be written, by people who arrive with a single question and a shrinking attention span.

And yet the typical README is a junk drawer: badges celebrating CI runs nobody checks, installation instructions that assume the reader already installed the thing, and — somewhere below the fold — a sentence about what the project actually *is*.

## The README is not documentation

Documentation answers "how?" A good README answers "why should I care, and where do I go next?" Those are different jobs, and conflating them produces files that do neither.

Think of the README as the inside flap of a book jacket. It has one paragraph to earn the reader's next ten minutes. Everything else — the API reference, the architecture notes, the contribution guide — is a *departure*: a link out of the flap and into the right room.

A README that does its job tends to have four moves, in order:

1. **One sentence of identity.** What is this, in the vocabulary of someone who has never heard of it? Not a tagline — a description honest enough to repel the wrong reader.
2. **One moment of proof.** A screenshot, a code block, a terminal session — the smallest artifact that demonstrates the thing working.
3. **One path to running it.** The shortest possible route to a local success. Not every option; *the* option.
4. **Signposts.** Where the deep documentation lives, where to report a bug, where the roadmap hides.

## Written for the stranger, not the author

The person who writes a README is almost always the worst person to imagine its reader. Authors write for validation: look at the features, look at the badges, look at the ecosystem. Readers arrive with a task. The distance between those two postures is where most READMEs fail.

```md
# glacier

A small toolkit for archiving large directories to cold storage.

glacier pack ./photos --to s3://my-vault --compress zstd
```

Fourteen words of description, one command. Everything else — the flags, the backends, the caveats — can afford to be a link. The reader who needs them will follow; the reader who doesn't just learned what they came for.

> A README should be written as if it will be read standing up — because it will be: on a phone, in a hurry, by someone deciding whether to keep scrolling.

## The maintenance contract

Here is the part nobody likes: a README is a promise. Every instruction in it is a claim that the thing still works that way — which means every README rots on a schedule, and the longer it is, the faster it rots. Brevity is not a stylistic preference; it is a maintenance strategy. The best README is the shortest file that can still do its job.

Write the front door first, keep it short, and let the rest of the house earn its own readers.
