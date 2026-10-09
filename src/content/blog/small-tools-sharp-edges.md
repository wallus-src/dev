---
title: 'Small Tools, Sharp Edges'
description: 'The Unix idea — do one thing well — gets quoted constantly and practiced rarely. What small, sharp tools still teach us about composing software.'
pubDate: 'Sep 17 2026'
tags: ['tools', 'craft']
featured: false
heroImage: '../../assets/covers/small-tools.jpg'
heroAlt: 'A row of hand tools: awl, chisel, caliper, pencil, folding rule'
---

Open any experienced engineer's machine and you will find a drawer of small tools: a script that renames files the way *they* like, a fuzzy finder wired to muscle memory, an alias with a name so short it looks like a typo. None of them would survive a design review. All of them get used daily.

Meanwhile, the tools we build for *other* people tend toward the opposite shape: platforms, frameworks, suites — software that wants to be the whole workshop. The Unix idea, "do one thing and do it well," is the most quoted principle in our field and possibly the least practiced.

## Sharp edges are a feature

A chisel does one thing, has a learning curve measured in minutes, and rewards a lifetime of practice. It also cuts you if you're careless. That is not a flaw in the chisel.

Small tools are honest in a way large tools can't be: their failure modes are visible and local. When `grep` doesn't do what you need, you learn why in about a minute. When a platform doesn't, you file a ticket and learn to wait.

```sh
# three small tools, one sharp pipeline
find . -name '*.log' -mtime +30 | xargs -I {} sh -c 'gzip {} && mv {}.gz archive/'
```

The pipeline above is unfashionable — no config file, no plugin system, no YAML. It also composes perfectly, fails loudly, and will still work in twenty years. That durability is not nostalgia. It is what happens when tools agree on only one thing: text in, text out.

## Composition beats integration

The industry instinct is integration: wire everything into one system so users never leave. The small-tools instinct is composition: keep the pieces separate so users can leave — and recombine — freely. Integrated systems optimize the happy path. Composable tools optimize the *unknown* path, the thing nobody predicted you'd need to do.

> A tool that does one thing can be replaced. A platform that does everything can only be escaped.

This is why the sharpest tool in most stacks is also the most replaceable — and why replaceability, not features, is the true measure of a tool's health. The moment swapping a component costs more than keeping it, you don't have a tool anymore. You have a landlord.

## Build awls, not aircraft carriers

The discipline worth stealing: when you next reach for a framework, ask what the awl version looks like — the smallest program that does the whole job. It might be fifty lines. Ship that first. Let it earn complexity the way a good edge earns a handle: only after the point is proven.

Small tools assume a capable user. Capable users, given honest edges, build better systems than platforms can imagine for them.
