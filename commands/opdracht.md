---
description: Loopt een schoolopdracht door van briefing naar concept met volledige pipeline (decomposer, brainstorm, plan, bronnen, vakcontext, stijlanalyse, schrijver, reviewer-trio, APA-validator, iteratie, pandoc-conversie). Werkt voor zowel enkelvoudige als samengestelde opdrachten.
argument-hint: <pad-naar-briefing>
---

Je gaat David Koolstra helpen aan een schoolopdracht voor HBO Facilitair Management aan de HAN. Je voert onderstaande pipeline uit. Werk in het Nederlands.

Argument: $ARGUMENTS

## Fase 0 — Vault-protocol begin

Lees in deze volgorde:
1. `/Users/davidkoolstra/Library/CloudStorage/OneDrive-HAN/Obsidian x Claude/Claude x Obsidian/🧠 Geheugen/David - Profiel.md`.
2. De laatste 3 entries van `Gesprekslog.md` (gebruik bash `awk '/^## /{count++} count<=4{print}' Gesprekslog.md` als de file groot is).
3. Eventuele relevante memory-bestanden in `/Users/davidkoolstra/.claude/projects/-Users-davidkoolstra-Library-CloudStorage-OneDrive-HAN/memory/`.

Houd deze context in je werkgeheugen voor de rest van de pipeline.

## Fase 1 — Werkmap aanmaken

Het argument `$ARGUMENTS` is het pad of een beschrijving van de briefing. Doe dit:

1. Verifieer dat het bestand bestaat. Als het pad ontbreekt of het bestand niet gevonden wordt: vraag David om het pad. Als hij een beschrijving gaf (bijvoorbeeld 'week 1 powerpoint 3.1'), zoek het bestand met `find` en bevestig.
2. Stel een naam voor de werkmap voor in kebab-case op basis van vak en onderwerp. Bijvoorbeeld 'event-week31-achtergronden' of 'reflectie-ppo-p4'.
3. Vraag David om bevestiging of een andere naam (alleen als naam ambigu is — bij duidelijke naamvoorstel mag je doorgaan).
4. Maak de werkmap aan: `/Users/davidkoolstra/Library/CloudStorage/OneDrive-HAN/School/Opdrachten-WIP/<naam>/`.
5. Initialiseer `_status.md` met:
   ```
   ---
   opdracht: [naam]
   briefing: [absoluut pad]
   gestart: [datum YYYY-MM-DD]
   fase: 01-eisen
   ---
   ```

## Fase 2 — Eis-extractie

Roep subagent **eis-extractor** aan via Agent tool (`subagent_type: eis-extractor`).

Geef in de prompt:
* Volledig pad naar de briefing.
* Pad naar de werkmap.
* Output naar `<werkmap>/00-eisen.md`.

Update `_status.md` met `fase: 02-eisen-klaar`.

**Pauze-punt.** Toon David maximaal 5 bullets met de belangrijkste eisen en open vragen. Vraag akkoord. Ga niet verder zonder akkoord; bij correcties pas `00-eisen.md` aan.

## Fase 3 — Decompositie

Roep subagent **opdracht-decomposer** aan (`subagent_type: opdracht-decomposer`).

Geef in de prompt:
* Pad naar de werkmap.
* Output naar `<werkmap>/00-decompositie.md`.
* Bij classificatie samengesteld: ook `<werkmap>/_plan.md`.

Lees de output. Bij **enkelvoudig**: ga door naar fase 4. Bij **samengesteld**: maak submappen aan voor elke deelopdracht (`<werkmap>/01-pva/`, `<werkmap>/02-wbs/` etc.) en doorloop fase 4 t/m 10 per deelopdracht in topologische volgorde uit `_plan.md`. Update `_status.md` na elke deelopdracht.

## Fase 4 — Brainstorm

Roep subagent **brainstormer** aan (`subagent_type: brainstormer`).

Geef in de prompt:
* Pad naar de (deel)werkmap.
* Output naar `<werkmap>/01-brainstorm.md`.

**Pauze-punt.** Toon David de 5 invalshoeken in een korte samenvatting (één bullet per invalshoek met centrale vraag). Vraag welke hij kiest, of een combinatie. Markeer de keuze in `01-brainstorm.md` onder een aparte sectie 'Gekozen invalshoek'.

## Fase 5 — Coordinator-plan

Roep subagent **coordinator** aan (`subagent_type: coordinator`).

Geef in de prompt:
* Pad naar de (deel)werkmap.
* De gekozen invalshoek (citeer de markering uit `01-brainstorm.md`).
* Output naar `<werkmap>/02-plan.md`.

