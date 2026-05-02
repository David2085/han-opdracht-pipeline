# HAN Opdracht Pipeline

Multi-agent systeem voor Claude Code dat HAN-schoolopdrachten van briefing naar ingeleverd-klaar Word-document brengt. Gebouwd voor de opleiding HBO Facilitair Management aan de HAN, maar bruikbaar voor elke onderwijsinstelling waar in het Nederlands wordt geschreven volgens APA 7e.

## Wat het doet

De pipeline neemt een opdrachtbriefing (PDF, Word of PowerPoint), doorloopt elf fasen, en levert een markdown-concept plus een geconverteerd .docx-bestand op met HAN-stijl. Onderweg gaan twaalf gespecialiseerde subagents aan het werk: van eis-extractie en decompositie tot een viervoudige review-loop met APA-validatie en stem-bewaking tegen AI-glad-zinnen.

Voor een complete beschrijving zie [SYSTEEM-OVERZICHT.md](SYSTEEM-OVERZICHT.md).

## Slash-commands

| Command | Wat het doet |
|---------|--------------|
| `/opdracht <briefing>` | Volledige pipeline van briefing tot eindversie.docx |
| `/eisen <briefing>` | Alleen eis-extractor |
| `/deelopdracht <submap>` | Pipeline op één deelopdracht binnen samengestelde opdracht |
| `/herzien <concept>` | Reviewer-trio + APA op bestaande tekst |
| `/apa-check <concept>` | Alleen APA-validator |
| `/voortzetten [werkmap]` | Pakt lopende opdracht op waar gestopt |

## Agents

| Agent | Fase | Taak |
|-------|------|------|
| eis-extractor | 1 | Briefing en rubric omzetten naar gestructureerd eisenoverzicht |
| opdracht-decomposer | 2 | Bepalen of opdracht enkelvoudig of samengesteld is |
| brainstormer | 3 | Vijf invalshoeken genereren voor de schrijver |
| coordinator | 4 | Schrijfplan met paragrafen, woordenaantallen en specialisten |
| bron-zoeker | 5a | Nederlandstalige bronnen met APA 7e-metadata en URL-verificatie |
| vak-expert | 5b | Facilitair-management theoretisch raamwerk |
| stijl-referent | 5c | Stijlprofiel uit eerder ingeleverd HAN-werk |
| schrijver | 6 | Concept in markdown, opus-model |
| reviewer | 7a | Strenge HAN-docent-review met severity-labels |
| rubric-checker | 7b | Toets per beoordelingscriterium |
| stem-bewaker | 7c | Detectie van AI-glad-patronen |
| apa-validator | 7d | APA 7e-citaties en URL-verificatie |

## Installatie

### Optie 1: Claude Code plugin (aanbevolen)

```bash
# Vanaf elke locatie
claude plugin install <github-username>/han-opdracht-pipeline
```

Daarna Claude Code herstarten. De zes slash-commands en twaalf agents zijn dan beschikbaar.

### Optie 2: Handmatig in een vault

Kopieer de inhoud van deze repo naar `<jouw-vault>/.claude/`:

```bash
cd <jouw-vault>
mkdir -p .claude
cp -r agents commands templates SYSTEEM-OVERZICHT.md .claude/
```

### Vereisten

1. **Claude Code** geïnstalleerd
2. **Pandoc** voor Word-conversie:
   ```bash
   brew install pandoc
   ```
3. **HAN-rapport-template** in [templates/han-rapport-template.docx](templates/han-rapport-template.docx) (meegeleverd, gebaseerd op een eerder ingeleverd De Waalboog-adviesrapport, met lege body en behouden stijlen)

## Gebruik

```bash
# Vanaf de root van je vault
claude
```

In Claude Code:
```
/opdracht School/Briefings/marketingplan-week3.pptx
```

De pipeline pauzeert op vier punten voor akkoord van de gebruiker: na eis-extractie, na decompositie (bij samengesteld), na brainstorm en na elke iteratie.

