---
description: Roept alleen de apa-validator aan op een conceptbestand. Handig voor een snelle APA-check zonder de hele review-loop te draaien.
argument-hint: <pad-naar-conceptbestand>
---

Argument: $ARGUMENTS

## Wat te doen

1. Verifieer dat het pad naar een markdown-conceptbestand wijst.
2. Bepaal de werkmap en het iteratienummer N.
3. Roep subagent **apa-validator** aan (`subagent_type: apa-validator`):
   * Pad naar werkmap.
   * Output naar `<werkmap>/05d-apa-v[N].md`.
4. Toon David een korte samenvatting (max 150 woorden):
   * Aantal issues per severity (blokkerend / belangrijk / nice-to-have).
   * Welke DOI's of URL's wel of niet resolven.
   * Of de gecorrigeerde bronnenlijst klaar staat.

Geen andere reviewers, geen schrijver-iteratie, geen pandoc-conversie.

## Belangrijke regels

* Werk in het Nederlands, formeel-toegankelijk.
* Geen koppeltekens als opsommingsteken.
