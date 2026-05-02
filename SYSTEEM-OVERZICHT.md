---
titel: Systeem-overzicht multi-agent schoolopdrachten
datum: 2026-05-01
type: documentatie
status: opgeleverd
---

# Multi-agent systeem voor schoolopdrachten — Overzicht

Dit document beschrijft het systeem dat is gebouwd om David Koolstra te helpen bij zijn schoolopdrachten voor HBO Facilitair Management aan de HAN. Het is bedoeld als naslag.

## Wat het systeem doet

Het neemt een schoolopdracht-briefing als invoer en levert een ingeleverd-klaar concept op (markdown + Word-document met HAN-stijl). Het systeem doorloopt 11 fasen, gebruikt 12 gespecialiseerde subagents, ondersteunt zowel enkelvoudige als samengestelde opdrachten, en doet aan de eind APA-validatie en stem-bewaking om AI-glad-zinnen te vermijden.

## Slash-commands

| Command | Wat het doet |
|---------|--------------|
| `/opdracht <briefing>` | Volledige pipeline: vault-protocol → eis-extractie → decompositie → brainstorm → plan → bronnen + vakcontext + stijlanalyse → schrijver → reviewer-trio + APA → iteratie (max 3) → pandoc-conversie → vault-protocol-update |
| `/eisen <briefing>` | Alleen eis-extractor (handig bij geüpdate rubric) |
| `/deelopdracht <submap>` | Pipeline op één deelopdracht binnen samengestelde opdracht |
| `/herzien <concept>` | Reviewer-trio + APA op bestaande tekst, max 1 iteratie |
| `/apa-check <concept>` | Alleen APA-validator |
| `/voortzetten [werkmap]` | Pakt lopende opdracht op waar gestopt; bij samengesteld kiest volgende open deelopdracht volgens afhankelijkheidsgraaf |

## Agents (12)

| Fase | Agent | Tools | Model | Output-bestand |
|------|-------|-------|-------|----------------|
| 1 | eis-extractor | Read, Write, Glob, Bash | sonnet | `00-eisen.md` |
| 2 | opdracht-decomposer | Read, Write, Glob, Bash | sonnet | `00-decompositie.md` (+ `_plan.md`) |
| 3 | brainstormer | Read, WebSearch, Write | sonnet | `01-brainstorm.md` |
| 4 | coordinator | Read, Write, Glob | sonnet | `02-plan.md` |
| 5a | bron-zoeker | WebSearch, WebFetch, Read, Write, Bash | sonnet | `03-bronnen.md` |
| 5b | vak-expert | Read, Write, Glob | sonnet | `03-vakcontext.md` |
| 5c | stijl-referent | Read, Bash, Glob, Write | sonnet | `03-stijlanalyse.md` |
| 6 | schrijver | Read, Write, Glob | opus | `04-concept-vN.md` |
| 7a | reviewer | Read, Write, Glob | sonnet | `05a-review-vN.md` |
| 7b | rubric-checker | Read, Write, Glob | sonnet | `05b-rubric-vN.md` |
| 7c | stem-bewaker | Read, Write, Glob, Bash | sonnet | `05c-stem-vN.md` |
| 7d | apa-validator | Read, Write, WebFetch, Glob | sonnet | `05d-apa-vN.md` |

## Werkmap-conventies

### Enkelvoudige opdracht
```
School/Opdrachten-WIP/<naam>/
├── briefing.pdf (of -.docx, -.pptx)
├── _status.md
├── 00-eisen.md
├── 00-decompositie.md
├── 01-brainstorm.md
├── 02-plan.md
├── 03-bronnen.md
├── 03-vakcontext.md (als coordinator vraagt)
├── 03-stijlanalyse.md (als coordinator vraagt)
├── 04-concept-v1.md ... v3.md
├── 05a-review-vN.md
├── 05b-rubric-vN.md
├── 05c-stem-vN.md
├── 05d-apa-vN.md
├── eindversie.md
└── eindversie.docx
```

### Samengestelde opdracht
```
School/Opdrachten-WIP/<hoofdopdracht>/
├── briefing.pdf
├── _status.md
├── _plan.md (deelopdrachten + afhankelijkheidsgraaf)
├── 00-eisen.md
├── 00-decompositie.md
├── 01-pva/
│   ├── 01-brainstorm.md ... eindversie.docx
├── 02-wbs/
│   └── ...
├── 03-marketing/
│   └── ...
└── eindversie/
    └── productieplan-volledig.docx
```

## Iteratie-loop

Maximum 3 iteraties op de schrijver/reviewer-loop. Severity-gestuurd:
* Iteratienummer < 3 EN minstens één blokkerend issue → loop opnieuw
* Iteratienummer = 3 OF geen blokkerend issue → stop, lever op

Reviewer-trio + APA-validator draaien parallel. Hun outputs landen in 4 aparte bestanden zodat de schrijver in iteratie N+1 alle vier tegelijk leest.

## Pandoc-conversie

Markdown → .docx via [.claude/templates/convert-to-docx.sh](templates/convert-to-docx.sh).

* Pandoc 3.9.0.2 geïnstalleerd via Homebrew
* HAN-template: [han-rapport-template.docx](templates/han-rapport-template.docx) — gebaseerd op De Waalboog-rapport, schoongemaakt (lege body, alle stijlen behouden)
* Bij conversie neemt pandoc font, koppen, marges en paginaopmaak over uit het template

