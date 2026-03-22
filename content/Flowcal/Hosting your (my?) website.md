---
title: Hosting your (my?) website
---


This site runs on a stack I've adopted to avoid being locked into walled gardens and platforms that seem to be racing towards through enshittification toward evil-megacorporations. I am looking at you Amazon `I'm finding some content in my Ads`, Google `Stop tracking me already`. Microsoft `I'm pretty sure window is an advertisement for MacOS and Linux`

A part of my larger motivation to move towards local setups under the philosophy of #flowcal 

Here's the full setup:

---
## The Stack

### 1. Obsidian - Where the Writing Happens

[Obsidian](https://obsidian.md) is a note-taking app that stores everything as plain `.md` (Markdown) files on the user's own machine. No cloud, no subscription, no proprietary format. If Obsidian shuts down tomorrow, the notes are still just files on a computer.

The recommended structure is one main Obsidian vault for everything, with a dedicated subfolder for public-facing content. 

### 2. Syncthing - Sync Across Devices Without the Cloud

[Syncthing](https://syncthing.net) keeps the Obsidian vault in sync across devices - in this case, a Mac and a Windows laptop. It's peer-to-peer: devices talk directly to each other, no third-party server ever sees the files.

The code is fully auditable. If cybersecurity is your thing, check it out: [Syncthing Docs](https://docs.syncthing.net).

Setup once, forget about it. It just works.

### 3. Quartz - Turns Markdown Into a Website

[Quartz](https://quartz.jzhao.xyz) is an open-source static site generator built specifically for Obsidian-style notes. It reads Markdown files from a `/content` folder inside the project and outputs a fully functional website - search, backlinks, graph view, the works.

**Setting up Quartz:**
```bash
# Clone the Quartz repo
git clone https://github.com/jackyzha0/quartz.git your-project-name
cd your-project-name
npm install
npx quartz create
```

All customisation - fonts, colours, layout - lives in `quartz.config.ts` and `quartz/styles/custom.scss`. The content and the engine stay completely separate.

### 4. Syncing Obsidian to Quartz

The Obsidian vault and the Quartz project are intentionally kept separate. A small bash script uses `rsync` to copy the public subfolder into Quartz's `/content` folder whenever the user is ready to publish. This means nothing goes live until the sync is explicitly run. Drafts stay drafts.

Save the following as `obsidian_notes_sync.sh` inside the Quartz project:
```bash
#!/bin/bash
# Replace HOSTNAME and PATH with values from your machine
# Find your hostname by running: hostname

HOSTNAME=$(hostname)
CONTENT_DIR="$(cd "$(dirname "$0")" && pwd)/content"

declare -A PATHS
PATHS["YOUR_HOSTNAME"]="/your/path/to/ObsidianVault/PublicSubfolder"

SOURCE_PATH="${PATHS[$HOSTNAME]}"

if [[ -z "$SOURCE_PATH" ]]; then
  echo "ERROR: No path found for hostname '$HOSTNAME'"
  echo "Add your hostname and vault path to the PATHS array in this script"
  exit 1
fi

rsync -av --delete \
  --exclude='.obsidian/' \
  --exclude='.trash/' \
  --exclude='*.canvas' \
  "$SOURCE_PATH/" "$CONTENT_DIR/"

echo "Sync complete."
```

### 5. GitHub Pages - Free Hosting

The Quartz project lives in a GitHub repository. The repository name matters: for GitHub Pages to work without a custom domain, the repo must be named `yourusername.github.io`.

Quartz ships with a GitHub Actions workflow file at `.github/workflows/deploy.yml`. Every time changes are pushed to the `main` branch, this workflow automatically builds the Quartz site and publishes it to GitHub Pages. No server configuration required.

To enable this:
- Go to the repository on GitHub
- Settings - Pages - Source: select **GitHub Actions**

That's it. The pipeline handles the rest.

---

## The Publish Workflow
```bash
bash obsidian_notes_sync.sh   # copy latest notes from Obsidian into /content
git add .
git commit -m "content: update"
git push                       # triggers auto-deploy, live in ~40 seconds
```

---

## What's Next

Hoenstly? I dont know 

The goal from the start was to adopt a platform that I would do 3 things:

1. Iteratively build an online presence, one that could work with my chaotic approach to the very act of thinking itself. 
2. Allow me to fully control my own destiny. Well ok not destiny, but full control over building this website as am entity I could grow, organically.

While going down the [Quartz](https://quartz.jzhao.xyz). rabbit hole I came across something written by the project's creator that resonated deeply with me - what he calls the [Digital Garden](https://jzhao.xyz/posts/networked-thought).

A space built on the concept of letting ideas fall like seeds and seeing them sprout - well atleast some of them. Principally, this led me to set this up as my own [[index|Chaos Garden]].


---

*Built with [Quartz](https://quartz.jzhao.xyz). Notes written in Obsidian.*