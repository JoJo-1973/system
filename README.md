# system

Utilità di sistema per il Commodore 64: gestione dei banchi di memoria del 6510 e del BASIC, salti condizionati, interruzioni NMI e di raster, stampa di messaggi, modi grafici del VIC-II e macro di uso generale. La libreria `system` fa parte della Libreria di Sistema (progetto `system.c64`) ed è scritta in assembly 6510 per C64Studio (sintassi ACME).

Questo documento deriva dai sorgenti. Per ogni dettaglio fanno fede i contratti d'interfaccia nelle intestazioni delle macro e delle subroutine.

<a id="contenuto"></a>
## Contenuto

| Modulo | Utilità | Descrizione |
|---|---|---|
| [`6510_tools.asm`](#modulo-6510_tools) | [`m_Disable_BASIC`](#utilita-m_disable_basic) | Disabilita la ROM del BASIC |
| | [`m_Enable_BASIC`](#utilita-m_enable_basic) | Riabilita la ROM del BASIC |
| | [`m_Disable_Kernal`](#utilita-m_disable_kernal) | Disabilita la ROM del Kernal |
| | [`m_Enable_Kernal`](#utilita-m_enable_kernal) | Riabilita la ROM del Kernal |
| | [`m_Disable_IO`](#utilita-m_disable_io) | Disabilita l'I/O (rende visibile CHARGEN) |
| | [`m_Enable_IO`](#utilita-m_enable_io) | Riabilita l'I/O |
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
| [`nmi_tools.asm`](#modulo-nmi_tools) | [`NMI_HIBASE`](#utilita-nmi_hibase) | Resetta HIBASE dopo RUN/STOP + RESTORE |
| | [`NMI_RESTORE`](#utilita-nmi_restore) | Ripristina il vettore NMI originale |
| [`print_tools.asm`](#modulo-print_tools) | [`m_At`](#utilita-m_at) | Posiziona il cursore sullo schermo |
| | [`PLOT_CHAR`](#utilita-plot_char) | Memorizza un carattere nella memoria schermo |
| | [`COLOR_CHAR`](#utilita-color_char) | Cambia il colore di un carattere |
| | [`PRINT_MSG`](#utilita-print_msg) | Stampa una tabella di messaggi |
| | [`PRINT_NTH`](#utilita-print_nth) | Stampa un messaggio estratto da una tabella |
| | [`PRINT_RAW`](#utilita-print_raw) | Stampa un messaggio puntato da .A / .Y |
| | [`PRINT_IMM`](#utilita-print_imm) | Stampa il messaggio che segue la chiamata |
| | [`m_Put_ECM_Char`](#utilita-m_put_ecm_char) | Invia un carattere gestendo il modo ECM |
| [`raster_tools.asm`](#modulo-raster_tools) | [`m_Init_Raster_System`](#utilita-m_init_raster_system) | Prepara il sistema ai Raster IRQ |
| | [`m_Start_Raster_IRQ`](#utilita-m_start_raster_irq) | Avvia una catena di Raster IRQ |
| | [`m_Enter_Raster_IRQ`](#utilita-m_enter_raster_irq) | Entra in un gestore Raster IRQ |
| | [`m_Next_Raster_IRQ`](#utilita-m_next_raster_irq) | Prepara il prossimo Raster IRQ, esce |
| | [`m_Set_Rasterline`](#utilita-m_set_rasterline) | Imposta la linea di raster di confronto |
| | [`m_Raster_Grip`](#utilita-m_raster_grip) | Compensa i cicli extra del VIC-II NTSC |
| | [`m_Start_Unstable_IRQ`](#utilita-m_start_unstable_irq) | Avvia una catena di IRQ instabili |
| | [`m_Enter_Unstable_IRQ`](#utilita-m_enter_unstable_irq) | Entra in un gestore IRQ instabile |
| | [`m_Next_Unstable_IRQ`](#utilita-m_next_unstable_irq) | Prepara il prossimo IRQ instabile, esce |
| | [`m_Start_Stable_IRQ`](#utilita-m_start_stable_irq) | Avvia una catena di IRQ stabili |
| | [`m_Enter_Stable_IRQ`](#utilita-m_enter_stable_irq) | Entra in un gestore IRQ stabile |
| | [`m_Next_Stable_IRQ`](#utilita-m_next_stable_irq) | Prepara il prossimo IRQ stabile, esce |
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
| [`vic_ii_tools.asm`](#modulo-vic_ii_tools) | [`m_VIC_Bitmap_On`](#utilita-m_vic_bitmap_on) | Abilita il modo bitmap |
| | [`m_VIC_Bitmap_Off`](#utilita-m_vic_bitmap_off) | Disabilita il modo bitmap |
| | [`m_VIC_Ext_Color_On`](#utilita-m_vic_ext_color_on) | Abilita il modo ECM |
| | [`m_VIC_Ext_Color_Off`](#utilita-m_vic_ext_color_off) | Disabilita il modo ECM |
| | [`m_VIC_Multicolor_On`](#utilita-m_vic_multicolor_on) | Abilita il modo multicolore |
| | [`m_VIC_Multicolor_Off`](#utilita-m_vic_multicolor_off) | Disabilita il modo multicolore |
| | [`VIC_PALETTE`](#utilita-vic_palette) | Imposta i registri colore del VIC-II |
| | [`VIC_BANK`](#utilita-vic_bank) | Seleziona il banco di memoria del VIC-II |
| | [`VIC_SCREEN`](#utilita-vic_screen) | Posiziona la memoria schermo |
| | [`VIC_CHARGEN`](#utilita-vic_chargen) | Posiziona il generatore di caratteri |
| | [`VIC_BITMAP`](#utilita-vic_bitmap) | Posiziona la memoria ad alta risoluzione |
| | [`VIC_COPY_CHARGEN`](#utilita-vic_copy_chargen) | Sposta il generatore di caratteri in RAM |
| | [`COMPUTE_CELL_ADDRESS`](#utilita-compute_cell_address) | Calcola l'indirizzo di una cella video |
| | [`GET_SCREEN_CELL`](#utilita-get_screen_cell) | Legge una cella della memoria schermo |
| | [`GET_COLOR_CELL`](#utilita-get_color_cell) | Legge una cella della memoria colore |

## Uso

### Inclusione

La cartella `system` sta nella cartella delle librerie di C64Studio, accanto alle altre librerie di sistema. Il sorgente principale del programma include i moduli che usa nella parte dedicata al codice:

```
!source <system/standard.asm>, once
!source <system/print_tools.asm>, once
```

La libreria non ha un modulo principale: ogni modulo si include da solo. `print_tools.asm` include a sua volta `vic_ii_tools.asm`; gli altri moduli non includono altri file. I simboli che i moduli usano arrivano da altri file, che il programma include prima, nella parte dedicata ai simboli (ultima colonna):

| Modulo | Include da sé | File da includere prima |
|---|---|---|
| `6510_tools.asm` | Nessuno | `<c64/symbols.asm>`, `<chip/cia.asm>` |
| `basic_tools.asm` | Nessuno | `<c64/errors.asm>`, `<c64/symbols.asm>` |
| `branch.asm` | Nessuno | Nessuno |
| `nmi_tools.asm` | Nessuno | `<c64/symbols.asm>` |
| `print_tools.asm` | `<system/vic_ii_tools.asm>` | `<c64/kernal.asm>`, `<c64/symbols.asm>`, `<chip/vic_ii.asm>`, `<io/chars.asm>`, `<mem/mem16.asm>`, `<system/branch.asm>`, `<system/standard.asm>` |
| `raster_tools.asm` | Nessuno | `<c64/symbols.asm>`, `<chip/cia.asm>`, `<chip/vic_ii.asm>`, `<system/6510_tools.asm>`, `<system/standard.asm>` |
| `standard.asm` | Nessuno | `<c64/symbols.asm>` |
| `vic_ii_tools.asm` | Nessuno | `<c64/symbols.asm>`, `<chip/cia.asm>`, `<chip/vic_ii.asm>`, `<system/6510_tools.asm>`, `<system/branch.asm>` |

### Configurazione

Le macro si assemblano quando vengono invocate. Ogni subroutine viene assemblata solo se il suo parametro vale `1` nella copia di `config.asm` della Soluzione. Nel template tutti i parametri valgono `0`.

| Parametro | Subroutine | Richiede anche |
|---|---|---|
| `__USE_LOMEM` | `LOMEM` |  |
| `__USE_HIMEM` | `HIMEM` |  |
| `__USE_NMI_HIBASE` | `NMI_HIBASE` |  |
| `__USE_NMI_RESTORE` | `NMI_RESTORE` |  |
| `__USE_PLOT_CHAR` | `PLOT_CHAR` | `__USE_COMPUTE_CELL_ADDRESS` |
| `__USE_COLOR_CHAR` | `COLOR_CHAR` | `__USE_COMPUTE_CELL_ADDRESS` |
| `__USE_PRINT_MSG` | `PRINT_MSG` |  |
| `__USE_PRINT_NTH` | `PRINT_NTH` | `__USE_PRINT_MSG` |
| `__USE_PRINT_RAW` | `PRINT_RAW` |  |
| `__USE_PRINT_IMM` | `PRINT_IMM` |  |
| `__USE_VIC_PALETTE` | `VIC_PALETTE` |  |
| `__USE_VIC_BANK` | `VIC_BANK` |  |
| `__USE_VIC_SCREEN` | `VIC_SCREEN` | `__USE_VIC_BANK` |
| `__USE_VIC_CHARGEN` | `VIC_CHARGEN` | `__USE_VIC_BANK` |
| `__USE_VIC_BITMAP` | `VIC_BITMAP` | `__USE_VIC_BANK` |
| `__USE_VIC_COPY_CHARGEN` | `VIC_COPY_CHARGEN` | `__USE_VIC_CHARGEN` |
| `__USE_COMPUTE_CELL_ADDRESS` | `COMPUTE_CELL_ADDRESS` |  |
| `__USE_GET_SCREEN_CELL` | `GET_SCREEN_CELL` | `__USE_COMPUTE_CELL_ADDRESS` |
| `__USE_GET_COLOR_CELL` | `GET_COLOR_CELL` | `__USE_COMPUTE_CELL_ADDRESS` |

Punti di personalizzazione usati dalla libreria, definiti anch'essi in `config.asm`:

| Punto di personalizzazione | Usato da | Valore nel template | Significato |
|---|---|---|---|
| `__DISABLE_KERNAL` | `NMI_HIBASE`, `NMI_RESTORE`, `m_Init_Raster_System`, `m_Start_Raster_IRQ`, `m_Enter_Raster_IRQ`, `m_Next_Raster_IRQ`, `m_Start_Unstable_IRQ`, `m_Enter_Unstable_IRQ`, `m_Next_Unstable_IRQ`, `m_Start_Stable_IRQ`, `m_Enter_Stable_IRQ`, `m_Next_Stable_IRQ` | `0` | Kernal disabilitato (1: tutta RAM; 0: Kernal attivo) |
| `__BG_COL` | `PLOT_CHAR`, `m_Put_ECM_Char` | `$03` | Cella in ZP: selettore del colore di sfondo ECM (0-3) |
| `__VIC_MODEL` | `m_Init_Raster_System`, `m_Raster_Grip`, `m_Enter_Stable_IRQ` | `$04` | Cella in ZP: modello di VIC-II rilevato |
| `__PUT_CHAR` | `PRINT_MSG`, `PRINT_NTH`, `PRINT_RAW`, `PRINT_IMM`, `m_Put_ECM_Char` | `$FFD2` | Subroutine di stampa di un carattere (CHROUT) |

<a id="modulo-6510_tools"></a>
## 6510_tools.asm

Macro per la configurazione dei banchi di memoria del 6510.

<a id="utilita-m_disable_basic"></a>
### m_Disable_BASIC

Disabilita la ROM del BASIC, rendendo visibile il banco di memoria `LORAM` (`$A000`-`$BFFF`).

| Voce | Contenuto |
|---|---|
| Input | Nessuno |
| Output | Nessuno |
| Registri Modificati | `.A`, `.P` (Negative, Zero), `R6510` |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_enable_basic"></a>
### m_Enable_BASIC

Riabilita la ROM del BASIC, rendendo invisibile il banco di memoria `LORAM` (`$A000`-`$BFFF`).

| Voce | Contenuto |
|---|---|
| Input | Nessuno |
| Output | Nessuno |
| Registri Modificati | `.A`, `.P` (Negative, Zero), `R6510` |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_disable_kernal"></a>
### m_Disable_Kernal

Disabilita la ROM del Kernal, rendendo visibile il banco di memoria `HIRAM` (`$E000`-`$FFFF`). ATTENZIONE: gli interrupt saranno disabilitati.

| Voce | Contenuto |
|---|---|
| Input | Nessuno |
| Output | Interrupt (1 bit, .P): sempre 1 |
| Registri Modificati | `.A`, `.P` (Negative, Interrupt, Zero), `R6510` |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_enable_kernal"></a>
### m_Enable_Kernal

Riabilita la ROM del Kernal, rendendo invisibile il banco di memoria `HIRAM` (`$E000`-`$FFFF`). ATTENZIONE: gli interrupt saranno riabilitati.

| Voce | Contenuto |
|---|---|
| Input | Nessuno |
| Output | Interrupt (1 bit, .P): sempre 0 |
| Registri Modificati | `.A`, `.P` (Negative, Interrupt, Zero), `R6510` |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_disable_io"></a>
### m_Disable_IO

Disabilita le interruzioni del timer di sistema e gli indirizzi di I/O, rendendo visibile il banco di memoria `CHARGEN` (`$D000`-`$DFFF`).

| Voce | Contenuto |
|---|---|
| Input | Nessuno |
| Output | Nessuno |
| Registri Modificati | `.A`, `.P` (Negative, Zero), `R6510`, `CIAICR` |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_enable_io"></a>
### m_Enable_IO

Riabilita gli indirizzi di I/O, rendendo invisibile il banco di memoria `CHARGEN` (`$D000`-`$DFFF`), e le interruzioni del timer di sistema.

| Voce | Contenuto |
|---|---|
| Input | Nessuno |
| Output | Nessuno |
| Registri Modificati | `.A`, `.P` (Negative, Zero), `R6510`, `CIAICR` |

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

<a id="modulo-nmi_tools"></a>
## nmi_tools.asm

Utilità per la gestione delle interruzioni non mascherabili.

<a id="utilita-nmi_hibase"></a>
### NMI_HIBASE

Dopo un RUN/STOP + RESTORE il VIC-II viene riconfigurato con i valori di default, ma la variabile di sistema `HIBASE` non viene reinizializzata. Questa subroutine risolve il problema inserendosi nella subroutine di interrupt NMI.

| Voce | Contenuto |
|---|---|
| Input | Nessuno |
| Output | Nessuno |
| Registri Modificati | `.A`, `.P` (Negative, Zero), `NMIVEC` |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-nmi_restore"></a>
### NMI_RESTORE

Ripristina il vettore NMI originale, annullando le modifiche apportate da `NMI_HIBASE`.

| Voce | Contenuto |
|---|---|
| Input | Nessuno |
| Output | Nessuno |
| Registri Modificati | `.A`, `.P` (Negative, Zero), `NMIVEC` |

[↑ Torna al contenuto](#contenuto)

<a id="modulo-print_tools"></a>
## print_tools.asm

Utilità per la stampa di caratteri, messaggi e tabelle di messaggi con supporto per il modo a Colore di Sfondo Esteso.

Requisiti di pagina zero: `__BG_COL`.

Note d'uso del modulo: [Nota #01](#nota-print_tools-01), [Nota #02](#nota-print_tools-02), [Nota #03](#nota-print_tools-03).

<a id="utilita-m_at"></a>
### m_At

Chiamata: `+m_At .row_, .col_`

Posiziona il cursore sulla riga e sulla colonna specificata dello schermo corrente, usando la chiamata `PLOT` del Kernal.

| Voce | Contenuto |
|---|---|
| Input | `.row_` (1 byte, Macro): Riga (0-24)<br>`.col_` (1 byte, Macro): Colonna (0-39) |
| Output | Nessuno |
| Registri Modificati | `.A`, `.X`, `.Y`, `.P` (Negative, oVerflow, Zero, Carry) |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-plot_char"></a>
### PLOT_CHAR

Scrive un carattere sullo schermo alla riga e colonna specificate e supporta in modo trasparente il modo Colore di Sfondo Esteso. Se questo modo è attivo il codice Schermo del carattere è automaticamente riportato all'intervallo 0-63 e viene scritto utilizzando il registro colore che è codificato in `__BG_COL`:

```
__BG_COL = 0: Usa il colore memorizzato in BGCOL0
__BG_COL = 1: Usa il colore memorizzato in BGCOL1
__BG_COL = 2: Usa il colore memorizzato in BGCOL2
__BG_COL = 3: Usa il colore memorizzato in BGCOL3
```

| Voce | Contenuto |
|---|---|
| Input | `.A` (1 byte, CPU): Codice Schermo del carattere<br>`.X` (1 byte, CPU): Colonna della cella (0-39)<br>`.Y` (1 byte, CPU): Riga della cella (0-24)<br>`__BG_COL` (1 byte, ZP): Selettore del registro di sfondo (0-3), solo in ECM |
| Output | `Cella` (1 byte, RAM): Cella dello schermo alla riga e colonna indicate |
| Registri Modificati | `.P` (Negative, oVerflow, Zero, Carry), `INDEX2` |
| Richiede | `__USE_COMPUTE_CELL_ADDRESS = 1` |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-color_char"></a>
### COLOR_CHAR

Imposta il colore di primo piano del carattere localizzato alla colonna ed alla riga specificati.

| Voce | Contenuto |
|---|---|
| Input | `.A` (1 byte, CPU): Codice del colore (0-15)<br>`.X` (1 byte, CPU): Colonna della cella (0-39)<br>`.Y` (1 byte, CPU): Riga della cella (0-24) |
| Output | `Cella` (1 byte, RAM): Cella della memoria colore indicata da `.X` e `.Y` |
| Registri Modificati | `.P` (Negative, oVerflow, Zero, Carry), `INDEX2` |
| Richiede | `__USE_COMPUTE_CELL_ADDRESS = 1` |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-print_msg"></a>
### PRINT_MSG

`PRINT_MSG` percorre attraverso chiamate successive una tavola di messaggi [Nota #01](#nota-print_tools-01). L'indirizzo iniziale della tavola è dato da un puntatore in ZP e l'indirizzo del puntatore è fornito in `.A`: alla prima chiamata viene stampato il primo messaggio: in caso di successo il flag di Carry è uguale a zero ed il puntatore in ZP incrementato all'inizio del messaggio successivo. Il raggiungimento della fine della tavola è segnalato da Carry = 1: successive chiamate non avranno effetto finché il puntatore non viene reinizializzato all'indirizzo iniziale della tavola.

| Voce | Contenuto |
|---|---|
| Input | `.A` (1 byte, CPU): Indirizzo in ZP del puntatore alla tavola<br>`Puntatore` (2 byte, ZP): Indirizzo del prossimo messaggio da stampare |
| Output | `Puntatore` (2 byte, ZP): Messaggio successivo o marcatore di fine tavola<br>Carry (1 bit, .P): 0 = messaggio stampato; 1 = tavola terminata |
| Registri Modificati | `.A`, `.X`, `.Y`, `.P` (Negative, oVerflow, Zero, Carry), puntatore in ZP |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-print_nth"></a>
### PRINT_NTH

`PRINT_NTH` stampa un messaggio singolo estraendolo da una tavola di messaggi [Nota #01](#nota-print_tools-01). L'indirizzo iniziale della tavola è dato da un puntatore in ZP e l'indirizzo del puntatore è fornito in `.A` mentre il numero d'ordine del messaggio è fornito in `.Y` (il primo messaggio ha indice 0).

| Voce | Contenuto |
|---|---|
| Input | `.A` (1 byte, CPU): Indirizzo in ZP del puntatore alla tavola<br>`.Y` (1 byte, CPU): Indice del messaggio (0 = il primo)<br>`Puntatore` (2 byte, ZP): Indirizzo iniziale della tavola |
| Output | Carry (1 bit, .P): 0 = messaggio stampato; 1 = indice oltre la fine |
| Registri Modificati | `.A`, `.X`, `.Y`, `.P` (Negative, oVerflow, Zero, Carry) |
| Richiede | `__USE_PRINT_MSG = 1` |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-print_raw"></a>
### PRINT_RAW

La subroutine `PRINT_RAW` stampa una stringa di testo il cui indirizzo è puntato da `.YA`: è pensata come sostituto della subroutine di sistema `STROUT` in quanto non altera il contenuto di `FAC` o `ARG`. Per mantenere la compatibilità con `STROUT` questa è l'unica subroutine di stampa che non supporta i due byte di posizionamento sullo schermo che precedono il messaggio.

| Voce | Contenuto |
|---|---|
| Input | `.A` (1 byte, CPU): Byte basso dell'indirizzo della stringa<br>`.Y` (1 byte, CPU): Byte alto dell'indirizzo della stringa |
| Output | Nessuno |
| Registri Modificati | `.A`, `.Y`, `.P` (Negative, oVerflow, Zero, Carry), `INDEX2` |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-print_imm"></a>
### PRINT_IMM

La subroutine `PRINT_IMM` stampa un messaggio (formattato come un elemento di una tavola di messaggi [Nota #01](#nota-print_tools-01)) inserito nel codice sorgente immediatamente dopo la sua chiamata:

```
jsr PRINT_IMM
!text $FF, $00, "Hello, world!", $0D, $00
```

| Voce | Contenuto |
|---|---|
| Input | `Messaggio` (n byte, RAM): Dati dopo la chiamata (vedi [Nota #01](#nota-print_tools-01)) |
| Output | Nessuno |
| Registri Modificati | `.A`, `.X`, `.Y`, `.P` (Negative, oVerflow, Zero, Carry), `INDEX2` |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_put_ecm_char"></a>
### m_Put_ECM_Char

Questa macro non è pensata per essere usata a sé stante, ma come mattone da costruzione per un proprio driver di stampa da utilizzare nel punto di configurazione `__PUT_CHAR` [Nota #02](#nota-print_tools-02): infatti la macro non termina con un RTS ma con un salto alla fine del suo codice in modo da poter essere concatenata con altre istruzioni [Nota #02](#nota-print_tools-02). Nello specifico questa macro implementa la logica per stampare a schermo un carattere PETSCII in modo ECM con il colore di sfondo desiderato. La macro si aspetta in `.A` il codice PETSCII del carattere da stampare e restituisce `.A`, `.X` e `.Y` invariati.

I codici di controllo (0-31 e 128-159) sono trattati così: 0, 18 (`{RVS}` ON) e 146 (`{RVS}` OFF) sono ignorati, perché il modo reverse è deciso da `__BG_COL`; quattro codici PETSCII non utilizzati dal sistema operativo (1-4) sono reinterpretati come codici di controllo che, come gli altri, hanno effetto fino al loro cambiamento: essi sono `ECM_BG`[0-3] e selezionano il registro del VIC-II contenente il colore di sfondo da utilizzare, senza stampare nulla [Nota #03](#nota-print_tools-03); tutti gli altri sono inviati a `CHROUT` senza modifiche.

Gli altri codici PETSCII sono stampabili. Il codice è normalizzato, cioè portato nell'intervallo 32-95 in cui il modo ECM ha i suoi glifi, sostituendo i 3 bit più significativi secondo la tabella `.NORM_TABLE` (con la macro `m_Apply_Table` di `<io/chars.asm>`). Non è una transcodifica nel senso di `<io/chars.asm>`, che conserva il glifo: in modo ECM il VIC-II ignora i due bit più significativi del codice Schermo, quindi la normalizzazione dà il codice il cui glifo è quello che l'hardware mostrerebbe comunque. Per esempio il pigreco (255) è stampato come la freccia in su: il suo codice 255 diventa 94, e questo caso, che la tabella non copre, è trattato a parte con la macro `m_Scan_Exceptions`. Poi il bit #0 di `__BG_COL` è copiato nel bit #7 del codice normalizzato e il bit #1 di `__BG_COL` decide il modo reverse (`RVS` = 0 normale, 1 inverso); il codice è infine inviato a `CHROUT`. `__BG_COL` non cambia.

| Voce | Contenuto |
|---|---|
| Input | `.A` (1 byte, CPU): Codice PETSCII da stampare<br>`__BG_COL` (1 byte, ZP): Selettore del colore di sfondo (0-3) |
| Output | `__BG_COL` (1 byte, ZP): Nuovo selettore (se il codice è `ECM_BG`[0-3])<br>`RVS` (1 byte, ZP): Modo reverse (bit #1 di `__BG_COL`), se il codice è stampabile |
| Registri Modificati | `.P` (Negative, oVerflow, Zero, Carry), `__BG_COL`, `RVS` |

[↑ Torna al contenuto](#contenuto)

### Note d'uso di `print_tools.asm`

<a id="nota-print_tools-01"></a>
#### Nota #01

Le subroutine `PRINT_MSG` e `PRINT_NTH` lavorano su elenchi di messaggi organizzati in tavole. Ciascun messaggio è organizzato nel seguente formato:

```
  !text <riga>, <colonna>, "messaggio", $00
```

`<riga>` e `<colonna>` sono due byte che indicano la posizione sullo schermo alla quale andrà stampato il messaggio.

Se `<riga>` == `$FF` e `<colonna>` != `$FF` il messaggio è stampato alla posizione corrente del cursore.

Se `<riga>` == `$FF` e `<colonna>` == `$FF` la tavola è terminata.

<a id="nota-print_tools-02"></a>
#### Nota #02

Le subroutine `PRINT_*` possono essere personalizzate con una propria subroutine di stampa modificando il valore del punto di configurazione `__PUT_CHAR`.

Esempio 1: Driver di stampa in modo ECM.

```
__PUT_CHAR:
  +m_Put_ECM_Char               ; Stampa il carattere in modo ECM

.Exit___PUT_CHAR:
  rts
```

Esempio 2: Driver di stampa in modo ECM a doppia spaziatura.

```
__PUT_CHAR:
  +m_Put_ECM_Char               ; Stampa il carattere in modo ECM
  lda #$1D                      ; Codice PETSCII per spostare il cursore
                                ; a destra di una posizione
  jsr CHROUT

.Exit___PUT_CHAR:
  rts
```

Esempio 3: Driver di stampa in verticale.

```
__PUT_CHAR:
  jsr CHROUT                    ; Stampa il carattere

  lda #$11                      ; Codice PETSCII per spostare il cursore
                                ; in basso di una posizione
  jsr CHROUT
  lda #$9D                      ; Codice PETSCII per spostare il cursore
                                ; a sinistra di una posizione
  jsr CHROUT

.Exit___PUT_CHAR:
  rts
```

<a id="nota-print_tools-03"></a>
#### Nota #03

Esempio di messaggio che utilizza i codici `ECM_BG`[0-3]:

```
  !text $FF, $00, ECM_BG0, "Hello, ", ECM_BG1, "world!", ECM_BG0, $00
```

L'ultimo `ECM_BG0` serve a ripristinare il colore di sfondo iniziale altrimenti eventuali messaggi seguenti sarebbero stampati con il colore di sfondo `ECM_BG1`.

[↑ Torna al contenuto](#contenuto)

<a id="modulo-raster_tools"></a>
## raster_tools.asm

Macro di utilità per la definizione di interruzioni di raster concatenate, sia stabili che instabili. Non adatte per codici iper-ottimizzati. Supportano tutte le versioni del chip VIC-II, sia PAL che NTSC.

Requisiti di pagina zero: `__VIC_MODEL`.

<a id="utilita-m_init_raster_system"></a>
### m_Init_Raster_System

Disabilita tutte le sorgenti di interruzioni legate ai chip CIA ed attiva UNICAMENTE le interruzioni dovute al raster. Dato che tutte le altre interruzioni sono disabilitate, la gestione della tastiera e dell'I/O seriale sono demandate alla responsabilità del programmatore. La macro determina anche il tipo di chip VIC-II installato sul computer sul quale sta girando: un codice identificativo viene conservato nella locazione rappresentata dal punto di configurazione `__VIC_MODEL`. Il significato del codice è il seguente:

```
$00 = PAL       63 cicli per linea
$40 = Old NTSC  64 cicli per linea
$C0 = New NTSC  65 cicli per linea
```

La macro `m_Raster_Grip` fa uso di questa informazione per iniettare nel codice 1 o 2 cicli extra di temporizzazione in base alla versione rilevata del chip VIC-II.

| Voce | Contenuto |
|---|---|
| Input | Nessuno |
| Output | `__VIC_MODEL` (1 byte, ZP): Modello di VIC-II (vedi Descrizione)<br>Interrupt (1 bit, .P): sempre 1 |
| Registri Modificati | `.A`, `.X`, `.Y`, `.P` (Negative, oVerflow, Interrupt, Zero, Carry), `__VIC_MODEL`, `CIAICR`, `CI2ICR`, `VICIRQ`, `IRQMSK`, `R6510` (se `__DISABLE_KERNAL` = 1) |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_start_raster_irq"></a>
### m_Start_Raster_IRQ

Chiamata: `+m_Start_Raster_IRQ .stable_, .rasterline_, .irq_handler_`

Questa macro inizia una catena di interruzioni di raster: il primo interrupt della catena può essere sia di tipo stabile che instabile. Questa macro si limita solo a richiamare le macro `m_Start_Stable_IRQ` e `m_Start_Unstable_IRQ` che si occupano dell'effettiva realizzazione dell'interruzione.

| Voce | Contenuto |
|---|---|
| Input | `.stable_` (stringa, Macro): `"STABLE"` = stabile, altro = instabile<br>`.rasterline_` (2 byte, Macro): Linea di raster desiderata<br>`.irq_handler_` (2 byte, Macro): Indirizzo del gestore dell'interruzione |
| Output | Interrupt (1 bit, .P): sempre 0 |
| Registri Modificati | `.A`, `.P` (Negative, Interrupt, Zero), `RASTER`, `SCROLY`, `IRBVEC` (se `__DISABLE_KERNAL` = 1), `CINV` (se `__DISABLE_KERNAL` = 0) |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_enter_raster_irq"></a>
### m_Enter_Raster_IRQ

Chiamata: `+m_Enter_Raster_IRQ .stable_, .rasterline_`

La macro va obbligatoriamente invocata come prima istruzione del gestore delle interruzioni di raster. Questa macro si limita solo a richiamare le macro `m_Enter_Stable_IRQ` e `m_Enter_Unstable_IRQ` che si occupano dell'effettiva realizzazione.

| Voce | Contenuto |
|---|---|
| Input | `.stable_` (stringa, Macro): `"STABLE"` = stabile, altro = instabile<br>`.rasterline_` (2 byte, Macro): Linea di raster (solo se stabile) |
| Output | Interrupt (1 bit, .P): 0 = stabile; 1 = instabile |
| Variazione Stack | Decrementato di 3 byte |
| Registri Modificati | `.A`, `.X`, `.Y`, `.P` (Negative, oVerflow, Interrupt, Zero, Carry), `RASTER`, `SCROLY`, `VICIRQ`, `IRBVEC` (se `__DISABLE_KERNAL` = 1), `CINV` (se `__DISABLE_KERNAL` = 0) |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_next_raster_irq"></a>
### m_Next_Raster_IRQ

Chiamata: `+m_Next_Raster_IRQ .stable_, .rasterline_, .irq_handler_, .fast_exit_`

La macro va obbligatoriamente invocata come ultima istruzione del gestore delle interruzioni di raster. Questa macro si limita solo a richiamare le macro `m_Next_Stable_IRQ` e `m_Next_Unstable_IRQ` che si occupano dell'effettiva realizzazione. Affinché la catena di interruzioni di raster sia ben formata è responsabilità del programmatore che l'ultimo anello della catena richiami il primo gestore, quello definito dalla macro `m_Start_Raster_IRQ`. Il parametro `.fast_exit_` è ignorato se `__DISABLE_KERNAL` = 1.

| Voce | Contenuto |
|---|---|
| Input | `.stable_` (stringa, Macro): `"STABLE"` = stabile, altro = instabile<br>`.rasterline_` (2 byte, Macro): Linea di raster del prossimo IRQ<br>`.irq_handler_` (2 byte, Macro): Indirizzo del gestore del prossimo IRQ<br>`.fast_exit_` (stringa, Macro): `"FAST"` = `IRQMIN`, altro = `IRQHND` |
| Output | `.PC` (2 byte, CPU): Uscita con rti o salto a `IRQMIN`/`IRQHND` |
| Variazione Stack | Incrementato di 6 byte |
| Registri Modificati | `.A`, `.P` (Negative, Interrupt, Zero), `RASTER`, `SCROLY`, `IRBVEC` (se `__DISABLE_KERNAL` = 1), `CINV` (se `__DISABLE_KERNAL` = 0) |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_set_rasterline"></a>
### m_Set_Rasterline

Chiamata: `+m_Set_Rasterline .rasterline_`

Macro di supporto per il settaggio del registro `RASTER` del chip VIC-II. La macro viene eseguita in tempo costante (16 cicli) e gestisce correttamente il settaggio del bit #9.

| Voce | Contenuto |
|---|---|
| Input | `.rasterline_` (2 byte, Macro): Linea di raster (9 bit, costante) |
| Output | Nessuno |
| Registri Modificati | `.A`, `.P` (Negative, Zero), `RASTER`, `SCROLY` |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_raster_grip"></a>
### m_Raster_Grip

Macro per la sincronizzazione del raster in maniera indipendente dall'hardware: siccome le 3 versioni esistenti del chip VIC-II (PAL, Old NTSC e New NTSC) producono una linea di raster in 63, 64 e 65 cicli rispettivamente, è necessario che il codice di sincronizzazione consumi 1 o 2 cicli di ritardo in più qualora l'hardware lo imponga. È pertanto obbligatorio che questa macro venga eseguita solo dopo l'esecuzione della macro `m_Init_Raster_System` che si occuperà dell'identificazione del chip VIC-II. La macro consuma 7 cicli su hardware PAL, 8 cicli su hardware Old NTSC e 9 cicli su hardware New NTSC. Nei calcoli di temporizzazione il programmatore dovrà sempre assumere che la linea di raster venga disegnata in 63 cicli (PAL) e che `m_Raster_Grip` duri 7 cicli: l'implementazione interna garantirà la coerenza dei calcoli in caso di hardware NTSC.

| Voce | Contenuto |
|---|---|
| Input | `__VIC_MODEL` (1 byte, ZP): Modello VIC-II (vedi `m_Init_Raster_System`) |
| Output | Nessuno |
| Registri Modificati | `.P` (Negative, oVerflow, Zero) |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_start_unstable_irq"></a>
### m_Start_Unstable_IRQ

Chiamata: `+m_Start_Unstable_IRQ .rasterline_, .irq_handler_`

La macro inizializza il vettore IRQ, la cui locazione differisce in dipendenza dallo stato di attivazione del Kernal, con l'indirizzo di partenza del gestore delle interruzioni poi imposta la linea di raster alla quale far scattare l'interruzione e ripristina il flag di Interrupt.

| Voce | Contenuto |
|---|---|
| Input | `.rasterline_` (2 byte, Macro): Linea di raster desiderata<br>`.irq_handler_` (2 byte, Macro): Indirizzo del gestore dell'interruzione |
| Output | Interrupt (1 bit, .P): sempre 0 |
| Registri Modificati | `.A`, `.P` (Negative, Interrupt, Zero), `RASTER`, `SCROLY`, `IRBVEC` (se `__DISABLE_KERNAL` = 1), `CINV` (se `__DISABLE_KERNAL` = 0) |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_enter_unstable_irq"></a>
### m_Enter_Unstable_IRQ

La macro implementa le buone pratiche da seguire all'esecuzione di un gestore delle interruzioni: se il Kernal è disabilitato provvede a salvare i registri `.A`, `.X` e `.Y` sullo stack (se il Kernal è abilitato questa operazione viene svolta in automatico) e poi altera il registro `VICIRQ` per segnalare l'avvenuto riconoscimento dell'interruzione.

| Voce | Contenuto |
|---|---|
| Input | Nessuno |
| Output | Interrupt (1 bit, .P): sempre 1 |
| Variazione Stack | Decrementato di 3 byte |
| Registri Modificati | `.A` (se `__DISABLE_KERNAL` = 1), `.P` (Negative, Zero, Carry), `VICIRQ` |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_next_unstable_irq"></a>
### m_Next_Unstable_IRQ

Chiamata: `+m_Next_Unstable_IRQ .rasterline_, .irq_handler_, .fast_exit_`

La macro implementa le buone pratiche da seguire all'uscita di un gestore delle interruzioni: il vettore IRQ (tenendo conto dello stato di attivazione del Kernal) viene impostato all'indirizzo del prossimo anello della catena, idem per la linea di raster alla quale dovrà essere eseguito e poi si provvede a ripristinare lo stack: se il Kernal è abilitato si salta a `IRQMIN` (nel caso si desideri un'uscita "fast") o a `IRQHND` (se si desiderà un'uscita "slow" che scansioni la tastiera, aggiorni i timer, eccetera). Se invece il Kernal è disabilitato non vi sono alternative: l'uscita sarà sempre "fast" ed il ripristino sarà realizzato mediante apposito codice in-line.

| Voce | Contenuto |
|---|---|
| Input | `.rasterline_` (2 byte, Macro): Linea di raster del prossimo IRQ<br>`.irq_handler_` (2 byte, Macro): Indirizzo del gestore del prossimo IRQ<br>`.fast_exit_` (stringa, Macro): `"FAST"` = `IRQMIN`, altro = `IRQHND` |
| Output | `.PC` (2 byte, CPU): Uscita con rti o salto a `IRQMIN`/`IRQHND` |
| Variazione Stack | Incrementato di 6 byte |
| Registri Modificati | `.A`, `.P` (Negative, Interrupt, Zero), `RASTER`, `SCROLY`, `IRBVEC` (se `__DISABLE_KERNAL` = 1), `CINV` (se `__DISABLE_KERNAL` = 0) |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_start_stable_irq"></a>
### m_Start_Stable_IRQ

Chiamata: `+m_Start_Stable_IRQ .rasterline_, .irq_handler_`

La macro inizializza il vettore IRQ, la cui locazione differisce in dipendenza dallo stato di attivazione del Kernal, con l'indirizzo di partenza del gestore delle interruzioni poi imposta la linea di raster (vedi sotto) alla quale far scattare l'interruzione e ripristina il flag di Interrupt. Per ottenere la stabilizzazione dell'interruzione di raster si utilizza la tecnica del doppio interrupt: questa macro serve ad impostare con congruo anticipo (3 linee di raster) il primo dei due.

IMPORTANTE: la macro presuppone che (`.rasterline_`-3) non corrisponda ad una "badline". In caso contrario i calcoli di temporizzazione su cui si basa il processo di sincronizzazione non saranno validi, con effetti imprevedibili.

| Voce | Contenuto |
|---|---|
| Input | `.rasterline_` (2 byte, Macro): Linea di raster desiderata<br>`.irq_handler_` (2 byte, Macro): Indirizzo del gestore dell'interruzione |
| Output | Interrupt (1 bit, .P): sempre 0 |
| Registri Modificati | `.A`, `.P` (Negative, Interrupt, Zero), `RASTER`, `SCROLY`, `IRBVEC` (se `__DISABLE_KERNAL` = 1), `CINV` (se `__DISABLE_KERNAL` = 0) |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_enter_stable_irq"></a>
### m_Enter_Stable_IRQ

Chiamata: `+m_Enter_Stable_IRQ .rasterline_`

La macro implementa la seconda parte della tecnica di stabilizzazione del raster mediante doppio interrupt. Per prima cosa si effettuano le operazioni di riconoscimento del primo interrupt secondo le buone pratiche descritte in `m_Enter_Unstable_IRQ` impostando il secondo interrupt in modo che scatti a `.rasterline_`-1 (il codice di sincronizzazione parte dall'etichetta @Sync); le operazioni differiscono in base allo stato di attivazione del Kernal. Il tempo rimanente viene impiegato per salvare il valore di `.S`, dopodiché si consumano cicli in attesa che scatti il secondo interrupt mentre si eseguono istruzioni di durata nota. Il secondo interrupt procede a bruciare cicli (il numero dipende dallo stato di attivazione del Kernal) per eseguire un'operazione di comparazione esattamente al ciclo 59 o 60. Un'operazione di salto fittizia brucerà 2 oppure 3 cicli a seconda del risultato della comparazione garantendo che l'istruzione successiva venga eseguita con certezza al ciclo 3 della linea di raster `.rasterline_`, stabilizzando così il raster!

IMPORTANTE: la macro presuppone che (`.rasterline_`-1) non corrisponda ad una "badline". In caso contrario i calcoli di temporizzazione su cui si basa il processo di sincronizzazione non saranno validi, con effetti imprevedibili.

ATTENZIONE: codice automodificante indicato con (!!!)

| Voce | Contenuto |
|---|---|
| Input | `.rasterline_` (2 byte, Macro): Linea di raster desiderata<br>`__VIC_MODEL` (1 byte, ZP): Modello VIC-II (vedi `m_Init_Raster_System`) |
| Output | Interrupt (1 bit, .P): sempre 0 |
| Variazione Stack | Decrementato di 3 byte |
| Registri Modificati | `.A`, `.X`, `.Y`, `.P` (Negative, oVerflow, Interrupt, Zero, Carry), `RASTER`, `SCROLY`, `VICIRQ`, `IRBVEC` (se `__DISABLE_KERNAL` = 1), `CINV` (se `__DISABLE_KERNAL` = 0) |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_next_stable_irq"></a>
### m_Next_Stable_IRQ

Chiamata: `+m_Next_Stable_IRQ .rasterline_, .irq_handler_, .fast_exit_`

La macro implementa le buone pratiche da seguire all'uscita di un gestore delle interruzioni: il vettore IRQ (tenendo conto dello stato di attivazione del Kernal) viene impostato all'indirizzo del prossimo anello della catena, idem per la linea di raster alla quale dovrà essere eseguito e poi si provvede a ripristinare lo stack: se il Kernal è abilitato si salta a `IRQMIN` (nel caso si desideri un'uscita "fast") o a `IRQHND` (se si desiderà un'uscita "slow" che scansioni la tastiera, aggiorni i timer, eccetera). Se invece il Kernal è disabilitato non vi sono alternative: l'uscita sarà sempre "fast" ed il ripristino sarà realizzato mediante apposito codice in-line. Siccome la macro presuppone che il prossimo anello della catena sarà ancora un IRQ stabile, la prossima linea di raster sarà impostata a `.rasterline_`-3, coerentemente con quanto fatto da `m_Start_Stable_IRQ`.

| Voce | Contenuto |
|---|---|
| Input | `.rasterline_` (2 byte, Macro): Linea di raster del prossimo IRQ<br>`.irq_handler_` (2 byte, Macro): Indirizzo del gestore del prossimo IRQ<br>`.fast_exit_` (stringa, Macro): `"FAST"` = `IRQMIN`, altro = `IRQHND` |
| Output | `.PC` (2 byte, CPU): Uscita con rti o salto a `IRQMIN`/`IRQHND` |
| Variazione Stack | Incrementato di 6 byte |
| Registri Modificati | `.A`, `.P` (Negative, Interrupt, Zero), `RASTER`, `SCROLY`, `IRBVEC` (se `__DISABLE_KERNAL` = 1), `CINV` (se `__DISABLE_KERNAL` = 0) |

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

<a id="modulo-vic_ii_tools"></a>
## vic_ii_tools.asm

Utilità per la gestione dei modi grafici offerti dal chip VIC-II.

<a id="utilita-m_vic_bitmap_on"></a>
### m_VIC_Bitmap_On

Abilita la modalità grafica bitmap impostando il bit #5 di `SCROLY`.

| Voce | Contenuto |
|---|---|
| Input | Nessuno |
| Output | `SCROLY` (1 byte, I/O): Bit #5 a 1 |
| Registri Modificati | `.A`, `.P` (Negative, Zero), `SCROLY` |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_vic_bitmap_off"></a>
### m_VIC_Bitmap_Off

Disabilita la modalità grafica bitmap azzerando il bit #5 di `SCROLY`.

| Voce | Contenuto |
|---|---|
| Input | Nessuno |
| Output | `SCROLY` (1 byte, I/O): Bit #5 a 0 |
| Registri Modificati | `.A`, `.P` (Negative, Zero), `SCROLY` |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_vic_ext_color_on"></a>
### m_VIC_Ext_Color_On

Abilita il modo Colore di Sfondo Esteso (ECM) impostando il bit #6 di `SCROLY`.

| Voce | Contenuto |
|---|---|
| Input | Nessuno |
| Output | `SCROLY` (1 byte, I/O): Bit #6 a 1 |
| Registri Modificati | `.A`, `.P` (Negative, Zero), `SCROLY` |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_vic_ext_color_off"></a>
### m_VIC_Ext_Color_Off

Disabilita il modo Colore di Sfondo Esteso (ECM) azzerando il bit #6 di `SCROLY`.

| Voce | Contenuto |
|---|---|
| Input | Nessuno |
| Output | `SCROLY` (1 byte, I/O): Bit #6 a 0 |
| Registri Modificati | `.A`, `.P` (Negative, Zero), `SCROLY` |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_vic_multicolor_on"></a>
### m_VIC_Multicolor_On

Abilita la modalità grafica multicolore impostando il bit #4 di `SCROLX`.

| Voce | Contenuto |
|---|---|
| Input | Nessuno |
| Output | `SCROLX` (1 byte, I/O): Bit #4 a 1 |
| Registri Modificati | `.A`, `.P` (Negative, Zero), `SCROLX` |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-m_vic_multicolor_off"></a>
### m_VIC_Multicolor_Off

Disabilita la modalità grafica multicolore azzerando il bit #4 di `SCROLX`.

| Voce | Contenuto |
|---|---|
| Input | Nessuno |
| Output | `SCROLX` (1 byte, I/O): Bit #4 a 0 |
| Registri Modificati | `.A`, `.P` (Negative, Zero), `SCROLX` |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-vic_palette"></a>
### VIC_PALETTE

Imposta i colori di bordo, sfondo, carattere, multicolore/colore esteso e multicolore/sprite in un'unica operazione. L'indirizzo in `.XA` punta ad un blocco di memoria che contiene in successione i valori da assegnare ai registri `EXTCOL`, `BGCOL0`, `BGCOL1`, `BGCOL2`, `BGCOL3`, `SPMC0`, `SPMC1` e `COLOR`. Se il valore è `VIC_TRANSPARENT` il registro resta immutato.

| Voce | Contenuto |
|---|---|
| Input | `.A` (1 byte, CPU): Indirizzo del blocco di memoria (byte basso)<br>`.X` (1 byte, CPU): Indirizzo del blocco di memoria (byte alto)<br>`blocco` (8 byte, RAM): Valori per `EXTCOL`, `BGCOL0`, `BGCOL1`, `BGCOL2`, `BGCOL3`, `SPMC0`, `SPMC1` e `COLOR`, in quest'ordine |
| Output | `EXTCOL` (1 byte, I/O): Colore del bordo (se non è `VIC_TRANSPARENT`)<br>`BGCOL0` (1 byte, I/O): Colore dello sfondo (se non è `VIC_TRANSPARENT`)<br>`BGCOL1` (1 byte, I/O): Colore di sfondo 1 (se non è `VIC_TRANSPARENT`)<br>`BGCOL2` (1 byte, I/O): Colore di sfondo 2 (se non è `VIC_TRANSPARENT`)<br>`BGCOL3` (1 byte, I/O): Colore di sfondo 3 (se non è `VIC_TRANSPARENT`)<br>`SPMC0` (1 byte, I/O): Colore comune degli sprite multicolori 0 (se non è `VIC_TRANSPARENT`)<br>`SPMC1` (1 byte, I/O): Colore comune degli sprite multicolori 1 (se non è `VIC_TRANSPARENT`)<br>`COLOR` (1 byte, RAM): Colore dei caratteri (se non è `VIC_TRANSPARENT`) |
| Registri Modificati | `.A`, `.Y`, `.P` (Negative, Zero), `INDEX2`, `EXTCOL`, `BGCOL0`, `BGCOL1`, `BGCOL2`, `BGCOL3`, `SPMC0`, `SPMC1`, `COLOR` |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-vic_bank"></a>
### VIC_BANK

Imposta o recupera l'indirizzo iniziale del banco di memoria da 16 KB visibile dal chip VIC-II.

```
C = 0: .A contiene la pagina iniziale del banco da
       selezionare, che può essere $00, $40, $80 oppure
       $C0. Valori differenti vengono allineati al limite
       inferiore.
C = 1: Il valore della pagina iniziale del banco di memoria
       viene restituito in .A.
```

| Voce | Contenuto |
|---|---|
| Input | `.A` (1 byte, CPU): Pagina iniziale del banco (solo se C = 0)<br>Carry (1 bit, .P): 0 = imposta; 1 = legge |
| Output | `.A` (1 byte, CPU): Pagina iniziale del banco (solo se C = 1)<br>`C2DDRA` (1 byte, I/O): Porte di selezione in uscita (solo se C = 0)<br>`CI2PRA` (1 byte, I/O): Selezione del banco (solo se C = 0) |
| Registri Modificati | `.A`, `.P` (Negative, Zero, Carry), `C2DDRA`, `CI2PRA` |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-vic_screen"></a>
### VIC_SCREEN

Imposta o recupera l'indirizzo iniziale della memoria schermo.

```
C = 0: .A contiene la pagina iniziale della memoria schermo,
       che può variare da $00 a $FC ad intervalli di $04.
       Valori differenti vengono allineati al limite
       inferiore.
C = 1: Il valore della pagina iniziale della memoria schermo
       viene restituito in .A.
```

| Voce | Contenuto |
|---|---|
| Input | `.A` (1 byte, CPU): Pagina iniziale della memoria schermo (C = 0)<br>Carry (1 bit, .P): 0 = imposta; 1 = legge |
| Output | `.A` (1 byte, CPU): Pagina iniziale della memoria schermo (C = 1)<br>`HIBASE` (1 byte, RAM): Pagina per l'editor del BASIC (solo se C = 0)<br>`VMCSB` (1 byte, I/O): Posizione della memoria schermo (solo se C = 0) |
| Registri Modificati | `.A`, `.P` (Negative, Zero, Carry), `HIBASE`, `VMCSB` |
| Richiede | `__USE_VIC_BANK = 1` |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-vic_chargen"></a>
### VIC_CHARGEN

Imposta o recupera l'indirizzo iniziale del generatore di caratteri.

```
C = 0: .A contiene la pagina iniziale del generatore di
       caratteri, che può variare da $00 a $F8 ad intervalli
       di $08. Valori differenti vengono allineati al limite
       inferiore.
C = 1: Il valore della pagina iniziale del generatore di
       caratteri viene restituito in .A.
```

| Voce | Contenuto |
|---|---|
| Input | `.A` (1 byte, CPU): Pagina iniziale del generatore di caratteri (solo se C = 0)<br>Carry (1 bit, .P): 0 = imposta; 1 = legge |
| Output | `.A` (1 byte, CPU): Pagina iniziale del generatore di caratteri (solo se C = 1)<br>`VMCSB` (1 byte, I/O): Posizione del generatore (solo se C = 0) |
| Registri Modificati | `.A`, `.P` (Negative, Zero, Carry), `VMCSB` |
| Richiede | `__USE_VIC_BANK = 1` |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-vic_bitmap"></a>
### VIC_BITMAP

Imposta o recupera l'indirizzo iniziale della memoria ad alta risoluzione.

```
C = 0: .A contiene la pagina iniziale della memoria ad alta
       risoluzione, che può variare da $00 a $E0 ad intervalli
       di $20. Valori differenti vengono allineati al limite
       inferiore.
C = 1: Il valore della pagina iniziale della memoria ad alta
       risoluzione viene restituito in .A.
```

| Voce | Contenuto |
|---|---|
| Input | `.A` (1 byte, CPU): Pagina iniziale della memoria bitmap (C = 0)<br>Carry (1 bit, .P): 0 = imposta; 1 = legge |
| Output | `.A` (1 byte, CPU): Pagina iniziale della memoria bitmap (C = 1)<br>`VMCSB` (1 byte, I/O): Posizione della memoria bitmap (solo se C = 0) |
| Registri Modificati | `.A`, `.P` (Negative, Zero, Carry), `VMCSB` |
| Richiede | `__USE_VIC_BANK = 1` |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-vic_copy_chargen"></a>
### VIC_COPY_CHARGEN

Sposta il generatore di caratteri dalla ROM alla RAM, nella posizione definita dalla configurazione del chip VIC-II attualmente in uso.

| Voce | Contenuto |
|---|---|
| Input | Nessuno |
| Output | `generatore` (4096 byte, RAM): Copia del generatore di caratteri della ROM |
| Registri Modificati | `.A`, `.X`, `.Y`, `.P` (Negative, Zero, Carry), `INDEX`, `INDEX2`, `R6510`, `CIAICR` |
| Richiede | `__USE_VIC_CHARGEN = 1` |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-compute_cell_address"></a>
### COMPUTE_CELL_ADDRESS

Calcola in modo veloce, mediante tavole, la cella di memoria corrispondente ad una posizione dello schermo espressa in notazione cartesiana: origine in alto a sinistra, asse x verso destra, asse y verso il basso. Se `.A` = 0 restituisce in `INDEX2` l'offset rispetto all'origine (0; 0), altrimenti la posizione assoluta per uno schermo che inizia alla pagina contenuta in `.A`: `.A` = (`HIBASE`) per lo schermo corrente, `.A` = >`COLRAM` per la memoria colore.

| Voce | Contenuto |
|---|---|
| Input | `.A` (1 byte, CPU): Pagina base dello schermo (0 = offset dall'origine)<br>`.X` (1 byte, CPU): Colonna della cella (0-39)<br>`.Y` (1 byte, CPU): Riga della cella (0-24) |
| Output | `INDEX2` (2 byte, ZP): Indirizzo della cella (offset se `.A` = 0) |
| Registri Modificati | `.A`, `.P` (Negative, oVerflow, Zero, Carry), `INDEX2` |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-get_screen_cell"></a>
### GET_SCREEN_CELL

Restituisce il codice Schermo del carattere posizionato alla colonna `.X` ed alla riga `.Y` dello schermo corrente.

| Voce | Contenuto |
|---|---|
| Input | `.X` (1 byte, CPU): Colonna della cella (0-39)<br>`.Y` (1 byte, CPU): Riga della cella (0-24) |
| Output | `.A` (1 byte, CPU): Codice Schermo del carattere<br>`INDEX2` (2 byte, ZP): Indirizzo della cella |
| Registri Modificati | `.A`, `.Y`, `.P` (Negative, oVerflow, Zero, Carry), `INDEX2` |
| Richiede | `__USE_COMPUTE_CELL_ADDRESS = 1` |

[↑ Torna al contenuto](#contenuto)

<a id="utilita-get_color_cell"></a>
### GET_COLOR_CELL

Restituisce il codice del colore del carattere posizionato alla colonna `.X` ed alla riga `.Y` dello schermo corrente.

| Voce | Contenuto |
|---|---|
| Input | `.X` (1 byte, CPU): Colonna della cella (0-39)<br>`.Y` (1 byte, CPU): Riga della cella (0-24) |
| Output | `.A` (1 byte, CPU): Codice del colore (0-15)<br>`INDEX2` (2 byte, ZP): Indirizzo della cella |
| Registri Modificati | `.A`, `.Y`, `.P` (Negative, oVerflow, Zero, Carry), `INDEX2` |
| Richiede | `__USE_COMPUTE_CELL_ADDRESS = 1` |

[↑ Torna al contenuto](#contenuto)

<a id="limiti-noti"></a>
## Limiti noti

I riquadri TO-DO dei sorgenti dichiarano questi limiti.

### Gestione dell'NMI: vettore sbagliato (B13)

Valgono per `NMI_HIBASE` e `NMI_RESTORE`, che scrivono in `NMIVEC` (`$FFFA`/`$FFFB`):

- con il Kernal abilitato la scrittura va nella RAM sotto la ROM e il processore continua a leggere il vettore dalla ROM: le subroutine non hanno effetto e `HIBASE` non viene mai reinizializzata;
- con il Kernal disabilitato (tutta RAM) la scrittura funziona, ma il gestore termina con `jmp NMIHND` (`$FE43`), che salta in una ROM che non c'è: serve un gestore proprio;
- `NMIHND` è l'ingresso del vettore del Kernal, non il gestore: a `$FE43` il Kernal esegue `SEI` e `JMP ($0318)`. Il vettore modificabile è `NMINV` (`$0318`), che di norma contiene `$FE47`.

Correzione indicata nel sorgente: scrivere in `NMINV` invece che in `NMIVEC`, chiudere il gestore con un salto a `$FE47` e far scrivere a `NMI_RESTORE` il valore `$FE47` in `NMINV`. Serve un simbolo per `$FE47` in `c64/symbols.asm`.

### Stampa: dipendenza dai registri di `__PUT_CHAR` (B15)

`PRINT_MSG` si aspetta che il registro `.X` sia invariato dopo ogni `jsr __PUT_CHAR`; `PRINT_RAW` e `PRINT_IMM` si aspettano invariato `.Y`. `CHROUT` li preserva, ma una subroutine di stampa personalizzata no: in quel caso il puntatore in pagina zero (indicizzato con `.X`) o l'indice del loop (`.Y`, che vale 0) verrebbero alterati e la subroutine leggerebbe o scriverebbe nella locazione sbagliata. `PRINT_NTH` dipende da `.X` in modo indiretto, tramite `PRINT_MSG`. Finché non è corretto, la subroutine usata come `__PUT_CHAR` deve preservare `.X` e `.Y` ([Nota #02](#nota-print_tools-02)).

### Raster: campionamento dell'IRQ in `m_Enter_Stable_IRQ`

La sequenza di `nop` della fase di sincronizzazione del raster potrebbe avere una discrepanza di un ciclo, legata alla temporizzazione esatta del VIC-II. La discrepanza non è dimostrata: non è stata né confermata né esclusa. Da ricontrollare, per ciascun modello di VIC-II (Old NTSC, New NTSC, PAL), con un emulatore a temporizzazione esatta o su macchina reale.

### Raster: manca un esempio d'uso

Le macro di `raster_tools.asm` sono descritte una per una, ma non esiste ancora un esempio completo che le mostri usate insieme (`m_Init_Raster_System`, `m_Start_Raster_IRQ`, `m_Enter_Raster_IRQ`, `m_Next_Raster_IRQ`, nelle versioni instabile e stabile).

[↑ Torna al contenuto](#contenuto)