## Fase 6 — Specialisten parallel (bron-zoeker, vak-expert, stijl-referent)

Roep alle drie subagents tegelijk aan in één bericht (drie Agent tool-calls parallel):

1. **bron-zoeker** (`subagent_type: bron-zoeker`) — output naar `<werkmap>/03-bronnen.md`.
2. **vak-expert** (`subagent_type: vak-expert`) — output naar `<werkmap>/03-vakcontext.md` ALS de coordinator-plan dit vraagt; anders skip.
3. **stijl-referent** (`subagent_type: stijl-referent`) — output naar `<werkmap>/03-stijlanalyse.md` ALS de coordinator-plan dit vraagt; anders skip.

Wacht op alle drie en update `_status.md`.

## Fase 7 — Schrijver (concept v1)

Roep subagent **schrijver** aan (`subagent_type: schrijver`).

Geef in de prompt:
* Pad naar de (deel)werkmap.
* Iteratienummer: 1.
* Output naar `<werkmap>/04-concept-v1.md`.

Update `_status.md`.

## Fase 8 — Reviewer-trio + APA parallel

Roep vier subagents tegelijk aan in één bericht:

1. **reviewer** — output naar `<werkmap>/05a-review-v[N].md`.
2. **rubric-checker** — output naar `<werkmap>/05b-rubric-v[N].md`.
3. **stem-bewaker** — output naar `<werkmap>/05c-stem-v[N].md`.
4. **apa-validator** — output naar `<werkmap>/05d-apa-v[N].md`.

Waar `[N]` het iteratienummer is.

## Fase 9 — Iteratie-beslissing

Lees alle vier review-bestanden. Tel issues per severity (blokkerend / belangrijk / nice-to-have).

Beslismodel:
* **Iteratienummer < 3 EN minstens één blokkerend issue:** loop. Roep schrijver opnieuw aan voor v[N+1] met opdracht alle blokkerende issues te verwerken. Daarna fase 8 opnieuw met N+1.
* **Iteratienummer = 3 of geen blokkerend issue:** stop. Ga naar fase 10.

Toon David na elke iteratie een korte samenvatting (max 200 woorden) van de issue-tellingen plus de beslissing 'opnieuw' of 'klaar'.

## Fase 10 — Eindversie en pandoc-conversie

1. Kopieer de laatste `04-concept-vN.md` naar `<werkmap>/eindversie.md`.
2. Voer pandoc-conversie uit:
   ```
   /Users/davidkoolstra/Library/CloudStorage/OneDrive-HAN/.claude/templates/convert-to-docx.sh \
     <werkmap>/eindversie.md \
     <werkmap>/eindversie.docx
   ```
3. Verifieer dat `eindversie.docx` is aangemaakt.

Bij samengestelde opdrachten: doe dit per deelopdracht. Aan het einde van alle deelopdrachten: maak een hoofd-eindversie in `<hoofdwerkmap>/eindversie/` met de samengevoegde tekst. Hoofd-Claude beslist hoe te samenvoegen op basis van de afhankelijkheidsgraaf.

## Fase 11 — Vault-protocol einde

Voer dit uit zodra David aangeeft dat de opdracht-sessie afgerond is, of zodra fase 10 succesvol is afgerond.

1. Update `David - Profiel.md`:
   * Onder 'Losse feiten & context': korte regel over deze opdracht (naam, vak, status).
   * Pas `laatst_bijgewerkt` aan in frontmatter.
   * Update 'Laatst bijgewerkt door Claude op:' onderaan.
2. Voeg een nieuwe entry toe **bovenaan** `Gesprekslog.md`:
   * Datum.
   * Onderwerp: 'Schoolopdracht: [naam]'.
   * Wat is gemaakt: paden naar `00-eisen.md`, `04-concept-v[N].md`, `05*-v[N].md`, `eindversie.docx`.
   * Aantal iteraties.
   * Wat geleerd over David.

## Belangrijke regels voor jou tijdens de pipeline

* Nederlands, formeel-toegankelijk.
* Geen koppeltekens (`-`) als opsommingsteken — gebruik `*` of nummers.
* Geen emoji's.
* Houd communicatie naar David beknopt. Hij ziet de bestanden zelf.
* Pauzeer bij elk pauze-punt. Niet doorrazen.
* Bij subagent-fout: stop, meld het probleem, vraag instructies.
* **Subagents kunnen geen subagents aanroepen.** Jij bent de orchestrator.
* **Parallel waar mogelijk** — zelfde bericht, meerdere Agent tool-calls.
* **Volg de NL-bronnen-feedback in memory** — bron-zoeker weet dit, maar herinner hem expliciet als hij Engelse bronnen gebruikt.
