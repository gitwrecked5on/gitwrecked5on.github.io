---
title: About - Website Setup
---


This site runs on a stack I've adopted to avoid being locked into walled gardens and platforms that seem to be racing towards through enshittification toward evil-megacorporations. I am looking at you Amazon `I'm finding some content in my Ads`, Google `Stop tracking me already`. Microsoft `I'm pretty sure window is an advertisement for MacOS and Linux`

Here's the full setup, explained for someone who has never done this before.

---

## The Stack

### 1. Obsidian — Where the Writing Happens

[Obsidian](https://obsidian.md) is a note-taking app that stores everything as plain `.md` (Markdown) files on your own machine. No cloud, no subscription, no proprietary format. If Obsidian shuts down tomorrow, your notes are still just files on your computer.

I have one big Obsidian vault for everything. Inside it, there's a subfolder called **ChaosGarden** — that's the only part that goes public.

### 2. Syncthing — Sync Across Devices Without the Cloud

[Syncthing](https://syncthing.net) keeps my Obsidian vault in sync across my Mac and Windows laptop. It's peer-to-peer — devices talk directly to each other, no third-party server ever sees your files.

Setup once, forget about it. It just works. Oh, and the code is auditable so if cybersecurity is your thing, you can check it out yourself [Syncthing Docs](https://docs.syncthing.net/specs/bep-v1.html#bep-v1)

### 3. Sync Script — Bridge Between Obsidian and the Website

Obsidian and the website engine are intentionally kept separate. A small bash script (`obsidian_notes_sync.sh`) uses `rsync` to copy ChaosGarden into the website project whenever I'm ready to publish.

This means nothing goes live until I explicitly run the sync. Drafts stay drafts.

### 4. Quartz — Turns Markdown Into a Website

[Quartz](https://quartz.jzhao.xyz) is an open-source static site generator built specifically for Obsidian-style notes. It reads the markdown files and outputs a fully functional website — search, backlinks, graph view, the works.

All customisation (fonts, colours, layout) lives in a handful of config files inside the Quartz project. The content and the engine are completely separate.

### 5. GitHub Pages — Free Hosting

The Quartz project lives in a [GitHub](https://github.com) repository. Every time I push changes, a GitHub Actions workflow automatically builds the site and publishes it.

Free. No vendor lock-in. No server to maintain.

### 6. The Publish Workflow

When I want to update the site:
```bash
bash obsidian_notes_sync.sh   # pull latest notes from Obsidian
git add .
git commit -m "content: update"
git push                       # triggers auto-deploy, live in ~40 seconds
```

That's it.

---



---

*Built with [Quartz](https://quartz.jzhao.xyz). Notes written in Obsidian.*