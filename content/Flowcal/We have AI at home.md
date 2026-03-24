
Language models are genuinely interesting. The science is good. The 
applications are good. The part that gets complicated is who owns the 
infrastructure - and what that means over time.

This is a practical note about running models locally. What I set up, 
what I used it for, and where I think it's going. #flowcal 

---

## Why Local

Every prompt you send to a hosted model passes through infrastructure 
you don't control. That's fine for most things. It becomes less fine 
when the data is personal - financial records, private documents, 
anything you'd rather not have sitting in someone else's logs.

There's also the simpler question of dependency. Pricing changes. 
APIs get deprecated. Rate limits happen. A local setup is slower to 
start and smaller in capability, but it doesn't change on you.

Hence, `AI at home`

---

## The Stack

Two tools, both open source:

**[Ollama](https://ollama.com)** - runs the model locally. Manages 
downloads, loads models into memory, and exposes a clean API. This is `the Brain`

**[OpenWebUI](https://openwebui.com)** - a browser-based chat interface 
that connects to Ollama. Runs in Docker. Looks like ChatGPT, runs on 
your machine. This is `the interface`
### Setting It Up

Install [Docker Desktop](https://www.docker.com/products/docker-desktop/) 
first - OpenWebUI runs as a container and Docker Desktop gives you a 
clean way to manage it without touching the terminal much.

Then, install Ollama and pull the models:
```bash
# Install Ollama (macOS/Linux)
curl -fsSL https://ollama.com/install.sh | sh

# Pull models
ollama pull mistral
ollama pull qwen2.5
```

Then run OpenWebUI:
```bash
docker run -d -p 3000:8080 \
  --add-host=host.docker.internal:host-gateway \
  -v open-webui:/app/backend/data \
  --name open-webui \
  ghcr.io/open-webui/open-webui:main
```

Open `localhost:3000` in your browser. That's it

### Models

- **Mistral** - fast and coherent. Good default for most tasks.
- **Qwen 2.5** - better at structured output and longer context. 
  My current preference for anything format-heavy.

---

## First Real Use Case: Automated Reports

Once the local stack was running, the first thing I wired up was 
automated yearly report generation - using N8N, a workflow automation 
tool, also self-hosted via Docker.

The short version: documents go in, structured summaries come out, 
and none of that data touches an external server. For personal or 
financial records, that matters.


---

## Where This Goes

The reports workflow was a proof of concept. What I'm actually 
interested in building is a privacy-first personal finance layer.

Concretely:

- **Personal accountant** - categorises transactions, tracks patterns, 
  answers questions about your own numbers.
- **Financial teacher** - explains concepts against your actual data. 
  Generic advice is abundant; personalised context is not.
- **Document processor** - reads contracts, loan agreements, term 
  sheets. Summarises and flags. Locally.

The models exist. The tooling exists. It's mostly a building problem.

---

## The Actual Point

AI as a technology is worth being curious about. The consolidation 
of who runs it is worth watching carefully. Local infrastructure is 
one practical response to the second thing, without having to be 
cynical about the first.


---

*Building something similar or have questions - [find me here](#).*