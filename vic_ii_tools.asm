; ==============================================================================
; FILE:           vic_ii_tools.asm
; PROGETTO:       Libreria di Sistema (system.c64)
; TARGET:         ACME Assembler / MOS 6510 (Commodore 64)
; DESCRIZIONE:    Utilità per la gestione dei modi grafici offerti dal
;                 chip VIC-II.
; CONTENUTO:      m_VIC_Bitmap_On       Abilita il modo bitmap
;                 m_VIC_Bitmap_Off      Disabilita il modo bitmap
;                 m_VIC_Ext_Color_On    Abilita il modo ECM
;                 m_VIC_Ext_Color_Off   Disabilita il modo ECM
;                 m_VIC_Multicolor_On   Abilita il modo multicolore
;                 m_VIC_Multicolor_Off  Disabilita il modo multicolore
;                 VIC_PALETTE           Imposta i registri colore del VIC-II
;                 VIC_BANK              Seleziona il banco di memoria del VIC-II
;                 VIC_SCREEN            Posiziona la memoria schermo
;                 VIC_CHARGEN           Posiziona il generatore di caratteri
;                 VIC_BITMAP            Posiziona la memoria ad alta risoluzione
;                 VIC_COPY_CHARGEN      Sposta il generatore di caratteri in RAM
;                 COMPUTE_CELL_ADDRESS  Calcola l'indirizzo di una cella video
;                 GET_SCREEN_CELL       Legge una cella della memoria schermo
;                 GET_COLOR_CELL        Legge una cella della memoria colore
; DIPENDENZE:     Nessuna
; REQUISITI ZP:   Nessuno
; ==============================================================================

; ==============================================================================
; MACRO: m_VIC_Bitmap_On
; ------------------------------------------------------------------------------
; Descrizione:  Abilita la modalità grafica bitmap impostando il bit #5
;               di SCROLY.
;
; Input:
;   - Nessuno
;
; Output:
;   - SCROLY (1 byte, I/O) : Bit #5 a 1
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .P (Negative, Zero), SCROLY
; Dipendenze Esterne:   <chip/vic_ii.asm>
; ==============================================================================
!macro m_VIC_Bitmap_On {
    lda SCROLY
    ora #%00100000                  ; Setta il bit #5.
    sta SCROLY
}

; ==============================================================================
; MACRO: m_VIC_Bitmap_Off
; ------------------------------------------------------------------------------
; Descrizione:  Disabilita la modalità grafica bitmap azzerando il bit #5
;               di SCROLY.
;
; Input:
;   - Nessuno
;
; Output:
;   - SCROLY (1 byte, I/O) : Bit #5 a 0
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .P (Negative, Zero), SCROLY
; Dipendenze Esterne:   <chip/vic_ii.asm>
; ==============================================================================
!macro m_VIC_Bitmap_Off {
    lda SCROLY
    and #%11011111                  ; Resetta il bit #5.
    sta SCROLY
}

; ==============================================================================
; MACRO: m_VIC_Ext_Color_On
; ------------------------------------------------------------------------------
; Descrizione:  Abilita il modo Colore di Sfondo Esteso (ECM) impostando il
;               bit #6 di SCROLY.
;
; Input:
;   - Nessuno
;
; Output:
;   - SCROLY (1 byte, I/O) : Bit #6 a 1
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .P (Negative, Zero), SCROLY
; Dipendenze Esterne:   <chip/vic_ii.asm>
; ==============================================================================
!macro m_VIC_Ext_Color_On {
    lda SCROLY
    ora #%01000000                  ; Setta il bit #6.
    sta SCROLY
}

; ==============================================================================
; MACRO: m_VIC_Ext_Color_Off
; ------------------------------------------------------------------------------
; Descrizione:  Disabilita il modo Colore di Sfondo Esteso (ECM) azzerando il
;               bit #6 di SCROLY.
;
; Input:
;   - Nessuno
;
; Output:
;   - SCROLY (1 byte, I/O) : Bit #6 a 0
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .P (Negative, Zero), SCROLY
; Dipendenze Esterne:   <chip/vic_ii.asm>
; ==============================================================================
!macro m_VIC_Ext_Color_Off {
    lda SCROLY
    and #%10111111                  ; Resetta il bit #6.
    sta SCROLY
}

