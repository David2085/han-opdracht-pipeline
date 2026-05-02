---
titel: Templates en conversiehulpmiddelen
type: documentatie
---

# Templates en conversie

Deze map bevat de tools om een markdown-concept om te zetten naar een Word-document dat oogt als eerder ingeleverd HAN-rapport.

## Bestanden

| Bestand | Doel |
|---------|------|
| `convert-to-docx.sh` | Conversie-script markdown → .docx |
| `han-rapport-template.docx` | Referentie-template (font, koppen, marges) — moet eenmalig worden aangemaakt |

## Eenmalige setup

### 1. Pandoc installeren

Pandoc is nodig voor de conversie. Installeer met Homebrew:

```bash
brew install pandoc
```

Dit duurt enkele minuten.

### 2. HAN-rapport-template aanmaken

Pandoc gebruikt een referentie-Word-document waaruit het stijlen overneemt: font, marges, koppen-niveaus, paginanummering, kleuraccenten. Voor HAN-werk wil je een eerder ingeleverd, beoordeeld rapport als basis. Een goede kandidaat is:

```
School/Vak gehaald/Facilitair bedrijfsproject/AOO-FM-N-A06 1e sem 2526 - Groep 3 - Groep 3/De Waalboog Facilitaire adviezen groep 3.docx
```

Kopieer dat bestand naar deze map met de naam `han-rapport-template.docx`:

```bash
cp "School/Vak gehaald/Facilitair bedrijfsproject/AOO-FM-N-A06 1e sem 2526 - Groep 3 - Groep 3/De Waalboog Facilitaire adviezen groep 3.docx" \
   ".claude/templates/han-rapport-template.docx"
```

Tip: Open `han-rapport-template.docx` daarna kort in Word, verwijder eventuele inhoud (alle tekst, behalve de stijlen) zodat alleen de opmaak overblijft, en sla op. Pandoc gebruikt dan alleen de stijlen.

Een snellere route: laat de inhoud staan. Pandoc vervangt bij conversie de inhoud automatisch door het nieuwe concept en behoudt alleen de stijlen. Het werkt, maar is iets onvoorspelbaarder.

## Gebruik

Vanaf de werkmap met het concept:

```bash
.claude/templates/convert-to-docx.sh \
  School/Opdrachten-WIP/<naam>/eindversie.md \
  School/Opdrachten-WIP/<naam>/eindversie.docx
```

Als het tweede argument ontbreekt, schrijft het script naar `eindversie.docx` naast de markdown-bron.

## Wat het script doet

1. Controleert of pandoc beschikbaar is. Zo niet: foutmelding met installatie-instructie.
2. Controleert of `han-rapport-template.docx` aanwezig is. Zo niet: conversie met pandoc-standaardstijlen, met waarschuwing.
3. Voert pandoc-conversie uit met `--reference-doc=han-rapport-template.docx`.
4. Het resultaat is een .docx-bestand met HAN-stijl, op te openen in Word.

## Wat het script NIET doet

* Het past geen handmatige opmaak toe (geen tabellenbreedte-overrides, geen pagina-einden, geen voetteksten met paginanummering die afwijkt van het template).
* Het corrigeert geen markdown-fouten in de bron.
* Het levert geen voorblad of titelblad. Als de docent dat verwacht, voeg dat in Word zelf toe na de conversie.
* Het haalt geen `[INVULLEN: ...]`-markeringen weg. David moet die zelf vervangen voordat hij inlevert.

## Bekende beperkingen

1. **Tabellen** in het concept worden door pandoc geconverteerd, maar krijgen niet altijd dezelfde breedte als in het template. Bij brede tabellen (zoals een uitgebreide stakeholder-tabel) kan handmatige aanpassing in Word nodig zijn.
2. **Inline-citaties** zoals `(Achternaam, jaar)` blijven behouden. Hangende inspringing van de bronnenlijst wordt door pandoc toegepast op basis van het template.
3. **Voet- en eindnoten** worden ondersteund, maar het concept gebruikt ze niet standaard.
4. **Plaatjes** worden niet automatisch ingevoegd; dat moet handmatig in Word.

## Verbeterroutes (later)

* Een tweede template `han-essay-template.docx` voor essays (afwijkende opmaak: smallere marges, kleinere koppen).
* Een tweede template `han-reflectieverslag-template.docx` voor PPO-logboeken.
* Automatisch voorblad invoegen via een pandoc Lua-filter.
