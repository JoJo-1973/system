; Macro utili per la programmazione

; Titolo:                 MACRO: Preambolo BASIC
; Nome:                   BASIC_Preamble
; Descrizione:            Inserisce una linea di BASIC con un comando SYS ed opzionalmente un commento.
; Parametri di ingresso:  .line_num: Numero di linea
;                         .label:    Etichetta del punto di ingresso
;                         .comment:  Commento (opzionale)
; Parametri di uscita:    ---
; Alterazioni registri:   ---
; Alterazioni pag. zero:  ---
; Dipendenze esterne:     ---
!macro BASIC_Preamble .line_num, .label, .comment {
  !ifndef .comment {
    !basic .line_num, .label
  } else {
    !basic .line_num, ":", $8F, " ", .comment, .label ; Nel caso sia specificato il commento aggiungi ":REM " + .comment in coda
                                                      ; $8F è il token dell'istruzione "REM"
  }
}

; Titolo:                 MACRO: Uscita al BASIC
; Nome:                   Exit_to_BASIC
; Descrizione:            Termina un programma in linguaggio machina uscendo al prompt del BASIC.
; Parametri di ingresso:  ---
; Parametri di uscita:    ---
; Alterazioni registri:   ---
; Alterazioni pag. zero:  ---
; Dipendenze esterne:     c64/symbols.asm, c64/errors.asm
!macro Exit_to_BASIC {
  ldx #ERR_READY            ; Carica il codice d'errore corrispondente a "READY."
  jmp (IERROR)              ; e ritorna al BASIC in maniera pulita
}

; Titolo:                 MACRO: Scambia di valore due puntatori a 8 bit
; Nome:                   Swap8
; Descrizione:            Scambia di valore due puntatori a 8 bit usando i registri.
; Parametri di ingresso:  .addr1: Indirizzo del primo valore
;                         .addr2: Indirizzo del secondo valore
; Parametri di uscita:    ---
; Alterazioni registri:   .X, .Y
; Alterazioni pag. zero:  ---
; Dipendenze esterne:     ---
!macro Swap8 .addr1, .addr2 {
  ldx .addr1            ; Semplicemente carica .X e .Y con i contenuti da scambiare
  ldy .addr2            ; e riscrivili in ordine inverso
  stx .addr2
  sty .addr1
}

; Titolo:                 MACRO: Salva tutti i registri sullo stack
; Nome:                   Push_AXY
; Descrizione:            Copia i registri .A, .X e .Y sullo stack.
; Parametri di ingresso:  ---
; Parametri di uscita:    ---
; Alterazioni registri:   .A
; Alterazioni pag. zero:  ---
; Dipendenze esterne:     ---
!macro Push_AXY {
  pha                           ; Prima .A

  txa                           ; poi .X
  pha

  tya                           ; e per ultimo .Y
  pha
}

; Titolo:                 MACRO: Recupera tutti i registri dallo stack
; Nome:                   Pull_AXY
; Descrizione:            Recupera i registri .A, .X e .Y dallo stack.
; Parametri di ingresso:  ---
; Parametri di uscita:    ---
; Alterazioni registri:   .A, .X, .Y
; Alterazioni pag. zero:  ---
; Dipendenze esterne:     ---
!macro Pull_AXY {
  pla                           ; Prima .Y
  tay

  pla                           ; poi .X
  tax

  pla                           ; e per ultimo .A
}

; Titolo:                 MACRO: Salva i registri .X e .Y sullo stack
; Nome:                   Push_XY
; Descrizione:            Copia i registri .X e .Y sullo stack.
; Parametri di ingresso:  ---
; Parametri di uscita:    ---
; Alterazioni registri:   .A
; Alterazioni pag. zero:  ---
; Dipendenze esterne:     ---
!macro Push_XY {
  pha                           ; Riserva una posizione sullo stack: servirà a Pull_XY.
                                ; Il contenuto di questa posizione è irrilevante.

  txa                           ; poi salva .X
  pha

  tya                           ; e per ultimo .Y
  pha
}

