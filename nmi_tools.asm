; ==============================================================================
; FILE:           nmi_tools.asm
; PROGETTO:       Libreria di Sistema (system.c64)
; TARGET:         ACME Assembler / MOS 6510 (Commodore 64)
; DESCRIZIONE:    Utilità per la gestione delle interruzioni non mascherabili.
; CONTENUTO:      NMI_HIBASE    Resetta HIBASE dopo RUN/STOP + RESTORE
;                 NMI_RESTORE   Ripristina il vettore NMI originale
; DIPENDENZE:     Nessuna
; REQUISITI ZP:   Nessuno
; ==============================================================================

; ==============================================================================
; SUBROUTINE: NMI_HIBASE
; ------------------------------------------------------------------------------
; Descrizione:  Dopo un RUN/STOP + RESTORE il VIC-II viene riconfigurato con i
;               valori di default, ma la variabile di sistema HIBASE non viene
;               reinizializzata. Questa subroutine risolve il problema
;               inserendosi nella subroutine di interrupt NMI.
;
; Input:
;   - Nessuno
;
; Output:
;   - Nessuno
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .P (Negative, Zero), NMIVEC
; Dipendenze Esterne:   <c64/symbols.asm>
; ==============================================================================
!if (__USE_NMI_HIBASE = 1) {
  !zone NMI_HiBase

    NMI_HIBASE:
      ; ****************************************************************
      ; * TO-DO: BUG (B13) - vettore NMI sbagliato.                    *
      ; *                                                              *
      ; * Cosa fa il codice: NMI_HIBASE scrive l'indirizzo di          *
      ; * .New_NMI_Handler in NMIVEC ($FFFA/$FFFB) e il gestore        *
      ; * termina con jmp NMIHND ($FE43). NMI_RESTORE scrive NMIHND    *
      ; * in NMIVEC.                                                   *
      ; *                                                              *
      ; * Cosa succede davvero: il vettore hardware $FFFA si trova     *
      ; * nella ROM del Kernal e vale $FE43. A $FE43 il Kernal esegue  *
      ; * SEI e JMP ($0318): il vettore RAM modificabile è $0318       *
      ; * (NMINV), che di norma contiene $FE47, dove inizia il vero    *
      ; * gestore NMI.                                                 *
      ; *                                                              *
      ; * Conseguenze: 1) con il Kernal abilitato la scrittura in      *
      ; * $FFFA/$FFFB va nella RAM sotto la ROM e il processore        *
      ; * continua a leggere il vettore dalla ROM: la subroutine non   *
      ; * ha alcun effetto e HIBASE non viene mai reinizializzata. 2)  *
      ; * Scrivendo in NMINV ($0318) e lasciando jmp NMIHND si ottiene *
      ; * un ciclo infinito: $FE43 salta a JMP ($0318), cioè al        *
      ; * gestore stesso; il salto di chiusura deve andare a $FE47. 3) *
      ; * Con il Kernal disabilitato (tutta RAM) la scrittura in $FFFA *
      ; * funziona, ma jmp NMIHND salta in una ROM che non c'è: serve  *
      ; * un gestore proprio.                                          *
      ; *                                                              *
      ; * Correzione: scrivere in NMINV invece che in NMIVEC; chiudere *
      ; * il gestore con un salto a $FE47; far scrivere a NMI_RESTORE  *
      ; * il valore $FE47 in NMINV. Serve un simbolo per $FE47 in      *
      ; * c64/symbols.asm (NMIHND vale $FE43: è l'ingresso del         *
      ; * vettore, non il gestore).                                    *
      ; *                                                              *
      ; * Supporto mancante per __DISABLE_KERNAL: con __DISABLE_KERNAL *
      ; * = 0 si opera su NMINV; con __DISABLE_KERNAL = 1 si opera su  *
      ; * NMIVEC senza saltare nella ROM. Poi aggiornare Registri      *
      ; * Modificati: NMINV (se __DISABLE_KERNAL = 0), NMIVEC (se      *
      ; * __DISABLE_KERNAL = 1).                                       *
      ; *                                                              *
      ; * Fonte: disassemblato del Kernal, github.com/mist64/c64ref.   *
      ; ****************************************************************

      lda #<.New_NMI_Handler    ; Imposta il nuovo gestore delle interruzioni
                                ; non mascherabili.
      sta NMIVEC
      lda #>.New_NMI_Handler
      sta NMIVEC+1

    .Exit_NMI_HIBASE:
      rts

    .New_NMI_Handler:
      pha                       ; Salva l'accumulatore sullo stack.
      lda #>VICSCN              ; Resetta il byte alto dell'indirizzo base dello schermo
                                ; a 1024.
      sta HIBASE
      pla                       ; Recupera l'accumulatore dallo stack.
      jmp NMIHND                ; Esegui il normale gestore delle interruzioni
                                ; non mascherabili.

  !zone
}

; ==============================================================================
; SUBROUTINE: NMI_RESTORE
; ------------------------------------------------------------------------------
; Descrizione:  Ripristina il vettore NMI originale, annullando le modifiche
;               apportate da NMI_HIBASE.
;
; Input:
;   - Nessuno
;
; Output:
;   - Nessuno
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .P (Negative, Zero), NMIVEC
; Dipendenze Esterne:   <c64/symbols.asm>
; ==============================================================================
!if (__USE_NMI_RESTORE = 1) {
  !zone NMI_Restore

    NMI_RESTORE:
      ; ****************************************************************
      ; * TO-DO: BUG (B13) - vedi il TO-DO di NMI_HIBASE.              *
      ; *                                                              *
      ; * Questa subroutine scrive NMIHND ($FE43) in NMIVEC            *
      ; * ($FFFA/$FFFB): con il Kernal abilitato la scrittura non ha   *
      ; * effetto. Va scritto in NMINV ($0318) il valore $FE47         *
      ; * (gestore NMI del Kernal), e va gestito __DISABLE_KERNAL (con *
      ; * 1 si opera su NMIVEC).                                       *
      ; ****************************************************************

      lda #<NMIHND
      sta NMIVEC
      lda #>NMIHND
      sta NMIVEC+1

    .Exit_NMI_RESTORE:
      rts

  !zone
}
