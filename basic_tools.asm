; ==============================================================================
; FILE:           basic_tools.asm
; PROGETTO:       Libreria di Sistema (system.c64)
; TARGET:         ACME Assembler / MOS 6510 (Commodore 64)
; DESCRIZIONE:    Utilità per la manipolazione dell'area di memoria dedicata al
;                 BASIC ed ai programmi ivi contenuti.
; CONTENUTO:      m_Exit_To_BASIC   Esce al prompt del BASIC
;                 LOMEM             Sposta l'inizio della memoria BASIC
;                 HIMEM             Sposta la fine della memoria BASIC
; DIPENDENZE:     Nessuna
; REQUISITI ZP:   Nessuno
; ==============================================================================

; ==============================================================================
; MACRO: m_Exit_To_BASIC
; ------------------------------------------------------------------------------
; Descrizione:  Termina un programma in linguaggio macchina e torna al prompt
;               del BASIC, passando per il gestore degli errori.
;
; Input:
;   - Nessuno
;
; Output:
;   - .PC (2 byte, CPU) : Indirizzo contenuto nel vettore IERROR
;
; Variazione Stack (.S):
;   - Azzerato
;
; Registri Modificati:  .X, .P, .S
; Dipendenze Esterne:   <c64/errors.asm>
;                       <c64/symbols.asm>
; ==============================================================================
!macro m_Exit_To_BASIC {
    ldx #ERR_READY              ; Carica il codice d'errore corrispondente a "READY."
    jmp (IERROR)                ; e ritorna al BASIC in maniera pulita.
}

; ==============================================================================
; SUBROUTINE: LOMEM
; ------------------------------------------------------------------------------
; Descrizione:  Sposta l'inizio della memoria dedicata al BASIC aggiornando la
;               variabile di sistema TXTTAB. La subroutine richiede un puntatore
;               precedente all'indirizzo che conterrà il primo carattere del
;               testo del programma. Al termine i puntatori del BASIC
;               conterranno il valore del puntatore incrementato di 1.
;               L'esecuzione ritorna al BASIC.
;
; Input:
;   - .X (1 byte, CPU)       : Indirizzo del puntatore alla locazione iniziale
;                              dell'area BASIC meno 1
;
; Output:
;   - puntatore (2 byte, ZP) : Incrementato di 1
;   - TXTTAB (2 byte, ZP)    : Nuovo inizio dell'area BASIC
;   - .PC (2 byte, CPU)      : Ritorno al BASIC
;
; Variazione Stack (.S):
;   - Azzerato
;
; Registri Modificati:  .A, .X, .Y, .P, .S, TXTTAB, VARTAB,
;                       ARYTAB, STREND, FRETOP, TXTPTR
; Dipendenze Esterne:   <c64/symbols.asm>
; ==============================================================================
!if (__USE_LOMEM = 1) {
  !zone LOMEM

    .NEW            = $A644     ; NEW oltre il controllo di sintassi (che richiede Z = 1)

    LOMEM:
      lda #$00                  ; Scrivi $00 nella locazione puntata.
      sta ($00,x)
      inc $00,x                 ; Incrementa il puntatore di 1
      bne .Store_Pointer

      inc $01,x

    .Store_Pointer:
      lda $00,x                 ; e scrivilo in TXTTAB.
      sta TXTTAB
      lda $01,x
      sta TXTTAB+1

      jsr .NEW                  ; Esegui il comando NEW per aggiustare tutti gli altri
                                ; puntatori che dipendono da TXTTAB.

    .Exit_LOMEM:
      rts

  !zone
}

; ==============================================================================
; SUBROUTINE: HIMEM
; ------------------------------------------------------------------------------
; Descrizione:  Sposta la fine della memoria dedicata al BASIC aggiornando la
;               variabile di sistema MEMSIZ. L'esecuzione ritorna al BASIC.
;
; Input:
;   - .X (1 byte, CPU)    : Indirizzo del puntatore alla locazione finale
;                           dell'area BASIC
;
; Output:
;   - MEMSIZ (2 byte, ZP) : Nuova fine dell'area BASIC
;   - .PC (2 byte, CPU)   : Ritorno al BASIC
;
; Variazione Stack (.S):
;   - Azzerato
;
; Registri Modificati:  .A, .X, .Y, .P, .S, MEMSIZ, FRETOP,
;                       ARYTAB, STREND
; Dipendenze Esterne:   <c64/symbols.asm>
; ==============================================================================
!if (__USE_HIMEM = 1) {
  !zone HIMEM

    .CLEAR          = $A660     ; CLR oltre il controllo di sintassi (che richiede Z = 1)

    HIMEM:
      lda $00,x                 ; Prima il byte basso
      sta MEMSIZ
      lda $01,x                 ; poi quello alto.
      sta MEMSIZ+1

      jsr .CLEAR                ; Esegui il comando CLR per aggiustare tutti gli altri
                                ; puntatori che dipendono da MEMSIZ.

    .Exit_HIMEM:
      rts

  !zone
}