; Titolo:                 MACRO: Recupera i registri .X e .Y dallo stack
; Nome:                   Pull_XY
; Descrizione:            Recupera i registri .X e .Y dallo stack.
; Parametri di ingresso:  ---
; Parametri di uscita:    ---
; Alterazioni registri:   .X, .Y
; Alterazioni pag. zero:  ---
; Dipendenze esterne:     c64/symbols.asm
!macro Pull_XY {
  tsx                           ; Recupera il puntatore allo stack ed incrementalo di 3 unità:
  inx                           ; ora .X punta ad una posizione appositamente riservata da Push_XY
  inx                           ; e che non contiene dati utili:
  inx                           ; poiché .A verrà alterato dalle istruzioni che seguono
  sta STACK,x                   ; usala per per memorizzare il valore originario di .A

  pla                           ; Recupera .Y
  tay

  pla                           ; Recupera .X
  tax

  pla                           ; Ripristina .A
}

; Titolo:                 MACRO: Setta il flag oVerflow
; Nome:                   SeV
; Descrizione:            Setta il flag V: spreca cicli ed istruzioni, ma non altera gli altri flag.
; Parametri di ingresso:  ---
; Parametri di uscita:    ---
; Alterazioni registri:   .A
; Alterazioni pag. zero:  ---
; Dipendenze esterne:     ---
!macro SeV {
  php                           ; Copia .P in .A
  pla
  ora #%01000000                ; Setta il bit #6
  pha                           ; Copia .A in .P
  plp
}

; Titolo:                 MACRO: Complementa il flag Carry
; Nome:                   CCf
; Descrizione:            Complementa il flag C: spreca cicli ed istruzioni, ma non altera gli altri flag.
; Parametri di ingresso:  ---
; Parametri di uscita:    ---
; Alterazioni registri:   ---
; Alterazioni pag. zero:  ---
; Dipendenze esterne:     ---
!macro CCf {
  php                           ; Copia .P in .A
  pla
  eor #%00000001                ; Inverti il bit #1
  pha                           ; Copia .A in .P
  plp
}

; Titolo:                 MACRO: Maschera l'istruzione seguente (1 byte)
; Nome:                   Skip1
; Descrizione:            Inserisci l'istruzione illegale NOP #$xx (durata 2 cicli) in modo da mascherare l'opcode da un byte che segue.
; Parametri di ingresso:  ---
; Parametri di uscita:    ---
; Alterazioni registri:   ---
; Alterazioni pag. zero:  ---
; Dipendenze esterne:     ---
!macro Skip1 {
  !byte $80                     ; L'esecuzione di questa istruzione maschera l'opcode da un byte che segue senza alterare i flag
}

; Titolo:                 MACRO: Maschera l'istruzione seguente (2 byte)
; Nome:                   Skip2
; Descrizione:            Inserisci l'istruzione illegale NOP $xxxx (durata 4 cicli) in modo da mascherare l'opcode da due byte che segue.
; Parametri di ingresso:  ---
; Parametri di uscita:    ---
; Alterazioni registri:   ---
; Alterazioni pag. zero:  ---
; Dipendenze esterne:     ---
!macro Skip2 {
  !byte $0C                     ; L'esecuzione di questa istruzione maschera l'opcode da due byte che segue
}

; Titolo:                 MACRO: Consuma cicli a vuoto
; Nome:                   Delay_5n1
; Descrizione:            Consuma un numero di cicli determinato dalla formula 5*n+1.
; Parametri di ingresso:  .reg: Registro usato per contare le iterazioni - ".X" oppure ".Y"
;                         .n:   Parametro della formula 5*.n+1 che determina il numero di cicli da consumare.
                                Porre .n=0 equivale a porre .n=256.
; Parametri di uscita:    ---
; Alterazioni registri:   .X, .Y
; Alterazioni pag. zero:  ---
; Dipendenze esterne:     ---
!macro Delay_5n1 .reg, .n {
  !if .reg = ".X" {       ; Esegui il ciclo usando .X come contatore.
    ldx #.n
    dex
    bne *-1
  } else if .reg = ".Y" { ; Esegui il ciclo usando .Y come contatore.
    ldy #.n
    dey
    bne *-1
  } else {
    !error "Illegal register usage in m_Delay_5n1"
  }
}