; ==============================================================================
; MACRO: m_VIC_Multicolor_On
; ------------------------------------------------------------------------------
; Descrizione:  Abilita la modalità grafica multicolore impostando il bit #4
;               di SCROLX.
;
; Input:
;   - Nessuno
;
; Output:
;   - SCROLX (1 byte, I/O) : Bit #4 a 1
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .P (Negative, Zero), SCROLX
; Dipendenze Esterne:   <chip/vic_ii.asm>
; ==============================================================================
!macro m_VIC_Multicolor_On {
    lda SCROLX
    ora #%00010000                  ; Setta il bit #4.
    sta SCROLX
}

; ==============================================================================
; MACRO: m_VIC_Multicolor_Off
; ------------------------------------------------------------------------------
; Descrizione:  Disabilita la modalità grafica multicolore azzerando il bit #4
;               di SCROLX.
;
; Input:
;   - Nessuno
;
; Output:
;   - SCROLX (1 byte, I/O) : Bit #4 a 0
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .P (Negative, Zero), SCROLX
; Dipendenze Esterne:   <chip/vic_ii.asm>
; ==============================================================================
!macro m_VIC_Multicolor_Off {
    lda SCROLX
    and #%11101111                  ; Resetta il bit #4.
    sta SCROLX
}

; ==============================================================================
; SUBROUTINE: VIC_PALETTE
; ------------------------------------------------------------------------------
; Descrizione:  Imposta i colori di bordo, sfondo, carattere, multicolore/colore
;               esteso e multicolore/sprite in un'unica operazione. L'indirizzo
;               in .XA punta ad un blocco di memoria che contiene in successione
;               i valori da assegnare ai registri EXTCOL, BGCOL0, BGCOL1,
;               BGCOL2, BGCOL3, SPMC0, SPMC1 e COLOR. Se il valore è
;               VIC_TRANSPARENT il registro resta immutato.
;
; Input:
;   - .A (1 byte, CPU)     : Indirizzo del blocco di memoria (byte basso)
;   - .X (1 byte, CPU)     : Indirizzo del blocco di memoria (byte alto)
;   - blocco (8 byte, RAM) : Valori per EXTCOL, BGCOL0, BGCOL1, BGCOL2, BGCOL3,
;                            SPMC0, SPMC1 e COLOR, in quest'ordine
;
; Output:
;   - EXTCOL (1 byte, I/O) : Colore del bordo (se non è VIC_TRANSPARENT)
;   - BGCOL0 (1 byte, I/O) : Colore dello sfondo (se non è VIC_TRANSPARENT)
;   - BGCOL1 (1 byte, I/O) : Colore di sfondo 1 (se non è VIC_TRANSPARENT)
;   - BGCOL2 (1 byte, I/O) : Colore di sfondo 2 (se non è VIC_TRANSPARENT)
;   - BGCOL3 (1 byte, I/O) : Colore di sfondo 3 (se non è VIC_TRANSPARENT)
;   - SPMC0 (1 byte, I/O)  : Colore comune degli sprite multicolori 0 (se non
;                            è VIC_TRANSPARENT)
;   - SPMC1 (1 byte, I/O)  : Colore comune degli sprite multicolori 1 (se non
;                            è VIC_TRANSPARENT)
;   - COLOR (1 byte, RAM)  : Colore dei caratteri (se non è VIC_TRANSPARENT)
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .Y, .P (Negative, Zero), INDEX2, EXTCOL, BGCOL0,
;                       BGCOL1, BGCOL2, BGCOL3, SPMC0, SPMC1, COLOR
; Dipendenze Esterne:   <c64/symbols.asm>
;                       <chip/vic_ii.asm>
; ==============================================================================
!if (__USE_VIC_PALETTE = 1) {
  !zone VIC_Palette

    VIC_PALETTE:
      sta INDEX2                    ; Prepara i registri.
      stx INDEX2+1
      ldy #7

      lda (INDEX2),y                ; Imposta il colore dei caratteri: se il colore è
      bmi .VIC_Registers            ; il valore speciale VIC_TRANSPARENT allora non modificare il
                                    ; registro colore.

      sta COLOR

    .VIC_Registers:
      dey                           ; FOR (Inizializzazione)

    .Loop_Color_Register:
      ; Imposta i registri colore: se il colore è il valore speciale
      ; VIC_TRANSPARENT allora non modificare il registro.

      lda (INDEX2),y                ; FOR (Corpo)
      bmi .Next_Color_Register

      sta EXTCOL,y

    .Next_Color_Register:
      dey                           ; NEXT: passa al registro precedente
      bpl .Loop_Color_Register      ; NEXT: ripete finché .Y non è negativo

    .Exit_VIC_PALETTE:
      rts

  !zone
}

