---
description: Review-loop op een bestaande tekst zonder de hele pipeline. Roept reviewer-trio en apa-validator parallel aan op een conceptbestand en laat de schrijver indien nodig één iteratie doen.
argument-hint: <pad-naar-conceptbestand>
---

Argument: $ARGUMENTS

## Wat te doen

1. Verifieer dat het pad naar een markdown-conceptbestand wijst (typisch `04-concept-vN.md` in een werkmap).
2. Bepaal de werkmap (parent directory) en het iteratienummer N (uit de bestandsnaam, of vraag David als ambigu).
3. Roep deze vier subagents parallel aan in één bericht:
   * **reviewer** — output naar `<werkmap>/05a-review-v[N].md`
   * **rubric-checker** — output naar `<werkmap>/05b-rubric-v[N].md`
   * **stem-bewaker** — output naar `<werkmap>/05c-stem-v[N].md`
   * **apa-validator** — output naar `<werkmap>/05d-apa-v[N].md`
4. Lees alle vier reviews. Tel issues per severity.
5. Als er minstens één blokkerend issue is en N < 3:
   * Vraag David of hij een nieuwe iteratie wil.
   * Bij ja: roep schrijver aan voor v[N+1] met instructies om alle blokkerende issues te verwerken. Daarna stop, want één iteratie is genoeg voor `/herzien`.
6. Als geen blokkerend issue of N >= 3: stop, geef David een samenvatting (max 200 woorden) van de issue-tellingen en concrete suggesties.

## Belangrijke regels

* Geen vault-protocol begin/einde — `/herzien` is een hulpcommand.
* Geen pandoc-conversie — David doet die zelf via `/opdracht` of handmatig.
* Werk in het Nederlands, formeel-toegankelijk.
* Geen koppeltekens als opsommingsteken.