## Vault-protocol-integratie

Aan begin van `/opdracht`:
1. Lees `Profiel.md`
2. Lees laatste 3 entries van `Gesprekslog.md`
3. Lees relevante memory-bestanden

Aan einde:
1. Update `Profiel.md` met nieuwe feiten over deze opdracht
2. Voeg entry bovenaan `Gesprekslog.md` met datum, opdracht-naam, gemaakte/gewijzigde bestanden, aantal iteraties

## Memory-feedback die het systeem volgt

In `/Users/davidkoolstra/.claude/projects/-Users-davidkoolstra-Library-CloudStorage-OneDrive-HAN/memory/`:

* **feedback_bronnen_nl.md** — Alleen Nederlandstalige bronnen, standaard CBS Statline doorzoeken voor cijfers.

Dit wordt automatisch geladen in elke `/opdracht`-sessie.

## Schrijfregels (uit CLAUDE.md)

* Formeel-toegankelijk Nederlands
* Geen koppeltekens (`-`) als opsommingsteken — gebruik `*` of nummers
* Volzinnige alinea's, geen fragmentlijsten
* Geen emoji's
* Geen — of | als visuele separators in koppen
* Vet en cursief alleen waar functioneel
* Concreet en praktisch, geen vage formuleringen
* Persoon-perspectief past bij genre (eerste persoon bij reflectie, derde persoon bij rapport)

Stem-bewaker checkt op AI-glad-patronen: drielingen, generieke afsluiters, lege bijwoorden, dubbele synoniemen, overdreven balans tussen zinslengtes, standaard inleidings-zinnen.

## Beperkingen / wat het systeem nog niet kan

1. **Subagents kunnen geen subagents aanroepen** — hoofd-Claude is altijd orchestrator. De pipeline moet door hoofd-Claude gestart worden via `/opdracht`.
2. **Slash-commands werken pas na herstart van Claude Code.** Voor de huidige sessie is een proxy-route nodig (general-purpose subagent met system prompt geïnjecteerd).
3. **Pandoc-conversie behoudt geen tabellenbreedtes** perfect; bij brede tabellen kan handmatige aanpassing in Word nodig zijn.
4. **Plaatjes worden niet automatisch ingevoegd**; dat moet handmatig in Word.
5. **Voorblad/titelpagina** wordt niet gegenereerd; toevoegen na pandoc-conversie.
6. **De Waalboog-template** bevat ingebedde lettertypen die zorgen voor 9.9 MB-bestanden. Dit is normaal voor HAN-look maar kan bij e-mail tot bezwaar leiden.
7. **Geen automatische scope-conflictdetectie** als CLAUDE.md-regels botsen met eerder ingeleverd werk; stijl-referent en stem-bewaker resolven dit, maar in randgevallen wint CLAUDE.md.

## Mogelijke verbeteringen voor toekomstige sessies

1. **Aparte templates per genre**: `han-essay-template.docx`, `han-reflectieverslag-template.docx` voor andere opdracht-types.
2. **Lua-filter voor automatisch voorblad** bij pandoc-conversie.
3. **Voortzetten van iteratie-loop op specifieke sectie** (niet hele concept overdoen).
4. **Diff-modus**: schrijver levert alleen veranderingen ten opzichte van v[N-1] in plaats van volledig herschreven concept (efficiënter bij kleine iteraties).
5. **Automatische pre-flight check**: voor `/opdracht` runt eerst een check of pandoc beschikbaar is, of de werkmap leeg is, of het pad valide is.
6. **Hooks-integratie** via settings.json: bijvoorbeeld automatisch `/voortzetten` voorstellen bij start van een nieuwe Claude Code-sessie als er een open opdracht is.

## Geteste casussen tijdens implementatie

1. **PPO persoonlijk logboek (P4)** — eerste MVP-test, drie agents (eis-extractor, schrijver, apa-validator). Levering: ~1170 woorden concept, APA-issues correct gevangen (lesmateriaal-verantwoording), DOI-verificatie werkte (Korthagen, Tuckman beide geverifieerd).

2. **Achtergronden-hoofdstuk projectvoorstel Bruiloft Nova Hart** — uitgebreidere test met 6 NL-bronnen na feedback. Levering: 1018 woorden v2, alle 5 reviewers (incl. nieuwe trio) liepen succesvol. CBS-cijfer (68.682 huwelijken in 2024) geverifieerd. Ontbrekende Frankwatching-artikel-URL correct gemarkeerd als blokkerend door APA-validator.

In beide tests bewees het systeem dat het echte fouten vangt (verzonnen jaartal in Influencer Marketing Hub, ontbrekende artikel-URL, onbelegde claims) zonder onnodige ruis.

## Tot slot

Dit systeem is gebouwd in één sessie tussen ongeveer 17:16 en 20:30 op 1 mei 2026. Veranderingen in de toekomst kunnen direct door David worden aangebracht in de agent-bestanden, of door Claude in een vervolgsessie via `/opdracht` of een onderhouds-sessie.

Voor vragen of aanpassingen: `/opdracht`-systeem zelf gebruiken om zichzelf aan te passen werkt prima.