; ==============================================================================
; SUBROUTINE: VIC_BANK
; ------------------------------------------------------------------------------
; Descrizione:  Imposta o recupera l'indirizzo iniziale del banco di memoria da
;               16 KB visibile dal chip VIC-II.
;                 C = 0: .A contiene la pagina iniziale del banco da
;                        selezionare, che può essere $00, $40, $80 oppure
;                        $C0. Valori differenti vengono allineati al limite
;                        inferiore.
;                 C = 1: Il valore della pagina iniziale del banco di memoria
;                        viene restituito in .A.
;
; Input:
;   - .A (1 byte, CPU)       : Pagina iniziale del banco (solo se C = 0)
;   - Flag Carry (1 bit, .P) : 0 = imposta; 1 = legge
;
; Output:
;   - .A (1 byte, CPU)       : Pagina iniziale del banco (solo se C = 1)
;   - C2DDRA (1 byte, I/O)   : Porte di selezione in uscita (solo se C = 0)
;   - CI2PRA (1 byte, I/O)   : Selezione del banco (solo se C = 0)
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .P (Negative, Zero, Carry), C2DDRA, CI2PRA
; Dipendenze Esterne:   <chip/cia.asm>
;                       <system/branch.asm>
; ==============================================================================
!if (__USE_VIC_BANK = 1) {
  !zone VIC_Bank

    VIC_BANK:
      bcs .Else_Read_Bank           ; Se C=1 vai alla subroutine di recupero indirizzo.

      rol a                         ; L'accumulatore deve contenere un valore tra 0 e 3.
      rol a
      rol a
      and #%00000011
      eor #%00000011                ; I bit di selezione del banco hanno un valore inverso a
                                    ; quello del numero del banco.
      sta ._MASK                    ; Conserva temporaneamente la maschera di selezione.

      lda C2DDRA                    ; Setta le porte di controllo del cambio
      ora #%00000011                ; di banco in direzione di uscita.
      sta C2DDRA

      lda CI2PRA                    ; Maschera i bit da lasciare immutati
      and #%11111100
      ora ._MASK                    ; ed applica la maschera di selezione.
      sta CI2PRA
      +m_Bra .Exit_VIC_BANK

    .Else_Read_Bank:
      lda CI2PRA                    ; Inverti il valore dei bit di selezione del banco
      eor #%00000011

      ror a                         ; poi spostali nei bit #6 e #7 e pulisci i bit non necessari.
      ror a
      ror a
      and #%11000000

    .Exit_VIC_BANK:
      rts

    ._MASK:
      !byte 0

  !zone
}

