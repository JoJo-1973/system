# system

Utilità e simboli di sistema per il Commodore 64: gestione del BASIC, salti condizionati, macro di uso generale, codici d'errore del BASIC, codici della tastiera e codici di carattere (PETSCII, Codici Schermo, ASCII a 7 bit). La libreria `system` fa parte della Libreria di Sistema (progetto `system.c64`) ed è scritta in assembly 6510 per C64Studio (sintassi ACME). I moduli `ascii_7bit.asm`, `errors.asm`, `keycodes.asm`, `petscii.asm` e `screencodes.asm` contengono solo simboli: fanno fede i commenti dei sorgenti.

Questo documento deriva dai sorgenti. Per ogni dettaglio fanno fede i contratti d'interfaccia nelle intestazioni delle macro e delle subroutine.

<a id="contenuto"></a>
## Contenuto

| Modulo | Utilità | Descrizione |
|---|---|---|
| [`ascii_7bit.asm`](#modulo-ascii_7bit) | Blocco 0 (0-31) | Codici di controllo ASCII |
| | Blocco 1 (32-63) | Spazio, punteggiatura e cifre |
| | Blocco 2 (64-95) | Chiocciola, lettere maiuscole e parentesi quadre |
| | Blocco 3 (96-127) | Lettere minuscole, graffe e codice di cancellazione |
| [`basic_tools.asm`](#modulo-basic_tools) | [`m_Exit_To_BASIC`](#utilita-m_exit_to_basic) | Esce al prompt del BASIC |
| | [`LOMEM`](#utilita-lomem) | Sposta l'inizio della memoria BASIC |
| | [`HIMEM`](#utilita-himem) | Sposta la fine della memoria BASIC |
| [`branch.asm`](#modulo-branch) | [`m_Bra`](#utilita-m_bra) | Salta sempre |
| | [`m_Brn`](#utilita-m_brn) | Salta mai |
| | [`m_Bhi`](#utilita-m_bhi) | Salta se più alto (.A > M senza segno) |
| | [`m_Bhs`](#utilita-m_bhs) | Salta se più alto o uguale (.A >= M senza segno) |
| | [`m_Blo`](#utilita-m_blo) | Salta se più basso (.A < M senza segno) |
| | [`m_Bls`](#utilita-m_bls) | Salta se più basso o uguale (.A <= M senza segno) |
| | [`m_Bgt`](#utilita-m_bgt) | Salta se maggiore (.A > M con segno) |
| | [`m_Bge`](#utilita-m_bge) | Salta se maggiore o uguale (.A >= M con segno) |
| | [`m_Blt`](#utilita-m_blt) | Salta se minore (.A < M con segno) |
| | [`m_Ble`](#utilita-m_ble) | Salta se minore o uguale (.A <= M con segno) |
| | [`m_L_Bra`](#utilita-m_l_bra) | Salta lungo sempre |
| | [`m_L_Brn`](#utilita-m_l_brn) | Salta lungo mai |
| | [`m_L_Bhi`](#utilita-m_l_bhi) | Salta lungo se più alto (senza segno) |
| | [`m_L_Bhs`](#utilita-m_l_bhs) | Salta lungo se più alto o uguale (senza segno) |
| | [`m_L_Blo`](#utilita-m_l_blo) | Salta lungo se più basso (senza segno) |
| | [`m_L_Bls`](#utilita-m_l_bls) | Salta lungo se più basso o uguale (senza segno) |
| | [`m_L_Bgt`](#utilita-m_l_bgt) | Salta lungo se maggiore (con segno) |
| | [`m_L_Bge`](#utilita-m_l_bge) | Salta lungo se maggiore o uguale (con segno) |
| | [`m_L_Blt`](#utilita-m_l_blt) | Salta lungo se minore (con segno) |
| | [`m_L_Ble`](#utilita-m_l_ble) | Salta lungo se minore o uguale (con segno) |
| | [`m_L_Bcc`](#utilita-m_l_bcc) | Salta lungo se Carry = 0 |
| | [`m_L_Bcs`](#utilita-m_l_bcs) | Salta lungo se Carry = 1 |
| | [`m_L_Beq`](#utilita-m_l_beq) | Salta lungo se Zero = 1 (Equal) |
| | [`m_L_Bne`](#utilita-m_l_bne) | Salta lungo se Zero = 0 (Not Equal) |
| | [`m_L_Bpl`](#utilita-m_l_bpl) | Salta lungo se Negative = 0 (Plus) |
| | [`m_L_Bmi`](#utilita-m_l_bmi) | Salta lungo se Negative = 1 (Minus) |
| | [`m_L_Bvc`](#utilita-m_l_bvc) | Salta lungo se oVerflow = 0 (Clear) |
| | [`m_L_Bvs`](#utilita-m_l_bvs) | Salta lungo se oVerflow = 1 (Set) |
| [`errors.asm`](#modulo-errors) | Codici d'errore del BASIC | Codici dei messaggi d'errore del BASIC 2.0 |
| [`keycodes.asm`](#modulo-keycodes) | Codici della tastiera | Codici della matrice della tastiera |
| [`petscii.asm`](#modulo-petscii) | Codici PETSCII per la selezione del colore di sfondo nella stampa in modo ECM | Codici di selezione del colore di sfondo ECM |
| | Blocco 0 (0-31) | Codici di controllo e di colore |
| | Blocco 1 (32-63) | Spazio, punteggiatura e cifre |
| | Blocco 2 (64-95) | Chiocciola, lettere e simboli |
| | Blocco 3 (96-127) | Grafici (duplicati di altri blocchi) |
| | Blocco 4 (128-159) | Codici di controllo e di colore |
| | Blocco 5 (160-191) | Grafici Commodore |
| | Blocco 6 (192-223) | Grafici con Shift |
| | Blocco 7 (224-255) | Grafici (duplicati di altri blocchi) |
| | Blocco sostitutivo | Grafici che sostituiscono i caratteri ASCII assenti nel C64 |
| [`screencodes.asm`](#modulo-screencodes) | Blocco 0 (0-31) | Chiocciola, lettere e simboli |
| | Blocco 1 (32-63) | Spazio, punteggiatura e cifre |
| | Blocco 2 (64-95) | Grafici con Shift |
| | Blocco 3 (96-127) | Grafici Commodore |
| | Blocco 4 (128-159) | Caratteri del blocco 0 in campo inverso |
| | Blocco 5 (160-191) | Caratteri del blocco 1 in campo inverso |
| | Blocco 6 (192-223) | Caratteri del blocco 2 in campo inverso |
| | Blocco 7 (224-255) | Caratteri del blocco 3 in campo inverso |
| | Blocco sostitutivo | Grafici che sostituiscono i caratteri ASCII assenti nel C64 |
| [`standard.asm`](#modulo-standard) | [`m_BASIC_Preamble`](#utilita-m_basic_preamble) | Inserisce una riga BASIC con SYS |
| | [`m_Swap8`](#utilita-m_swap8) | Scambia due valori a 8 bit |
| | [`m_Push_AXY`](#utilita-m_push_axy) | Salva .A, .X e .Y sullo stack |
| | [`m_Pull_AXY`](#utilita-m_pull_axy) | Recupera .A, .X e .Y dallo stack |
| | [`m_Push_XY`](#utilita-m_push_xy) | Salva .X e .Y sullo stack |
| | [`m_Pull_XY`](#utilita-m_pull_xy) | Recupera .X e .Y dallo stack |
| | [`m_SeV`](#utilita-m_sev) | Imposta il flag oVerflow |
| | [`m_CCf`](#utilita-m_ccf) | Complementa il flag Carry |
| | [`m_Skip1`](#utilita-m_skip1) | Maschera l'istruzione seguente (1 byte) |
| | [`m_Skip2`](#utilita-m_skip2) | Maschera l'istruzione seguente (2 byte) |
| | [`m_Delay_5n1`](#utilita-m_delay_5n1) | Consuma 5n+1 cicli a vuoto |

## Uso

### Inclusione

La cartella `system` sta nella cartella delle librerie di C64Studio, accanto alle altre librerie di sistema. Il sorgente principale del programma include i file di simboli che usa nella parte dedicata ai simboli e i moduli con codice nella parte dedicata al codice:

```
!source <system/petscii.asm>, once
!source <system/standard.asm>, once
```

La libreria non ha un modulo principale: ogni modulo si include da sé e nessun modulo include altri file. Gli altri file che un modulo richiede arrivano dal programma, che li include prima, nella parte dedicata ai simboli (ultima colonna):

| Modulo | Include da sé | File da includere prima |
|---|---|---|
| `ascii_7bit.asm` | Nessuno | Nessuno |
| `basic_tools.asm` | Nessuno | `<c64/symbols.asm>`, `<system/errors.asm>` |
| `branch.asm` | Nessuno | Nessuno |
| `errors.asm` | Nessuno | Nessuno |
| `keycodes.asm` | Nessuno | Nessuno |
| `petscii.asm` | Nessuno | Nessuno |
| `screencodes.asm` | Nessuno | Nessuno |
| `standard.asm` | Nessuno | `<c64/symbols.asm>` |

### Configurazione

Le macro si assemblano quando vengono invocate. Ogni subroutine viene assemblata solo se il suo parametro vale `1` nella copia di `config.asm` della Soluzione. Nel template tutti i parametri valgono `0`.

| Parametro | Subroutine | Richiede anche |
|---|---|---|
| `__USE_LOMEM` | `LOMEM` |  |
| `__USE_HIMEM` | `HIMEM` |  |

Una parte dei file di simboli è condizionata.

| Parametro | Modulo | Valore nel template | Effetto |
|---|---|---|---|
| `__C128_C64_MODE` | `keycodes.asm` | `0` | 1 = aggiunge i codici extra del C128 (da `$40` a `$57`) e sposta `KEYCODE_NO_KEY` a `$58` |

Il parametro si definisce nella copia di `config.asm` della Soluzione e deve essere definito prima dell'inclusione di `keycodes.asm`.

<a id="modulo-ascii_7bit"></a>
## ascii_7bit.asm

Codici ASCII a 7 bit, con simboli `ASCII_<descrizione>`.

I codici da 0 a 127 sono divisi in quattro blocchi di 32. Il file non contiene codice eseguibile.

| Gruppo | Simboli | Contenuto |
|---|---|---|
| Blocco 0 (0-31) | 32 | Da `ASCII_NULL` (`$00`) a `ASCII_CTRL_UNDERSCORE` (`$1F`) |
| Blocco 1 (32-63) | 32 | Da `ASCII_SPACE` (`$20`) a `ASCII_QUESTION_MARK` (`$3F`) |
| Blocco 2 (64-95) | 32 | Da `ASCII_AT_SIGN` (`$40`) a `ASCII_UNDERSCORE` (`$5F`) |
| Blocco 3 (96-127) | 32 | Da `ASCII_GRAVE_ACCENT` (`$60`) a `ASCII_DELETE` (`$7F`) |

[↑ Torna al contenuto](#contenuto)

<a id="modulo-basic_tools"></a>
## basic_tools.asm

Utilità per la manipolazione dell'area di memoria dedicata al BASIC ed ai programmi ivi contenuti.

<a id="utilita-m_exit_to_basic"></a>
### m_Exit_To_BASIC

Termina un programma in linguaggio macchina e torna al prompt del BASIC, passando per il gestore degli errori.

| Voce | Contenuto |
|---|---|
| Input | Nessuno |
| Output | `.PC` (2 byte, CPU): Indirizzo contenuto nel vettore `IERROR` |
| Variazione Stack | Azzerato |
| Registri Modificati | `.X`, `.P` (Negative, Zero), `.S` |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-lomem"></a>
### LOMEM

Sposta l'inizio della memoria dedicata al BASIC aggiornando la variabile di sistema `TXTTAB`. La subroutine richiede un puntatore precedente all'indirizzo che conterrà il primo carattere del testo del programma. Al termine i puntatori del BASIC conterranno il valore del puntatore incrementato di 1. L'esecuzione ritorna al BASIC.

| Voce | Contenuto |
|---|---|
| Input | `.X` (1 byte, CPU): Indirizzo del puntatore alla locazione iniziale dell'area BASIC meno 1 |
| Output | `puntatore` (2 byte, ZP): Incrementato di 1<br>`TXTTAB` (2 byte, ZP): Nuovo inizio dell'area BASIC<br>`.PC` (2 byte, CPU): Ritorno al BASIC |
| Variazione Stack | Azzerato |
| Registri Modificati | `.A`, `.X`, `.Y`, `.P` (Negative, oVerflow, Zero, Carry), `.S`, `TXTTAB`, `VARTAB`, `ARYTAB`, `STREND`, `FRETOP`, `TXTPTR` |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-himem"></a>
### HIMEM

Sposta la fine della memoria dedicata al BASIC aggiornando la variabile di sistema `MEMSIZ`. L'esecuzione ritorna al BASIC.

| Voce | Contenuto |
|---|---|
| Input | `.X` (1 byte, CPU): Indirizzo del puntatore alla locazione finale dell'area BASIC |
| Output | `MEMSIZ` (2 byte, ZP): Nuova fine dell'area BASIC<br>`.PC` (2 byte, CPU): Ritorno al BASIC |
| Variazione Stack | Azzerato |
| Registri Modificati | `.A`, `.X`, `.Y`, `.P` (Negative, oVerflow, Zero, Carry), `.S`, `MEMSIZ`, `FRETOP`, `ARYTAB`, `STREND` |

[↑ Torna al contenuto](#contenuto)

<a id="modulo-branch"></a>
## branch.asm

Macro per salti condizionati relativi e con flag di oVerflow.

<a id="utilita-m_bra"></a>
### m_Bra

Chiamata: `+m_Bra .addr_`

Salta sempre.

| Voce | Contenuto |
|---|---|
| Input | `.addr_` (2 byte, Macro): Indirizzo di destinazione |
| Output | Nessuno |
| Registri Modificati | Nessuno |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_brn"></a>
### m_Brn

Chiamata: `+m_Brn .addr_`

Salta mai.

| Voce | Contenuto |
|---|---|
| Input | `.addr_` (2 byte, Macro): Indirizzo (ignorato) |
| Output | Nessuno |
| Registri Modificati | Nessuno |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_bhi"></a>
### m_Bhi

Chiamata: `+m_Bhi .addr_`

Salta se più alto (`.A` > M senza segno).

| Voce | Contenuto |
|---|---|
| Input | `.addr_` (2 byte, Macro): Indirizzo di destinazione |
| Output | Nessuno |
| Registri Modificati | Nessuno |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_bhs"></a>
### m_Bhs

Chiamata: `+m_Bhs .addr_`

Salta se più alto o uguale (`.A` >= M senza segno).

| Voce | Contenuto |
|---|---|
| Input | `.addr_` (2 byte, Macro): Indirizzo di destinazione |
| Output | Nessuno |
| Registri Modificati | Nessuno |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_blo"></a>
### m_Blo

Chiamata: `+m_Blo .addr_`

Salta se più basso (`.A` < M senza segno).

| Voce | Contenuto |
|---|---|
| Input | `.addr_` (2 byte, Macro): Indirizzo di destinazione |
| Output | Nessuno |
| Registri Modificati | Nessuno |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_bls"></a>
### m_Bls

Chiamata: `+m_Bls .addr_`

Salta se più basso o uguale (`.A` <= M senza segno).

| Voce | Contenuto |
|---|---|
| Input | `.addr_` (2 byte, Macro): Indirizzo di destinazione |
| Output | Nessuno |
| Registri Modificati | Nessuno |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_bgt"></a>
### m_Bgt

Chiamata: `+m_Bgt .addr_`

Salta se maggiore (`.A` > M con segno).

| Voce | Contenuto |
|---|---|
| Input | `.addr_` (2 byte, Macro): Indirizzo di destinazione |
| Output | Nessuno |
| Registri Modificati | Nessuno |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_bge"></a>
### m_Bge

Chiamata: `+m_Bge .addr_`

Salta se maggiore o uguale (`.A` >= M con segno).

| Voce | Contenuto |
|---|---|
| Input | `.addr_` (2 byte, Macro): Indirizzo di destinazione |
| Output | Nessuno |
| Registri Modificati | Nessuno |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_blt"></a>
### m_Blt

Chiamata: `+m_Blt .addr_`

Salta se minore (`.A` < M con segno).

| Voce | Contenuto |
|---|---|
| Input | `.addr_` (2 byte, Macro): Indirizzo di destinazione |
| Output | Nessuno |
| Registri Modificati | Nessuno |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_ble"></a>
### m_Ble

Chiamata: `+m_Ble .addr_`

Salta se minore o uguale (`.A` <= M con segno).

| Voce | Contenuto |
|---|---|
| Input | `.addr_` (2 byte, Macro): Indirizzo di destinazione |
| Output | Nessuno |
| Registri Modificati | Nessuno |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_l_bra"></a>
### m_L_Bra

Chiamata: `+m_L_Bra .addr_`

Salta lungo sempre.

| Voce | Contenuto |
|---|---|
| Input | `.addr_` (2 byte, Macro): Indirizzo di destinazione |
| Output | Nessuno |
| Registri Modificati | Nessuno |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_l_brn"></a>
### m_L_Brn

Chiamata: `+m_L_Brn .addr_`

Salta lungo mai.

| Voce | Contenuto |
|---|---|
| Input | `.addr_` (2 byte, Macro): Indirizzo (ignorato) |
| Output | Nessuno |
| Registri Modificati | Nessuno |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_l_bhi"></a>
### m_L_Bhi

Chiamata: `+m_L_Bhi .addr_`

Salta lungo se più alto (senza segno).

| Voce | Contenuto |
|---|---|
| Input | `.addr_` (2 byte, Macro): Indirizzo di destinazione |
| Output | Nessuno |
| Registri Modificati | Nessuno |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_l_bhs"></a>
### m_L_Bhs

Chiamata: `+m_L_Bhs .addr_`

Salta lungo se più alto o uguale (senza segno).

| Voce | Contenuto |
|---|---|
| Input | `.addr_` (2 byte, Macro): Indirizzo di destinazione |
| Output | Nessuno |
| Registri Modificati | Nessuno |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_l_blo"></a>
### m_L_Blo

Chiamata: `+m_L_Blo .addr_`

Salta lungo se più basso (senza segno).

| Voce | Contenuto |
|---|---|
| Input | `.addr_` (2 byte, Macro): Indirizzo di destinazione |
| Output | Nessuno |
| Registri Modificati | Nessuno |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_l_bls"></a>
### m_L_Bls

Chiamata: `+m_L_Bls .addr_`

Salta lungo se più basso o uguale (senza segno).

| Voce | Contenuto |
|---|---|
| Input | `.addr_` (2 byte, Macro): Indirizzo di destinazione |
| Output | Nessuno |
| Registri Modificati | Nessuno |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_l_bgt"></a>
### m_L_Bgt

Chiamata: `+m_L_Bgt .addr_`

Salta lungo se maggiore (con segno).

| Voce | Contenuto |
|---|---|
| Input | `.addr_` (2 byte, Macro): Indirizzo di destinazione |
| Output | Nessuno |
| Registri Modificati | Nessuno |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_l_bge"></a>
### m_L_Bge

Chiamata: `+m_L_Bge .addr_`

Salta lungo se maggiore o uguale (con segno).

| Voce | Contenuto |
|---|---|
| Input | `.addr_` (2 byte, Macro): Indirizzo di destinazione |
| Output | Nessuno |
| Registri Modificati | Nessuno |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_l_blt"></a>
### m_L_Blt

Chiamata: `+m_L_Blt .addr_`

Salta lungo se minore (con segno).

| Voce | Contenuto |
|---|---|
| Input | `.addr_` (2 byte, Macro): Indirizzo di destinazione |
| Output | Nessuno |
| Registri Modificati | Nessuno |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_l_ble"></a>
### m_L_Ble

Chiamata: `+m_L_Ble .addr_`

Salta lungo se minore o uguale (con segno).

| Voce | Contenuto |
|---|---|
| Input | `.addr_` (2 byte, Macro): Indirizzo di destinazione |
| Output | Nessuno |
| Registri Modificati | Nessuno |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_l_bcc"></a>
### m_L_Bcc

Chiamata: `+m_L_Bcc .addr_`

Salta lungo se Carry = 0.

| Voce | Contenuto |
|---|---|
| Input | `.addr_` (2 byte, Macro): Indirizzo di destinazione |
| Output | Nessuno |
| Registri Modificati | Nessuno |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_l_bcs"></a>
### m_L_Bcs

Chiamata: `+m_L_Bcs .addr_`

Salta lungo se Carry = 1.

| Voce | Contenuto |
|---|---|
| Input | `.addr_` (2 byte, Macro): Indirizzo di destinazione |
| Output | Nessuno |
| Registri Modificati | Nessuno |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_l_beq"></a>
### m_L_Beq

Chiamata: `+m_L_Beq .addr_`

Salta lungo se Zero = 1 (Equal).

| Voce | Contenuto |
|---|---|
| Input | `.addr_` (2 byte, Macro): Indirizzo di destinazione |
| Output | Nessuno |
| Registri Modificati | Nessuno |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_l_bne"></a>
### m_L_Bne

Chiamata: `+m_L_Bne .addr_`

Salta lungo se Zero = 0 (Not Equal).

| Voce | Contenuto |
|---|---|
| Input | `.addr_` (2 byte, Macro): Indirizzo di destinazione |
| Output | Nessuno |
| Registri Modificati | Nessuno |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_l_bpl"></a>
### m_L_Bpl

Chiamata: `+m_L_Bpl .addr_`

Salta lungo se Negative = 0 (Plus).

| Voce | Contenuto |
|---|---|
| Input | `.addr_` (2 byte, Macro): Indirizzo di destinazione |
| Output | Nessuno |
| Registri Modificati | Nessuno |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_l_bmi"></a>
### m_L_Bmi

Chiamata: `+m_L_Bmi .addr_`

Salta lungo se Negative = 1 (Minus).

| Voce | Contenuto |
|---|---|
| Input | `.addr_` (2 byte, Macro): Indirizzo di destinazione |
| Output | Nessuno |
| Registri Modificati | Nessuno |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_l_bvc"></a>
### m_L_Bvc

Chiamata: `+m_L_Bvc .addr_`

Salta lungo se oVerflow = 0 (Clear).

| Voce | Contenuto |
|---|---|
| Input | `.addr_` (2 byte, Macro): Indirizzo di destinazione |
| Output | Nessuno |
| Registri Modificati | Nessuno |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_l_bvs"></a>
### m_L_Bvs

Chiamata: `+m_L_Bvs .addr_`

Salta lungo se oVerflow = 1 (Set).

| Voce | Contenuto |
|---|---|
| Input | `.addr_` (2 byte, Macro): Indirizzo di destinazione |
| Output | Nessuno |
| Registri Modificati | Nessuno |

[↑ Torna al contenuto](#contenuto)

<a id="modulo-errors"></a>
## errors.asm

Codici dei messaggi d'errore del BASIC 2.0, da `ERR_TOO_MANY_FILES` (`$01`) a `ERR_BREAK` (`$1E`), più `ERR_READY` (`$80`). I primi nove coincidono per nome e valore con i codici d'errore del Kernal di `<c64/kernal.asm>`, che hanno il prefisso `K_ERR_`.

| Gruppo | Simboli | Contenuto |
|---|---|---|
| Codici d'errore del BASIC | 31 | Da `ERR_TOO_MANY_FILES` (`$01`) a `ERR_READY` (`$80`) |

[↑ Torna al contenuto](#contenuto)

<a id="modulo-keycodes"></a>
## keycodes.asm

Codici della matrice della tastiera, nella forma `KEYCODE_<tasto>`: da `KEYCODE_DELETE` (`$00`) a `KEYCODE_STOP` (`$3F`), 64 codici. `KEYCODE_NO_KEY` segue l'ultimo codice e sul C64 vale `$40`. Con `__C128_C64_MODE = 1` il file aggiunge i codici extra del C128, da `KEYCODE_HELP` (`$40`) a `KEYCODE_NO_SCROLL` (`$57`), e sposta `KEYCODE_NO_KEY` a `$58`.

| Gruppo | Simboli | Contenuto |
|---|---|---|
| Codici della tastiera | 64 | Da `KEYCODE_DELETE` (`$00`) a `KEYCODE_STOP` (`$3F`) |

[↑ Torna al contenuto](#contenuto)

<a id="modulo-petscii"></a>
## petscii.asm

Codici PETSCII, indicati con simboli `PETSCII_<descrizione>`, e codici per la selezione del colore di sfondo nella stampa in modo ECM (da `ECM_BG0` a `ECM_BG3`).

Un codice con più simboli ha il simbolo principale senza suffisso e gli altri con il suffisso `_ALT` (`_ALT_2` per il terzo): il loro commento dice «Duplicato di». Il gruppo «Blocco sostitutivo» elenca i grafici che sostituiscono gli otto caratteri ASCII assenti nel C64 e il codice di cancellazione: i simboli hanno il nome del carattere ASCII (`PETSCII_BACKSLASH`, `PETSCII_TILDE`, …) o il suffisso `_SUBSTITUTE` (`PETSCII_DELETE_SUBSTITUTE`), e il commento dice «Sostituto di».

| Gruppo | Simboli | Contenuto |
|---|---|---|
| Codici PETSCII per la selezione del colore di sfondo nella stampa in modo ECM | 4 | Da `ECM_BG0` (`$01`) a `ECM_BG3` (`$04`) |
| Blocco 0 (0-31) | 32 | Da `PETSCII_NULL` (`$00`) a `PETSCII_BLUE` (`$1F`) |
| Blocco 1 (32-63) | 32 | Da `PETSCII_SPACE` (`$20`) a `PETSCII_QUESTION_MARK` (`$3F`) |
| Blocco 2 (64-95) | 32 | Da `PETSCII_AT_SIGN` (`$40`) a `PETSCII_LEFT_ARROW` (`$5F`) |
| Blocco 3 (96-127) | 32 | Da `PETSCII_SHIFT_ASTERISK_ALT` (`$60`) a `PETSCII_COMMODORE_ASTERISK_ALT` (`$7F`) |
| Blocco 4 (128-159) | 32 | Da `PETSCII_CTRL_SHIFT_AT_SIGN` (`$80`) a `PETSCII_CYAN` (`$9F`) |
| Blocco 5 (160-191) | 32 | Da `PETSCII_SHIFT_SPACE` (`$A0`) a `PETSCII_COMMODORE_B` (`$BF`) |
| Blocco 6 (192-223) | 32 | Da `PETSCII_SHIFT_ASTERISK` (`$C0`) a `PETSCII_COMMODORE_ASTERISK` (`$DF`) |
| Blocco 7 (224-255) | 32 | Da `PETSCII_SHIFT_SPACE_ALT` (`$E0`) a `PETSCII_SHIFT_UP_ARROW` (`$FF`) |
| Blocco sostitutivo | 16 | Da `PETSCII_BACKSLASH` (`$BF`) a `PETSCII_DELETE_SUBSTITUTE_ALT` (`$E6`) |

[↑ Torna al contenuto](#contenuto)

<a id="modulo-screencodes"></a>
## screencodes.asm

Codici Schermo, indicati con simboli `SCREEN_<descrizione>`. I codici in modo inverso (128-255) hanno il suffisso `_REVERSE`.

I simboli in modo inverso hanno il suffisso `_REVERSE` e nel commento «Inverso di». Il gruppo «Blocco sostitutivo» elenca i grafici che sostituiscono gli otto caratteri ASCII assenti nel C64 e il codice di cancellazione, con il nome del carattere ASCII (`SCREEN_BACKSLASH`, `SCREEN_TILDE`, …) o con il suffisso `_SUBSTITUTE` (`SCREEN_DELETE_SUBSTITUTE`); il commento dice «Sostituto di».

| Gruppo | Simboli | Contenuto |
|---|---|---|
| Blocco 0 (0-31) | 32 | Da `SCREEN_AT_SIGN` (`$00`) a `SCREEN_LEFT_ARROW` (`$1F`) |
| Blocco 1 (32-63) | 32 | Da `SCREEN_SPACE` (`$20`) a `SCREEN_QUESTION_MARK` (`$3F`) |
| Blocco 2 (64-95) | 32 | Da `SCREEN_SHIFT_ASTERISK` (`$40`) a `SCREEN_COMMODORE_ASTERISK` (`$5F`) |
| Blocco 3 (96-127) | 32 | Da `SCREEN_SHIFT_SPACE` (`$60`) a `SCREEN_COMMODORE_B` (`$7F`) |
| Blocco 4 (128-159) | 32 | Da `SCREEN_AT_SIGN_REVERSE` (`$80`) a `SCREEN_LEFT_ARROW_REVERSE` (`$9F`) |
| Blocco 5 (160-191) | 32 | Da `SCREEN_SPACE_REVERSE` (`$A0`) a `SCREEN_QUESTION_MARK_REVERSE` (`$BF`) |
| Blocco 6 (192-223) | 32 | Da `SCREEN_SHIFT_ASTERISK_REVERSE` (`$C0`) a `SCREEN_COMMODORE_ASTERISK_REVERSE` (`$DF`) |
| Blocco 7 (224-255) | 32 | Da `SCREEN_SHIFT_SPACE_REVERSE` (`$E0`) a `SCREEN_COMMODORE_B_REVERSE` (`$FF`) |
| Blocco sostitutivo | 9 | Da `SCREEN_BACKSLASH` (`$7F`) a `SCREEN_DELETE_SUBSTITUTE` (`$66`) |

[↑ Torna al contenuto](#contenuto)

<a id="modulo-standard"></a>
## standard.asm

Macro utili per la programmazione.

<a id="utilita-m_basic_preamble"></a>
### m_BASIC_Preamble

Chiamata: `+m_BASIC_Preamble .line_num_, .label_, .comment_`

Inserisce una riga di BASIC con un comando `SYS` ed, opzionalmente, un commento `REM`.

| Voce | Contenuto |
|---|---|
| Input | `.line_num_` (2 byte, Macro): Numero di riga<br>`.label_` (2 byte, Macro): Etichetta del punto di ingresso<br>`.comment_` (stringa, Macro): (opzionale) Commento aggiunto come `REM` |
| Output | Nessuno |
| Registri Modificati | Nessuno |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_swap8"></a>
### m_Swap8

Chiamata: `+m_Swap8 .addr1_, .addr2_`

Scambia i valori contenuti in due locazioni di memoria a 8 bit, usando `.X` e `.Y`.

| Voce | Contenuto |
|---|---|
| Input | `.addr1_` (1 o 2 byte, Macro): Indirizzo del primo valore<br>`.addr2_` (1 o 2 byte, Macro): Indirizzo del secondo valore |
| Output | Nessuno |
| Registri Modificati | `.X`, `.Y`, `.P` (Negative, Zero) |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_push_axy"></a>
### m_Push_AXY

Copia i registri `.A`, `.X` e `.Y` sullo stack.

| Voce | Contenuto |
|---|---|
| Input | Nessuno |
| Output | Nessuno |
| Variazione Stack | Decrementato di 3 byte |
| Registri Modificati | `.A`, `.P` (Negative, Zero) |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_pull_axy"></a>
### m_Pull_AXY

Recupera i registri `.A`, `.X` e `.Y` dallo stack.

| Voce | Contenuto |
|---|---|
| Input | Nessuno |
| Output | Nessuno |
| Variazione Stack | Incrementato di 3 byte |
| Registri Modificati | `.A`, `.X`, `.Y`, `.P` (Negative, Zero) |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_push_xy"></a>
### m_Push_XY

Copia i registri `.X` e `.Y` sullo stack, riservando prima una posizione per `.A`, che `m_Pull_XY` userà per ripristinarlo.

| Voce | Contenuto |
|---|---|
| Input | Nessuno |
| Output | Nessuno |
| Variazione Stack | Decrementato di 3 byte |
| Registri Modificati | `.A`, `.P` (Negative, Zero) |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_pull_xy"></a>
### m_Pull_XY

Recupera i registri `.X` e `.Y` dallo stack, lasciando invariato `.A`.

| Voce | Contenuto |
|---|---|
| Input | Nessuno |
| Output | Nessuno |
| Variazione Stack | Incrementato di 3 byte |
| Registri Modificati | `.X`, `.Y`, `.P` (Negative, Zero) |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_sev"></a>
### m_SeV

Imposta il flag oVerflow senza alterare gli altri flag: spreca cicli ed istruzioni.

| Voce | Contenuto |
|---|---|
| Input | Nessuno |
| Output | oVerflow (1 bit, .P): sempre 1 |
| Registri Modificati | `.A`, `.P` (oVerflow) |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_ccf"></a>
### m_CCf

Complementa il flag Carry senza alterare gli altri flag: spreca cicli ed istruzioni.

| Voce | Contenuto |
|---|---|
| Input | Nessuno |
| Output | Carry (1 bit, .P): 0 = prima era 1; 1 = prima era 0 |
| Registri Modificati | `.A`, `.P` (Carry) |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_skip1"></a>
### m_Skip1

Inserisce l'istruzione illegale NOP #imm (2 cicli) in modo da mascherare l'istruzione da un byte che segue, senza alterare i flag. Il byte emesso è l'opcode di NOP: il primo byte dell'istruzione seguente ne diventa l'operando e non viene eseguito.

| Voce | Contenuto |
|---|---|
| Input | Nessuno |
| Output | Nessuno |
| Registri Modificati | Nessuno |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_skip2"></a>
### m_Skip2

Inserisce l'istruzione illegale NOP abs (4 cicli) in modo da mascherare l'istruzione da due byte che segue, senza alterare i flag. Il byte emesso è l'opcode di NOP: i due byte dell'istruzione seguente ne diventano l'operando e non vengono eseguiti.

| Voce | Contenuto |
|---|---|
| Input | Nessuno |
| Output | Nessuno |
| Registri Modificati | Nessuno |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_delay_5n1"></a>
### m_Delay_5n1

Chiamata: `+m_Delay_5n1 .reg_, .n_`

Consuma un numero di cicli pari a 5n+1 con un ciclo di attesa su `.X` o `.Y`.

| Voce | Contenuto |
|---|---|
| Input | `.reg_` (stringa, Macro): Registro contatore: "`.X`" oppure "`.Y`"<br>`.n_` (1 byte, Macro): Parametro n di 5n+1 (n = 0 equivale a n = 256) |
| Output | Nessuno |
| Registri Modificati | `.reg_` (`.X` o `.Y`), `.P` (Negative, Zero) |

[↑ Torna al contenuto](#contenuto)

<a id="limiti-noti"></a>
## Limiti noti

I sorgenti non dichiarano limiti.

[↑ Torna al contenuto](#contenuto)
