; Utility per la configurazione del chip VIC-II

; Titolo:                 MACRO: Imposta i registri colore del chip VIC-II
; Nome:                   VIC_PALETTE
; Scopo:                  Imposta i colori di bordo, sfondo, carattere e multicolore/colore esteso in un'unica operazione.
;                         L'indirizzo in .A/.X punta ad un blocco di memoria che contiene in successione i valori
;                         da assegnare ai seguenti registri:
;
;                         EXTCOL, BGCOL0, BGCOL1, BGCOL2, BGCOL3, COLOR
;
;                         Se il valore è VIC_TRANSPARENT il registro resta immutato.
; Parametri di ingresso:  .A: Indirizzo del blocco di memoria (byte basso)
;                         .X: Indirizzo del blocco di memoria (byte alto)
; Parametri di uscita:    ---
; Registri alterati:      .A, .Y
; Puntatori zp alterati:  INDEX2
; Temporanei alterati:    ---
; Dipendenze esterne:     symbols.asm, standard.asm, kernal.asm, vic_ii.asm
!macro Vic_Palette {
  !zone Vic_Palette
  VIC_PALETTE:
    sta INDEX2                  ; Prepara i registri.
    stx INDEX2+1
    ldy #5

    lda (INDEX2),y              ; Imposta il colore dei caratteri: se il colore è il valore speciale
    bmi .Vic_Registers          ; VIC_TRANSPARENT allora non modificare il registro colore.
    sta COLOR

  .Vic_Registers:
    dey

  .Loop_Color_Register:
    lda (INDEX2),y              ; Imposta i registri colore: se il colore è il valore speciale
    bmi .Next_Color_Register    ; VIC_TRANSPARENT allora non modificare il registro.
    sta EXTCOL,y

  .Next_Color_Register:
    dey
    bpl .Loop_Color_Register

  .Exit_VIC_PALETTE:
    rts
  !zone
}

; Titolo:                 MACRO: Seleziona il banco di memoria visibile dal VIC-II
; Nome:                   VIC_BANK
; Scopo:                  Imposta o recupera l'indirizzo iniziale del banco di memoria da 16KB visibile dal chip VIC-II.
;                           C = 0: .A contiene la pagina iniziale del banco da selezionare, che può essere $00, $40, $80 oppure $C0.
;                                  Valori differenti vengono allineati al limite più prossimo.
;                           C = 1: Il valore della pagina iniziale del banco di memoria viene restituito in .A
; Parametri di ingresso:  .A: Indirizzo della pagina iniziale del blocco di memoria
;                          C: Selettore di lettura/scrittura
; Parametri di uscita:    .A: Indirizzo della pagina iniziale del blocco di memoria
; Registri alterati:      .A
; Puntatori zp alterati:  ---
; Temporanei alterati:    ---
; Dipendenze esterne:     symbols.asm, standard.asm, kernal.asm, vic_ii.asm, cia.asm
!macro Vic_Bank {
  !zone Vic_Bank
  VIC_BANK:
    bcs .RdBnk                  ; Se C=1 vai alla routine di recupero indirizzo.

    rol a                       ; L'accumulatore deve contenere un valore tra 0 e 3.
    rol a
    rol a
    and #%00000011
    eor #%00000011              ; I bit di selezione del banco hanno un valore
                                ; inverso a quello del numero del banco.
    sta ._MASK                  ; Conserva temporaneamente la maschera di selezione.

    lda C2DDRA                  ; Setta le porte di controllo del cambio
    ora #%00000011              ; di banco in direzione di uscita.
    sta C2DDRA

    lda CI2PRA                  ; Maschera i bit da lasciare immutati
    and #%11111100
    ora ._MASK                  ; ed applica la maschera di selezione.
    sta CI2PRA
    +Bra .Exit_VIC_BANK

  .RdBnk:
    lda CI2PRA                  ; Inverti il valore dei bit di selezione del banco
    eor #%00000011

    ror a                       ; poi spostali nei bit 7 e 6 e pulisci i bit non necessari.
    ror a
    ror a
    and #%11000000

  .Exit_VIC_BANK:
    rts

  ._MASK            !byte 0
  !zone
}

