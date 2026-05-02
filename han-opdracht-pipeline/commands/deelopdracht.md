---
description: Draait de pipeline op één specifieke deelopdracht binnen een samengestelde opdracht. Handig om iets opnieuw te doen of in afwijkende volgorde te werken.
argument-hint: <pad-naar-deelopdracht-submap>
---

Argument: $ARGUMENTS

## Wat te doen

1. Verifieer dat het argument een pad is naar een submap binnen `School/Opdrachten-WIP/<hoofdopdracht>/`. Bijvoorbeeld `School/Opdrachten-WIP/productieplan-bruiloft/01-pva/`.
2. Lees het hoofd-`_plan.md` één niveau hoger om afhankelijkheden en context te begrijpen.
3. Lees de eindversies van vereiste eerder afgeronde deelopdrachten (volgens de afhankelijkheidsgraaf).
4. Doorloop fase 4 t/m 10 van de hoofd-pipeline (`/opdracht`) **alleen voor deze deelopdracht**:
   * brainstormer (output naar deze deelopdracht-submap)
   * coordinator
   * bron-zoeker, vak-expert, stijl-referent (parallel)
   * schrijver
   * reviewer-trio + apa-validator (parallel)
   * iteratie tot max 3 of geen blokkerend
   * pandoc-conversie naar `eindversie.docx` in deze submap
5. Update het hoofd-`_plan.md`: zet status van deze deelopdracht op 'klaar'.
6. Toon David een samenvatting wat er is gemaakt en welke deelopdracht logisch volgt.

## Belangrijke regels

* Doe geen vault-protocol begin/einde — dat is voor de hele opdracht-sessie, niet per deelopdracht.
* Doe geen decompositie opnieuw — die staat al in `00-decompositie.md` van de hoofdmap.
* Doe geen eis-extractie opnieuw — eisen gelden voor de hele samengestelde opdracht.
* Werk in het Nederlands, formeel-toegankelijk.
* Geen koppeltekens als opsommingsteken.
