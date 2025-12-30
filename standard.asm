; Macro utili per la programmazione

ADDR_IMM          = 0           ; Indirizzamento immediato a 16/24 bit
ADDR_ABS          = 1           ; Indirizzamento assoluto a 16/24 bit
ADDR_ZER          = 2           ; Indirizzamento pagina zero a 16/24 bit
ADDR_ACC          = 3           ; Indirizzamento accumulatore

REG_AX            = $FFFF0      ; Indirizzamento implicito a 16 bit con i registri .A (alto) e .X (basso)
REG_AY            = $FFFF1      ; Indirizzamento implicito a 16 bit con i registri .A (alto) e .Y (basso)
REG_XY            = $FFFF2      ; Indirizzamento implicito a 16 bit con i registri .X (alto) e .Y (basso)
REG_XA            = $FFFF3      ; Indirizzamento implicito a 16 bit con i registri .X (alto) e .A (basso)
REG_YA            = $FFFF4      ; Indirizzamento implicito a 16 bit con i registri .Y (alto) e .A (basso)
REG_YX            = $FFFF5      ; Indirizzamento implicito a 16 bit con i registri .Y (alto) e .X (basso)
REG_AXY           = $FFFF6      ; Indirizzamento implicito a 24 bit con i registri .A (alto), .X (medio) e .Y (basso)
REG_YXA           = $FFFF7      ; Indirizzamento implicito a 24 bit con i registri .Y (alto), .X (medio) e .A (basso)

!source <system/branch.asm>
!source <mem.asm>
!source <math.asm>
!source <c64/errors.asm>

; Titolo:                 MACRO: Preambolo BASIC
; Nome:                   BASIC_Preamble
; Descrizione:            Inserisce una linea di BASIC con un comando SYS ed opzionalmente un commento.
; Parametri di ingresso:  line_num: Numero di linea
;                         label:    Etichetta del punto di ingresso
;                         comment:  Commento (opzionale)
; Parametri di uscita:    ---
; Alterazioni registri:   ---
; Alterazioni pag. zero:  ---
; Dipendenze esterne:     c64_symbols.asm
!macro BASIC_Preamble line_num, label, comment {
  *= BASTXT                     ; La definizione di BASTXT è contenuta del file dei simboli relativo all'architettura scelta (VIC-20, C64, ecc.)

  !ifndef comment {
    !basic line_num, label
  } else {
    !basic line_num, ":", $8F, " ", comment, label
  }
}

; Titolo:                 MACRO: Uscita al BASIC
; Nome:                   Exit_to_BASIC
; Descrizione:            Termina un programma in linguaggio machina uscendo al prompt del BASIC.
; Parametri di ingresso:  ---
; Parametri di uscita:    ---
; Alterazioni registri:   ---
; Alterazioni pag. zero:  ---
; Dipendenze esterne:     c64_symbols.asm
!macro Exit_to_BASIC {
  ldx #ERR_READY
  jmp (IERROR)
}

; Titolo:                 MACRO: Scambia di valore due puntatori a 8 bit
; Nome:                   Swap8
; Descrizione:            Scambia di valore due puntatori a 8 bit usando i registri.
; Parametri di ingresso:  addr1:Indirizzo del primo valore
;                         addr2:Indirizzo del secondo valore
; Parametri di uscita:    ---
; Alterazioni registri:   .X, .Y
; Alterazioni pag. zero:  ---
; Dipendenze esterne:     ---
!macro Swap8 addr1, addr2 {
  ldx addr1
  ldy addr2
  stx addr2
  sty addr1
}

; Titolo:                 MACRO: Salva tutti i registri sullo stack
; Nome:                   PushAXY
; Descrizione:            Copia i registri .A, .X e .Y sullo stack.
; Parametri di ingresso:  ---
; Parametri di uscita:    ---
; Alterazioni registri:   .A
; Alterazioni pag. zero:  ---
; Dipendenze esterne:     ---
!macro PushAXY {
  pha                           ; Prima .A

  txa                           ; poi .X
  pha

  tya                           ; e per ultimo .Y
  pha
}

; Titolo:                 MACRO: Recupera tutti i registri dallo stack
; Nome:                   PullAXY
; Descrizione:            Recupera i registri .A, .X e .Y dallo stack.
; Parametri di ingresso:  ---
; Parametri di uscita:    ---
; Alterazioni registri:   .A, .X, .Y
; Alterazioni pag. zero:  ---
; Dipendenze esterne:     ---
!macro PullAXY {
  pla                           ; Prima .Y
  tay

  pla                           ; poi .X
  tax

  pla                           ; e per ultimo .A
}

; Titolo:                 MACRO: Salva i registri .X e .Y sullo stack
; Nome:                   PushXY
; Descrizione:            Copia i registri .X e .Y sullo stack.
; Parametri di ingresso:  ---
; Parametri di uscita:    ---
; Alterazioni registri:   .A
; Alterazioni pag. zero:  ---
; Dipendenze esterne:     ---
!macro PushXY {
  pha                           ; .A va salvato comunque sullo stack: la sua posizione servirà da buffer durante il recupero dallo stack

  txa                           ; poi .X
  pha

  tya                           ; e per ultimo .Y
  pha
}

; Titolo:                 MACRO: Recupera i registri .X e .Y dallo stack
; Nome:                   PullXY
; Descrizione:            Recupera i registri .X e .Y dallo stack.
; Parametri di ingresso:  ---
; Parametri di uscita:    ---
; Alterazioni registri:   .X, .Y
; Alterazioni pag. zero:  ---
; Dipendenze esterne:     ---
!macro PullXY {
  tsx                           ; Recupera il puntatore allo stack ed incrementalo di 3 unità:
  inx                           ; ora .X punta ad una posizione appositamente riservata da PushXY
  inx                           ; e che non contiene dati utili
  inx
  sta STACK,x                   ; e che può essere usata per memorizzare temporaneamente .A

  pla                           ; Recupera .Y
  tay

  pla                           ; Recupera .X
  tax

  pla                           ; Ripristina .A
}

; Titolo:                 MACRO: Setta il flag oVerflow
; Nome:                   SeV
; Descrizione:            Setta il flag V senza alterare gli altri flag.
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
; Descrizione:            Complementa il flag C (ma alterando N e Z).
; Parametri di ingresso:  ---
; Parametri di uscita:    ---
; Alterazioni registri:   ---
; Alterazioni pag. zero:  ---
; Dipendenze esterne:     ---
!macro CCf {
  rol a
  eor #%00000001
  ror a
}

; Titolo:                 MACRO: Maschera l'istruzione seguente (1 byte)
; Nome:                   Skip1
; Descrizione:            Inserisci l'istruzione BIT $xx in modo da mascherare l'opcode da un byte che segue.
; Parametri di ingresso:  ---
; Parametri di uscita:    ---
; Alterazioni registri:   ---
; Alterazioni pag. zero:  ---
; Dipendenze esterne:     ---
!macro Skip1 {
  !byte $24                     ; L'esecuzione di questo byte maschera l'opcode da un byte che segue
}

; Titolo:                 MACRO: Maschera l'istruzione seguente (2 byte)
; Nome:                   Skip2
; Descrizione:            Inserisci l'istruzione BIT $xxxx in modo da mascherare l'opcode da due byte che segue.
; Parametri di ingresso:  ---
; Parametri di uscita:    ---
; Alterazioni registri:   ---
; Alterazioni pag. zero:  ---
; Dipendenze esterne:     ---
!macro Skip2 {
  !byte $2C                     ; L'esecuzione di questo byte maschera l'opcode da due byte che segue
}