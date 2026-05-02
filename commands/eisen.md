---
description: Roept alleen de eis-extractor aan op een briefing. Handig als de rubric is geupdatet of als je een tweede meting wil van wat er in de opdracht staat.
argument-hint: <pad-naar-briefing-of-werkmap>
---

Argument: $ARGUMENTS

## Wat te doen

1. Bepaal of het argument een pad naar een briefing of een pad naar een bestaande werkmap is.
2. Als het een werkmap is: zoek de briefing via het `briefing`-veld in `_status.md`.
3. Roep subagent **eis-extractor** aan (`subagent_type: eis-extractor`) met:
   * Pad naar de briefing.
   * Pad naar de werkmap (maak nieuwe werkmap aan als die nog niet bestaat).
   * Output naar `<werkmap>/00-eisen.md` (of `00-eisen-v2.md` als er al een bestaat).
4. Toon David een korte samenvatting (max 5 bullets met `*`) van de belangrijkste eisen en open vragen.

Geen verdere fasen draaien. Geen brainstormer, schrijver of reviewer-trio.

## Belangrijke regels

* Nederlands, formeel-toegankelijk.
* Geen koppeltekens als opsommingsteken.
* Geen emoji's.
