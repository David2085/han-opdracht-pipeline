---
description: Pakt een lopende opdracht op waar hij is gestopt. Zoekt automatisch de meest recente werkmap of vraagt David welke. Bij samengestelde opdrachten kiest het de volgende open deelopdracht volgens de afhankelijkheidsgraaf.
argument-hint: [optioneel: pad-naar-werkmap]
---

Argument: $ARGUMENTS

## Wat te doen

1. Bepaal de werkmap:
   * Als er een argument is: gebruik dat pad.
   * Anders: zoek de meest recent gewijzigde map in `/Users/davidkoolstra/Library/CloudStorage/OneDrive-HAN/School/Opdrachten-WIP/`. Bevestig met David: 'Wil je verdergaan met opdracht X?'.

2. Lees `_status.md` in de werkmap.

3. Bepaal het type opdracht:
   * **Enkelvoudig** (zie `00-decompositie.md`): pak de fase op die in `_status.md` staat. Doorloop de resterende fasen volgens `/opdracht`.
   * **Samengesteld**: lees `_plan.md`. Vind de eerstvolgende deelopdracht die status 'open' heeft én waarvan alle vereisten status 'klaar' hebben. Toon David welke dat is en vraag bevestiging. Bij ja: roep `/deelopdracht <pad>` aan op die deelopdracht-submap.

4. Update `_status.md` na elke voortgang.

5. Bij twijfel of er meer dan één logische volgende stap is: leg de keuzes voor aan David en wacht op besluit.

## Belangrijke regels

* Doe geen vault-protocol opnieuw — dat is alleen aan begin en einde van de hele opdracht.
* Werk in het Nederlands, formeel-toegankelijk.
* Geen koppeltekens als opsommingsteken.

## Bijzonder geval: opdracht klaar

Als alle deelopdrachten 'klaar' zijn (samengesteld) of de volledige enkelvoudige pipeline is afgerond:
* Toon David de samenvatting van wat is geproduceerd.
* Vraag of hij `/opdracht` fase 11 (vault-protocol einde + Profiel-update + Gesprekslog-entry) wil draaien.
* Bij ja: voer fase 11 uit.