## Werkmap-conventies

Elke opdracht krijgt een eigen submap onder `School/Opdrachten-WIP/<naam>/` met genummerde fase-bestanden:

```
School/Opdrachten-WIP/marketingplan-bruiloft/
├── briefing.pdf
├── _status.md
├── 00-eisen.md
├── 00-decompositie.md
├── 01-brainstorm.md
├── 02-plan.md
├── 03-bronnen.md
├── 03-vakcontext.md
├── 03-stijlanalyse.md
├── 04-concept-v1.md ... v3.md
├── 05a-review-vN.md
├── 05b-rubric-vN.md
├── 05c-stem-vN.md
├── 05d-apa-vN.md
├── eindversie.md
└── eindversie.docx
```

Bij samengestelde opdrachten worden submappen aangemaakt per deelopdracht. Zie SYSTEEM-OVERZICHT voor het volledige schema.

## Aanpassingen voor andere studenten

De pipeline bevat hardcoded paden naar Davids OneDrive en zijn persoonlijk profiel. Voor gebruik buiten zijn vault moeten deze aangepast worden:

1. **Vault-protocol** in [commands/opdracht.md](commands/opdracht.md) (fase 0 en fase 11) — verwijst naar `🧠 Geheugen/David - Profiel.md` en `Gesprekslog.md`. Vervang door eigen geheugenbestanden of verwijder die fasen.
2. **Werkmap-locatie** in [commands/opdracht.md](commands/opdracht.md) (fase 1) — `School/Opdrachten-WIP/`. Pas aan naar je eigen mappenstructuur.
3. **Voortzetten-zoeklocatie** in [commands/voortzetten.md](commands/voortzetten.md).
4. **Stijl-referent** in [agents/stijl-referent.md](agents/stijl-referent.md) — leest eerder ingeleverd werk uit een vaste map. Pas pad aan of verwijder als je geen referentiewerk hebt.
5. **Schrijver** in [agents/schrijver.md](agents/schrijver.md) — kent het stijlprofiel uit eerder werk. Pas aan naar je eigen schrijfstem.
6. **HAN-rapport-template** in templates — vervang door je eigen ingeleverde rapport voor de gewenste opmaak.

## Schrijfregels

Het systeem volgt een aantal harde regels die in alle agents zijn ingebakken:

* Formeel-toegankelijk Nederlands
* Geen koppeltekens (`-`) als opsommingsteken — gebruik `*` of nummers
* Volzinnige alinea's, geen fragmentlijsten
* Geen emoji's
* Geen — of | als visuele separators in koppen
* APA 7e voor alle citaties
* Standaard Nederlandstalige bronnen (CBS, NBTC, brancheverenigingen, NL-vakbladen) — alleen Engels als er geen NL-equivalent is

## Ontwerpkeuzes

1. **Hoofd-Claude is altijd orchestrator.** Subagents kunnen geen subagents aanroepen, dus de pipeline draait via slash-commands die door de hoofdsessie worden uitgevoerd.
2. **Reviewer-trio plus APA draaien parallel.** Dat scheelt drie iteratierondes en levert vier onafhankelijke perspectieven op die de schrijver in één keer kan verwerken.
3. **Severity-gestuurde iteratie.** Maximaal drie iteraties; stoppen zodra geen blokkerend issue meer over is.
4. **Pandoc-conversie via referentie-document.** Geen eigen .docx-template, maar een eerder ingeleverd HAN-rapport als stijlbron.

## Beperkingen

Zie de paragraaf 'Beperkingen' in [SYSTEEM-OVERZICHT.md](SYSTEEM-OVERZICHT.md) voor de complete lijst. Belangrijkste: geen automatisch voorblad, geen automatisch ingevoegde plaatjes, geen perfecte tabellenbreedte na pandoc-conversie.

## Licentie

MIT — zie [LICENSE](LICENSE).

## Auteur

David Koolstra, student HBO Facilitair Management aan de HAN. Gebouwd in mei 2026 met Claude Code.