; ==============================================================================
; SUBROUTINE: VIC_SCREEN
; ------------------------------------------------------------------------------
; Descrizione:  Imposta o recupera l'indirizzo iniziale della memoria schermo.
;                 C = 0: .A contiene la pagina iniziale della memoria schermo,
;                        che può variare da $00 a $FC ad intervalli di $04.
;                        Valori differenti vengono allineati al limite
;                        inferiore.
;                 C = 1: Il valore della pagina iniziale della memoria schermo
;                        viene restituito in .A.
;               Richiede __USE_VIC_BANK = 1.
;
; Input:
;   - .A (1 byte, CPU)       : Pagina iniziale della memoria schermo (C = 0)
;   - Flag Carry (1 bit, .P) : 0 = imposta; 1 = legge
;
; Output:
;   - .A (1 byte, CPU)       : Pagina iniziale della memoria schermo (C = 1)
;   - HIBASE (1 byte, RAM)   : Pagina per l'editor del BASIC (solo se C = 0)
;   - VMCSB (1 byte, I/O)    : Posizione della memoria schermo (solo se C = 0)
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .P (Negative, Zero, Carry), HIBASE, VMCSB
; Dipendenze Esterne:   <c64/symbols.asm>
;                       <chip/vic_ii.asm>
;                       <system/branch.asm>
; ==============================================================================
!if (__USE_VIC_SCREEN = 1) {
  !zone VIC_Screen

    VIC_SCREEN:
      bcs .Else_Read_Screen         ; Se C=1 vai alla subroutine di recupero indirizzo.

      and #%11111100                ; Allinea il valore fornito al KB.
      sta HIBASE                    ; Aggiusta HIBASE in modo che l'editor del BASIC conosca la
                                    ; nuova posizione della memoria schermo.

      asl a                         ; La posizione della pagina all'interno del banco
      asl a                         ; (bit #5-#2) va spostata nei bit più significativi.
      sta ._MASK                    ; Conserva temporaneamente la maschera di selezione.

      lda VMCSB                     ; Indica al VIC-II la posizione della memoria schermo.
      and #%00001111
      ora ._MASK
      sta VMCSB
      +m_Bra .Exit_VIC_SCREEN

    .Else_Read_Screen:
      jsr VIC_BANK                  ; C è già 1, quindi leggi la posizione iniziale del banco
      sta ._MASK                    ; video e conservalo temporaneamente.

      lda VMCSB                     ; Estrai dal registro di controllo la posizione
      and #%11110000                ; della pagina iniziale di memoria schermo
      lsr a                         ; e dividila per 4.
      lsr a
      ora ._MASK                    ; Aggiungi la pagina iniziale del banco video.

    .Exit_VIC_SCREEN:
      rts

    ._MASK:
      !byte 0

  !zone
}

; ==============================================================================
; SUBROUTINE: VIC_CHARGEN
; ------------------------------------------------------------------------------
; Descrizione:  Imposta o recupera l'indirizzo iniziale del generatore
;               di caratteri.
;                 C = 0: .A contiene la pagina iniziale del generatore di
;                        caratteri, che può variare da $00 a $F8 ad intervalli
;                        di $08. Valori differenti vengono allineati al limite
;                        inferiore.
;                 C = 1: Il valore della pagina iniziale del generatore di
;                        caratteri viene restituito in .A.
;               Richiede __USE_VIC_BANK = 1.
;
; Input:
;   - .A (1 byte, CPU)       : Pagina iniziale del generatore di caratteri (solo
;                              se C = 0)
;   - Flag Carry (1 bit, .P) : 0 = imposta; 1 = legge
;
; Output:
;   - .A (1 byte, CPU)       : Pagina iniziale del generatore di caratteri (solo
;                              se C = 1)
;   - VMCSB (1 byte, I/O)    : Posizione del generatore (solo se C = 0)
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .P (Negative, Zero, Carry), VMCSB
; Dipendenze Esterne:   <chip/vic_ii.asm>
;                       <system/branch.asm>
; ==============================================================================
!if (__USE_VIC_CHARGEN = 1) {
  !zone VIC_Chargen

    VIC_CHARGEN:
      bcs .Else_Read_Chargen        ; Se C=1 vai alla subroutine di recupero indirizzo.

      and #%00111000                ; Allinea il valore fornito ai 2 KB ed estrai l'offset.

      lsr a                         ; La posizione della pagina all'interno del banco
      lsr a                         ; (bit #5-#3) va spostata nei bit meno significativi.
      ora #%00000001                ; Il bit #0 non è usato e solitamente è messo ad 1.
      sta ._MASK                    ; Conserva temporaneamente la maschera di selezione.

      lda VMCSB                     ; Indica al VIC-II la posizione del generatore di caratteri.
      and #%11110000
      ora ._MASK
      sta VMCSB
      +m_Bra .Exit_VIC_CHARGEN

    .Else_Read_Chargen:
      jsr VIC_BANK                  ; C è già 1, quindi leggi la posizione iniziale del banco
      sta ._MASK                    ; video e conservalo temporaneamente.

      lda VMCSB                     ; Estrai dal registro di controllo la posizione
      and #%00001110                ; della pagina iniziale del generatore di caratteri
      asl a                         ; (il bit #0 non è usato) e moltiplicala per 4.
      asl a
      ora ._MASK                    ; Aggiungi la pagina iniziale del banco video.

    .Exit_VIC_CHARGEN:
      rts

    ._MASK:
      !byte 0

  !zone
}

; ==============================================================================
; SUBROUTINE: VIC_BITMAP
; ------------------------------------------------------------------------------
; Descrizione:  Imposta o recupera l'indirizzo iniziale della memoria ad
;               alta risoluzione.
;                 C = 0: .A contiene la pagina iniziale della memoria ad alta
;                        risoluzione, che può variare da $00 a $E0 ad intervalli
;                        di $20. Valori differenti vengono allineati al limite
;                        inferiore.
;                 C = 1: Il valore della pagina iniziale della memoria ad alta
;                        risoluzione viene restituito in .A.
;               Richiede __USE_VIC_BANK = 1.
;
; Input:
;   - .A (1 byte, CPU)       : Pagina iniziale della memoria bitmap (C = 0)
;   - Flag Carry (1 bit, .P) : 0 = imposta; 1 = legge
;
; Output:
;   - .A (1 byte, CPU)       : Pagina iniziale della memoria bitmap (C = 1)
;   - VMCSB (1 byte, I/O)    : Posizione della memoria bitmap (solo se C = 0)
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .P (Negative, Zero, Carry), VMCSB
; Dipendenze Esterne:   <chip/vic_ii.asm>
;                       <system/branch.asm>
; ==============================================================================
!if (__USE_VIC_BITMAP = 1) {
  !zone VIC_Bitmap

    VIC_BITMAP:
      bcs .Else_Read_Bitmap         ; Se C=1 vai alla subroutine di recupero indirizzo.

      and #%00100000                ; Allinea il valore fornito agli 8 KB ed estrai l'offset.

      lsr a                         ; La posizione della pagina all'interno del banco (bit #5)
      lsr a                         ; va spostata nel bit #3.
      sta ._MASK                    ; Conserva temporaneamente la maschera di selezione.

      lda VMCSB                     ; Indica al VIC-II la posizione dell'area grafica bitmap.
      and #%11110111
      ora ._MASK
      sta VMCSB
      +m_Bra .Exit_VIC_BITMAP

    .Else_Read_Bitmap:
      jsr VIC_BANK                  ; C è già 1, quindi leggi la posizione iniziale del banco
      sta ._MASK                    ; video e conservalo temporaneamente.

      lda VMCSB                     ; Estrai dal registro di controllo la posizione
      and #%00001000                ; della pagina iniziale dell'area grafica bitmap
      asl a                         ; e moltiplicala per 4.
      asl a
      ora ._MASK                    ; Aggiungi la pagina iniziale del banco video.

    .Exit_VIC_BITMAP:
      rts

    ._MASK:
      !byte 0

  !zone
}

; ==============================================================================
; SUBROUTINE: VIC_COPY_CHARGEN
; ------------------------------------------------------------------------------
; Descrizione:  Sposta il generatore di caratteri dalla ROM alla RAM, nella
;               posizione definita dalla configurazione del chip VIC-II
;               attualmente in uso.
;               Richiede __USE_VIC_CHARGEN = 1.
;
; Input:
;   - Nessuno
;
; Output:
;   - generatore (4096 byte, RAM) : Copia del generatore di caratteri della ROM
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .X, .Y, .P (Negative, Zero, Carry), INDEX, INDEX2,
;                       R6510, CIAICR
; Dipendenze Esterne:   <c64/symbols.asm>
;                       <system/6510_tools.asm>
; ==============================================================================
!if (__USE_VIC_COPY_CHARGEN = 1) {
  !zone VIC_Copy_Chargen

    VIC_COPY_CHARGEN:
      lda #<CHRGEN                  ; Prepara i puntatori:
      sta INDEX                     ; INDEX = CHRGEN.
      lda #>CHRGEN
      sta INDEX+1

      lda #$00                      ; INDEX2 punta all'indirizzo al quale il chip VIC-II è
                                    ; programmato, mediante il registro VMCSB, per trovare le
                                    ; definizioni dei caratteri.
      sta INDEX2
      sec
      jsr VIC_CHARGEN
      sta INDEX2+1

      +m_Disable_IO                 ; Rendi visibile il generatore di caratteri e
                                    ; disabilita l'I/O.

      ldy #0                        ; Trasferisci 4 KB di ROM, cioè 16 pagine di memoria.
      ldx #16

    .Loop_Copy_Byte_And_Page:
      lda (INDEX),y                 ; REPEAT
      sta (INDEX2),y

    .Loop_Check_Byte:
      iny
      bne .Loop_Copy_Byte_And_Page  ; REPEAT UNTIL: la pagina è finita

      inc INDEX+1
      inc INDEX2+1

    .Loop_Check_Page:
      dex
      bne .Loop_Copy_Byte_And_Page  ; REPEAT UNTIL: le pagine sono finite

      +m_Enable_IO                  ; Riabilita l'I/O e rendi invisibile il generatore
                                    ; di caratteri.

    .Exit_VIC_COPY_CHARGEN:
      rts

  !zone
}

; ==============================================================================
; SUBROUTINE: COMPUTE_CELL_ADDRESS
; ------------------------------------------------------------------------------
; Descrizione:  Calcola in modo veloce, mediante tavole, la cella di memoria
;               corrispondente ad una posizione dello schermo espressa in
;               notazione cartesiana: origine in alto a sinistra, asse x verso
;               destra, asse y verso il basso. Se .A = 0 restituisce in INDEX2
;               l'offset rispetto all'origine (0; 0), altrimenti la posizione
;               assoluta per uno schermo che inizia alla pagina contenuta in .A:
;               .A = (HIBASE) per lo schermo corrente, .A = >COLRAM per la
;               memoria colore.
;
; Input:
;   - .A (1 byte, CPU)    : Pagina base dello schermo (0 = offset dall'origine)
;   - .X (1 byte, CPU)    : Colonna della cella (0-39)
;   - .Y (1 byte, CPU)    : Riga della cella (0-24)
;
; Output:
;   - INDEX2 (2 byte, ZP) : Indirizzo della cella (offset se .A = 0)
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .P (Negative, oVerflow, Zero, Carry), INDEX2
; Dipendenze Esterne:   <c64/symbols.asm>
; ==============================================================================
!if (__USE_COMPUTE_CELL_ADDRESS = 1) {
  !zone Compute_Cell_Address

    COMPUTE_CELL_ADDRESS:
      pha                           ; Salva l'indirizzo di base sullo stack.
      clc                           ; Somma il valore della colonna selezionata al byte basso
                                    ; dell'offset della posizione iniziale della riga scelta.
      txa
      adc .ROW_OFFSET_LO,y
      sta INDEX2                    ; Salva il byte basso dell'indirizzo della cella in INDEX2.

      pla                           ; Estrai il byte alto dell'offset e sommalo all'indirizzo alto
      adc .ROW_OFFSET_HI,y          ; della pagina base assieme al riporto generato dalla somma
      sta INDEX2+1                  ; precedente, poi salvalo in INDEX2+1.

    .Exit_COMPUTE_CELL_ADDRESS:
      rts

    ; Byte basso degli offset della posizione iniziale di ciascuna
    ; riga dello schermo.
    .ROW_OFFSET_LO:
      !byte   <0,  <40,  <80, <120, <160, <200, <240, <280
      !byte <320, <360, <400, <440, <480, <520, <560, <600
      !byte <640, <680, <720, <760, <800, <840, <880, <920
      !byte <960

    ; Byte alto degli offset della posizione iniziale di ciascuna
    ; riga dello schermo.
    .ROW_OFFSET_HI:
      !byte   >0,  >40,  >80, >120, >160, >200, >240, >280
      !byte >320, >360, >400, >440, >480, >520, >560, >600
      !byte >640, >680, >720, >760, >800, >840, >880, >920
      !byte >960

  !zone
}

; ==============================================================================
; SUBROUTINE: GET_SCREEN_CELL
; ------------------------------------------------------------------------------
; Descrizione:  Restituisce il codice schermo del carattere posizionato alla
;               colonna .X ed alla riga .Y dello schermo corrente.
;               Richiede __USE_COMPUTE_CELL_ADDRESS = 1.
;
; Input:
;   - .X (1 byte, CPU)    : Colonna della cella (0-39)
;   - .Y (1 byte, CPU)    : Riga della cella (0-24)
;
; Output:
;   - .A (1 byte, CPU)    : Codice schermo del carattere
;   - INDEX2 (2 byte, ZP) : Indirizzo della cella
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .Y, .P (Negative, oVerflow, Zero, Carry), INDEX2
; Dipendenze Esterne:   <c64/symbols.asm>
; ==============================================================================
!if (__USE_GET_SCREEN_CELL = 1) {
  !zone Get_Screen_Cell

    GET_SCREEN_CELL:
      lda HIBASE                    ; Inizializza .A con l'indirizzo di base della memoria schermo
      jsr COMPUTE_CELL_ADDRESS      ; e calcola l'indirizzo della cella.

      ldy #0                        ; Restituisci in .A il contenuto della cella.
      lda (INDEX2),y

    .Exit_GET_SCREEN_CELL:
      rts

  !zone
}

; ==============================================================================
; SUBROUTINE: GET_COLOR_CELL
; ------------------------------------------------------------------------------
; Descrizione:  Restituisce il codice del colore del carattere posizionato alla
;               colonna .X ed alla riga .Y dello schermo corrente.
;               Richiede __USE_COMPUTE_CELL_ADDRESS = 1.
;
; Input:
;   - .X (1 byte, CPU)    : Colonna della cella (0-39)
;   - .Y (1 byte, CPU)    : Riga della cella (0-24)
;
; Output:
;   - .A (1 byte, CPU)    : Codice del colore (0-15)
;   - INDEX2 (2 byte, ZP) : Indirizzo della cella
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .Y, .P (Negative, oVerflow, Zero, Carry), INDEX2
; Dipendenze Esterne:   <c64/symbols.asm>
; ==============================================================================
!if (__USE_GET_COLOR_CELL = 1) {
  !zone Get_Color_Cell

    GET_COLOR_CELL:
      lda #>COLRAM                  ; Inizializza .A con l'indirizzo di base della memoria colore.

      jsr COMPUTE_CELL_ADDRESS      ; Calcola l'indirizzo della cella.

      ldy #0                        ; Restituisci in .A il contenuto della cella
      lda (INDEX2),y                ; azzerando i bit spurii.
      and #%00001111

    .Exit_GET_COLOR_CELL:
      rts

  !zone
}