; Titolo:                 MACRO: Seleziona la posizione iniziale della memoria schermo
; Nome:                   VIC_SCREEN
; Scopo:                  Imposta o recupera l'indirizzo iniziale della memoria schermo.
;                           C = 0: .A contiene la pagina iniziale della memoria schermo, che può variare da $00 a $FC ad intervalli di $04.
;                                  Valori differenti vengono allineati al limite più prossimo.
;                           C = 1: Il valore della pagina iniziale della memoria schermo viene restituito in .A
; Parametri di ingresso:  .A: Indirizzo della pagina iniziale del blocco di memoria
;                          C: Selettore di lettura/scrittura
; Parametri di uscita:    .A: Indirizzo della pagina iniziale del blocco di memoria
; Registri alterati:      .A
; Puntatori zp alterati:  ---
; Temporanei alterati:    ---
; Dipendenze esterne:     symbols.asm, standard.asm, kernal.asm, vic_ii.asm, cia.asm
!macro Vic_Screen {
  !zone Vic_Screen
  VIC_SCREEN:
    bcs .RdScr                  ; Se C=1 vai alla routine di recupero indirizzo.

    and #%11111100              ; Allinea il valore fornito al KB.
    sta HIBASE                  ; Aggiusta HIBASE in modo che l'editor del BASIC conosca la nuova posizione della memoria schermo.

    asl a                       ; La posizione della pagina all'interno del banco (bit 2-5)
    asl a                       ; va spostata nei bit più significativi.
    sta ._MASK                  ; Conserva temporaneamente la maschera di selezione.

    lda VMCSB                   ; Indica al VIC-II la posizione della memoria schermo.
    and #%00001111
    ora ._MASK
    sta VMCSB
    +Bra .Exit_VIC_SCREEN

  .RdScr:
    jsr VIC_BANK                ; C è già 1, quindi leggi la posizione iniziale del banco video
    sta ._MASK                  ; e conservalo temporaneamente.

    lda VMCSB                   ; Estrai dal registro di controllo la posizione
    and #%11110000              ; della pagina iniziale di memoria schermo
    lsr a                       ; e dividila per 4.
    lsr a
    ora ._MASK                  ; Aggiungi la pagina iniziale del banco video.

  .Exit_VIC_SCREEN:
    rts

  ._MASK !byte 0
  !zone
}

; Titolo:                 MACRO: Seleziona la posizione iniziale del generatore di caratteri
; Nome:                   VIC_CHARGEN
; Scopo:                  Imposta o recupera l'indirizzo iniziale del generatore di caratteri
;                           C = 0: .A contiene la pagina iniziale del generatore di caratteri, che può variare da $00 a $F8 ad intervalli di $08.
;                                  Valori differenti vengono allineati al limite più prossimo.
;                           C = 1: Il valore della pagina iniziale del generatore di caratteri viene restituito in .A
; Parametri di ingresso:  .A: Indirizzo della pagina iniziale del blocco di memoria
;                          C: Selettore di lettura/scrittura
; Parametri di uscita:    .A: Indirizzo della pagina iniziale del blocco di memoria
; Registri alterati:      .A
; Puntatori zp alterati:  ---
; Temporanei alterati:    ---
; Dipendenze esterne:     symbols.asm, standard.asm, kernal.asm, vic_ii.asm, cia.asm
!macro Vic_CharGen {
  !zone Vic_CharGen
  VIC_CHARGEN:
    bcs .RdChr                  ; Se C=1 vai alla routine di recupero indirizzo.

    and #%00111000              ; Allinea il valore fornito ai 2KB ed estrai l'offset.

    lsr a                       ; La posizione della pagina all'interno del banco (bit 2-5)
    lsr a                       ; va spostata nei bit meno significativi.
    ora #%00000001              ; Il bit 0 non è usato e solitamente è messo ad 1.
    sta ._MASK                  ; Conserva temporaneamente la maschera di selezione.

    lda VMCSB                   ; Indica al VIC-II la posizione del generatore di caratteri.
    and #%11110000
    ora ._MASK
    sta VMCSB
    +Bra .Exit_VIC_CHARGEN

  .RdChr:
    jsr VIC_BANK                ; C è già 1, quindi leggi la posizione iniziale del banco video
    sta ._MASK                  ; e conservalo temporaneamente.

    lda VMCSB                   ; Estrai dal registro di controllo la posizione
    and #%00001110              ; della pagina iniziale del generatore di caratteri (il bit 0 non è usato)
    asl a                       ; e moltiplicala per 4.
    asl a
    ora ._MASK                  ; Aggiungi la pagina iniziale del banco video.

  .Exit_VIC_CHARGEN:
    rts

  ._MASK            !byte 0
  !zone
}

