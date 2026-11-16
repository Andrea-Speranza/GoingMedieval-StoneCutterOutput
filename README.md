# More Mining & Masonry Output

Mod per Going Medieval 1.1.19.

## Cosa cambia

### Estrazione

| Risorsa | Vanilla | Mod |
|---|---:|---:|
| Argilla | 15 | 25 |
| Calcare | 15 | 25 |
| Calcare impuro | 4 | 6 |
| Sale | 20 | 30 |
| Carbone | 15 | 25 |
| Ferro | 20 (+2 calcare) | 30 (+3 calcare) |
| Argento | 80 (+2 calcare) | 120 (+3 calcare) |
| Oro | 80 (+2 calcare) | 120 (+3 calcare) |

### Produzione

| Ricetta | Costo vanilla | Produzione vanilla | Produzione mod |
|---|---:|---:|---:|
| Blocchi di calcare | 40 calcare | 20 | 30 |
| Mattoni d'argilla | 40 argilla + 10 combustibile | 20 (+50 cenere) | 30 (+50 cenere) |

Tempi di lavoro, combustibile e tutti gli altri parametri restano invariati.

## Build e installazione

Lo script `build.ps1` controlla che i JSON siano validi e crea la cartella della mod in `dist\StoneCutterOutput`.

```powershell
# Solo build in dist\
powershell -ExecutionPolicy Bypass -File .\build.ps1

# Build + installazione nella cartella Mods del gioco
powershell -ExecutionPolicy Bypass -File .\build.ps1 -Install

# Build + archivio zip
powershell -ExecutionPolicy Bypass -File .\build.ps1 -Zip
```

La cartella Mods del gioco e' `Documenti\Foxy Voxel\Going Medieval\Mods`. Con `-ModsPath` puoi indicarne un'altra, con `-FolderName` cambi il nome della cartella della mod.

## Pubblicare una release

1. Aggiorna `modVersion` in `ModInfo.json` e fai il commit.
2. Crea e pusha il tag con la stessa versione:

```powershell
git tag v1.0.0
git push origin main v1.0.0
```

GitHub Actions esegue `build.ps1 -Zip` e pubblica una release con allegato `StoneCutterOutput-v1.0.0.zip`. Se il tag non corrisponde a `modVersion`, la release non viene creata.

## Attivazione e prova

1. Avvia Going Medieval.
2. Apri **Mods** dal menu principale.
3. Abilita **More Mining & Masonry Output**.
4. Carica una partita e prova a estrarre un nuovo voxel di calcare o argilla.
5. Avvia una nuova commessa di blocchi o mattoni per vedere la resa da 30.

Per un test pulito e' preferibile usare nuovi ordini di estrazione e produzione. Le pile o le commesse gia' generate prima di abilitare la mod potrebbero conservare i vecchi valori.

## Personalizzazione

- Le rese minerarie sono in `Data/Models/DigMarkers.json`, nei campi `amount`.
- Le rese di blocchi e mattoni sono in `Data/Models/Production.json`, nei campi `amount` associati a `limestone_block` e `clay_brick`.

Dopo ogni modifica, chiudi e riavvia il gioco. Mantieni numeri interi e non rimuovere virgole, parentesi o virgolette dal JSON.
