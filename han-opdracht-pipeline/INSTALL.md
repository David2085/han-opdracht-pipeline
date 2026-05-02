---
titel: Installatie en eerste-gebruik
type: documentatie
---

# Installatie

Deze pipeline is gebouwd als Claude Code plugin. Er zijn twee installatieroutes.

## Route 1: Plugin (aanbevolen)

Vereist dat de repo eerst op GitHub staat.

```bash
claude plugin install <github-username>/han-opdracht-pipeline
```

Herstart Claude Code daarna. Controleer de installatie met:

```bash
claude plugin list
```

De zes slash-commands en twaalf agents zijn nu beschikbaar in elke Claude Code-sessie, waar je ook werkt.

## Route 2: Lokale .claude/-map

Voor gebruik in één specifieke vault zonder plugin-installatie.

```bash
cd <jouw-vault>
mkdir -p .claude
cp -r agents commands templates SYSTEEM-OVERZICHT.md .claude/
```

De slash-commands en agents werken alleen als Claude Code start met `<jouw-vault>` als working directory.

## Vereisten

### Pandoc

Nodig voor de markdown-naar-Word conversie in fase 10:

```bash
brew install pandoc
```

Versie 3.0 of hoger werkt. Verifieer met `pandoc --version`.

### HAN-rapport-template

Het meegeleverde [templates/han-rapport-template.docx](templates/han-rapport-template.docx) is gebaseerd op een eerder ingeleverd De Waalboog-adviesrapport en bevat HAN-huisstijl: font, koppen, marges, paginanummering. De inhoud is leeg gemaakt zodat alleen de stijlen overblijven.

Voor een eigen ingeleverd rapport als template: vervang het bestand met dezelfde naam. Pandoc neemt dan automatisch jouw stijlen over bij conversie.

## Aanpassingen voor jouw vault

Het systeem bevat een aantal hardcoded paden die wijzen naar Davids vault. Voor gebruik in een andere omgeving moet je deze aanpassen.

### 1. Vault-protocol uitschakelen of aanpassen

In [commands/opdracht.md](commands/opdracht.md), fase 0 en fase 11. Deze fasen lezen Davids profiel en gesprekslog uit `Obsidian x Claude/Claude x Obsidian/🧠 Geheugen/`. Drie opties:

1. **Verwijderen.** Knip fase 0 en fase 11 uit `commands/opdracht.md`. De pipeline draait gewoon door zonder vault-protocol.
2. **Aanpassen naar eigen geheugenbestanden.** Vervang het pad naar je eigen profiel- en logbestanden.
3. **Stub-bestanden aanmaken.** Maak een lege `David - Profiel.md` en `Gesprekslog.md` op de oude locatie zodat de fase niet faalt.

### 2. Werkmap-locatie

In [commands/opdracht.md](commands/opdracht.md), fase 1. Standaard is `School/Opdrachten-WIP/<naam>/`. Pas aan naar je eigen mappenstructuur. Hetzelfde geldt voor [commands/voortzetten.md](commands/voortzetten.md) in de zoeklocatie van openstaande opdrachten.

### 3. Stijl-referent en schrijver

In [agents/stijl-referent.md](agents/stijl-referent.md) staat een vaste map waar eerder ingeleverd werk wordt gezocht. Pas aan of verwijder. In [agents/schrijver.md](agents/schrijver.md) staat een lijst met Davids voorkeurszinsbouw, woordkeuze en stem-kenmerken — dit is sterk persoonlijk en moet je herschrijven naar je eigen stem of generaliseren naar HBO-niveau zonder persoonlijke kenmerken.

### 4. APA-validator en bron-zoeker

In [agents/apa-validator.md](agents/apa-validator.md) en [agents/bron-zoeker.md](agents/bron-zoeker.md) staan referenties naar HAN-richtlijnen en de NL-bronnen-feedback. Voor andere onderwijsinstellingen pas de richtlijnenbron aan.

## Eerste gebruik

```bash
cd <jouw-vault>
claude
```

In Claude Code:

```
/opdracht School/Briefings/jouw-eerste-briefing.pdf
```

De pipeline pauzeert op vier punten voor akkoord. Bij elke pauze toont Claude een korte samenvatting en vraagt om bevestiging voordat hij verdergaat.

## Plugin op GitHub publiceren (voor eigenaar)

```bash
cd /Users/davidkoolstra/Library/CloudStorage/OneDrive-HAN/School/han-opdracht-pipeline
git init
git add .
git commit -m "Initial commit van HAN opdracht pipeline"
gh repo create han-opdracht-pipeline --public --source=. --push
```

Of via GitHub Desktop: open de map als nieuwe repo, commit, publish.

Een tweede stap is alleen nodig als je deze plugin in een marketplace wilt opnemen. Zonder marketplace kunnen anderen hem direct installeren via `claude plugin install <jouw-username>/han-opdracht-pipeline`.

## Bekende valkuilen

1. **OneDrive-sync en .git.** Bij gebruik van OneDrive en Git op dezelfde map kan OneDrive `.git/`-bestanden lockt of dupliceert. Bij vreemde Git-meldingen: stop OneDrive-sync tijdelijk, of zet `.git/` in een OneDrive-uitsluiting.
2. **Template-grootte.** Het meegeleverde `han-rapport-template.docx` is 9,9 MB door ingebedde lettertypen. Te groot voor sommige e-mailclients als bijlage; voor de pipeline geen probleem.
3. **Slash-commands na herstart.** Nieuwe slash-commands verschijnen pas na een herstart van Claude Code. De eerste keer kan het lijken alsof de installatie mislukt is — herstart en probeer opnieuw.
4. **Subagents kunnen geen subagents aanroepen.** Hoofd-Claude moet altijd de orchestrator zijn. Probeer niet de pipeline vanuit een ander subagent te starten.