; Titolo:                 MACRO: Seleziona la posizione iniziale della memoria ad alta risoluzione
; Nome:                   VIC_BITMAP
; Scopo:                  Imposta o recupera l'indirizzo iniziale della memoria ad alta risoluzione
;                           C = 0: .A contiene la pagina iniziale della memoria ad alta risoluzione, che può variare da $00 a $E0 ad intervalli di $20.
;                                  Valori differenti vengono allineati al limite più prossimo.
;                           C = 1: Il valore della pagina iniziale del generatore di caratteri viene restituito in .A
; Parametri di ingresso:  .A: Indirizzo della pagina iniziale del blocco di memoria
;                          C: Selettore di lettura/scrittura
; Parametri di uscita:    .A: Indirizzo della pagina iniziale del blocco di memoria
; Registri alterati:      .A
; Puntatori zp alterati:  Nessuno
; Temporanei alterati:    Nessuno
; Dipendenze esterne:     symbols.asm, standard.asm, kernal.asm, vic_ii.asm, cia.asm
!macro Vic_Bitmap {
  !zone Vic_Bitmap
  VIC_BITMAP:
    bcs .RdBmp                  ; Se C=1 vai alla routine di recupero indirizzo.

    and #%00100000              ; Allinea il valore fornito agli 8KB ed estrai l'offset.

    lsr a                       ; La posizione della pagina all'interno del banco (bit 5)
    lsr a                       ; va spostata nel bit 3.
    sta ._MASK                  ; Conserva temporaneamente la maschera di selezione.

    lda VMCSB                   ; Indica al VIC-II la posizione dell'area grafica bitmap.
    and #%11110111
    ora ._MASK
    sta VMCSB
    +Bra .Exit_VIC_BITMAP

  .RdBmp:
    jsr VIC_BANK                ; C è già 1, quindi leggi la posizione iniziale del banco video
    sta ._MASK                  ; e conservalo temporaneamente.

    lda VMCSB                   ; Estrai dal registro di controllo la posizione
    and #%00001000              ; della pagina iniziale dell'area grafica bitmap
    asl a                       ; e moltiplicala per 4.
    asl a
    ora ._MASK                  ; Aggiungi la pagina iniziale del banco video.

  .Exit_VIC_BITMAP:
    rts

  ._MASK            !byte 0
  !zone
}

; Titolo:                 MACRO: Sposta il generatore di caratteri in RAM
; Nome:                   VIC_COPY_CHARGEN
; Scopo:                  Sposta il generatore di caratteri dalla ROM alla RAM, nella posizione definita
;                         dalla configurazione del chip VIC-II attualmente in uso
; Parametri di ingresso:  ---
; Parametri di uscita:    ---
; Registri alterati:      .A, .X, .Y
; Puntatori zp alterati:  INDEX, INDEX2
; Temporanei alterati:    ---
; Dipendenze esterne:     symbols.asm, standard.asm, kernal.asm, vic_ii.asm, cia.asm, 6510_tools.asm
!macro Vic_Copy_CharGen {
  !zone Vic_Copy_CharGen
  VIC_COPY_CHARGEN:
    lda #<CHRGEN                ; Prepara i puntatori:
    sta INDEX                   ; INDEX = CHRGEN.
    lda #>CHRGEN
    sta INDEX+1

    lda #$00                    ; INDEX_2 = VICCHR * $1000.
    sta INDEX2
    sec
    jsr VIC_CHARGEN
    sta INDEX2+1

    jsr ENACHR                  ; Attiva il generatore di caratteri e disabilita l'I/O.

    ldy #$00                    ; Trasferisci 4KB di ROM, cioè 16 pagine di memoria.
    ldx #16

  .Loop_Copy_Page:
    lda (INDEX),y
    sta (INDEX2),y

    inc INDEX
    inc INDEX2
    bne .Loop_Copy_Page

    inc INDEX+1
    inc INDEX2+1

    dex
    bne .Loop_Copy_Page

    jsr DISCHR                  ; Riabilita l'I/O.

  .Exit_VIC_COPY_CHARGEN:
    rts
  !zone
}

; Titolo:                 MACRO: Abilita la modalità grafica bitmap
; Nome:                   VIC_Bitmap_On
; Scopo:                  Attiva la modalità grafica bitmap
; Parametri di ingresso:  ---
; Parametri di uscita:    ---
; Registri alterati:      .A
; Puntatori zp alterati:  ---
; Temporanei alterati:    ---
; Dipendenze esterne:     vic_ii.asm
!macro VIC_Bitmap_On {
  lda SCROLY
  ora #%00100000                ; Setta il bit #5.
  sta SCROLY
}

; Titolo:                 MACRO: Disabilita la modalità grafica bitmap
; Nome:                   VIC_Bitmap_Off
; Scopo:                  Disattiva la modalità grafica bitmap
; Parametri di ingresso:  ---
; Parametri di uscita:    ---
; Registri alterati:      .A
; Puntatori zp alterati:  ---
; Temporanei alterati:    ---
; Dipendenze esterne:     vic_ii.asm
!macro VIC_Bitmap_Off {
  lda SCROLY
  and #%11011111                ; Resetta il bit #5.
  sta SCROLY
}

; Titolo:                 MACRO: Abilita la modalità colore esteso
; Nome:                   VIC_Ext_Color_On
; Scopo:                  Attiva la modalità modalità colore esteso
; Parametri di ingresso:  ---
; Parametri di uscita:    ---
; Registri alterati:      .A
; Puntatori zp alterati:  ---
; Temporanei alterati:    ---
; Dipendenze esterne:     vic_ii.asm
!macro VIC_Ext_Color_On {
  lda SCROLY
  ora #%01000000                ; Setta il bit #6.
  sta SCROLY
}

; Titolo:                 MACRO: Disabilita la modalità modalità colore esteso
; Nome:                   VIC_Ext_Color_Off
; Scopo:                  Disattiva la modalità modalità colore esteso
; Parametri di ingresso:  ---
; Parametri di uscita:    ---
; Registri alterati:      .A
; Puntatori zp alterati:  ---
; Temporanei alterati:    ---
; Dipendenze esterne:     vic_ii.asm
!macro VIC_Ext_Color_Off {
  lda SCROLY
  and #%10111111                ; Resetta il bit #6.
  sta SCROLY
}

; Titolo:                 MACRO: Abilita la modalità grafica multicolore
; Nome:                   VIC_Multicolor_On
; Scopo:                  Attiva la modalità grafica multicolore
; Parametri di ingresso:  ---
; Parametri di uscita:    ---
; Registri alterati:      .A
; Puntatori zp alterati:  ---
; Temporanei alterati:    ---
; Dipendenze esterne:     vic_ii.asm
!macro VIC_Multicolor_On {
  lda SCROLX
  ora #%00010000                ; Setta il bit #4.
  sta SCROLX
}

; Titolo:                 MACRO: Disabilita la modalità grafica multicolore
; Nome:                   VIC_Multicolor_Off
; Scopo:                  Disattiva la modalità grafica multicolore
; Parametri di ingresso:  ---
; Parametri di uscita:    ---
; Registri alterati:      .A
; Puntatori zp alterati:  ---
; Temporanei alterati:    ---
; Dipendenze esterne:     vic_ii.asm
!macro VIC_Multicolor_Off {
  lda SCROLX
  and #%11101111                ; Resetta il bit #4.
  sta SCROLX
}
