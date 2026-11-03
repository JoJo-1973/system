; ==============================================================================
; FILE:           standard.asm
; PROGETTO:       Libreria di Sistema (system.c64)
; TARGET:         ACME Assembler / MOS 6510 (Commodore 64)
; DESCRIZIONE:    Macro utili per la programmazione.
; CONTENUTO:      m_BASIC_Preamble  Inserisce una riga BASIC con SYS
;                 m_Exit_To_BASIC   Esce al prompt del BASIC
;                 m_Swap8           Scambia due valori a 8 bit
;                 m_Push_AXY        Salva .A, .X e .Y sullo stack
;                 m_Pull_AXY        Recupera .A, .X e .Y dallo stack
;                 m_Push_XY         Salva .X e .Y sullo stack
;                 m_Pull_XY         Recupera .X e .Y dallo stack
;                 m_SeV             Imposta il flag oVerflow
;                 m_CCf             Complementa il flag Carry
;                 m_Skip1           Maschera l'istruzione seguente (1 byte)
;                 m_Skip2           Maschera l'istruzione seguente (2 byte)
;                 m_Delay_5n1       Consuma 5n+1 cicli a vuoto
; DIPENDENZE:     Nessuna
; REQUISITI ZP:   Nessuno
; ==============================================================================

; ==============================================================================
; MACRO: m_BASIC_Preamble
; ------------------------------------------------------------------------------
; Descrizione:  Inserisce una riga di BASIC con un comando SYS ed,
;               opzionalmente, un commento REM.
;
; Input:
;   - .line_num_ (2 byte, Macro) : Numero di riga
;   - .label_ (2 byte, Macro)    : Etichetta del punto di ingresso
;   - .comment_ (stringa, Macro) : (opzionale) Commento aggiunto come REM
;
; Output:
;   - Nessuno
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  Nessuno
; Dipendenze Esterne:   Nessuna
; ==============================================================================
!macro m_BASIC_Preamble .line_num_, .label_, .comment_ {
    !ifndefparam .comment_ {
      !basic .line_num_, .label_
    } else {
      !basic .line_num_, ":", $8F, " ", .comment_, .label_  ; Nel caso sia specificato il commento aggiungi ":REM " +
                                                            ; .comment_ in coda: $8F è il token dell'istruzione "REM"
    }
}

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
;   - Stabile
;
; Registri Modificati:  .X, .P
; Dipendenze Esterne:   <c64/errors.asm>
;                       <c64/symbols.asm>
; ==============================================================================
!macro m_Exit_To_BASIC {
    ldx #ERR_READY                                          ; Carica il codice d'errore corrispondente a "READY."
    jmp (IERROR)                                            ; e ritorna al BASIC in maniera pulita
}

; ==============================================================================
; MACRO: m_Swap8
; ------------------------------------------------------------------------------
; Descrizione:  Scambia i valori contenuti in due locazioni di memoria a 8 bit,
;               usando .X e .Y.
;
; Input:
;   - .addr1_ (1 o 2 byte, Macro) : Indirizzo del primo valore
;   - .addr2_ (1 o 2 byte, Macro) : Indirizzo del secondo valore
;
; Output:
;   - Nessuno
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .X, .Y, .P
; Dipendenze Esterne:   Nessuna
; ==============================================================================
!macro m_Swap8 .addr1_, .addr2_ {
    ldx .addr1_                                             ; Semplicemente carica .X e .Y con i contenuti da scambiare
    ldy .addr2_                                             ; e riscrivili in ordine inverso
    stx .addr2_
    sty .addr1_
}

; ==============================================================================
; MACRO: m_Push_AXY
; ------------------------------------------------------------------------------
; Descrizione:  Copia i registri .A, .X e .Y sullo stack.
;
; Input:
;   - Nessuno
;
; Output:
;   - Nessuno
;
; Variazione Stack (.S):
;   - Decrementato di 3 byte
;
; Registri Modificati:  .A, .P
; Dipendenze Esterne:   Nessuna
; ==============================================================================
!macro m_Push_AXY {
    pha                                                     ; Prima .A

    txa                                                     ; poi .X
    pha

    tya                                                     ; e per ultimo .Y
    pha
}

; ==============================================================================
; MACRO: m_Pull_AXY
; ------------------------------------------------------------------------------
; Descrizione:  Recupera i registri .A, .X e .Y dallo stack.
;
; Input:
;   - Nessuno
;
; Output:
;   - Nessuno
;
; Variazione Stack (.S):
;   - Incrementato di 3 byte
;
; Registri Modificati:  .A, .X, .Y, .P
; Dipendenze Esterne:   Nessuna
; ==============================================================================
!macro m_Pull_AXY {
    pla                                                     ; Prima .Y
    tay

    pla                                                     ; poi .X
    tax

    pla                                                     ; e per ultimo .A
}

; ==============================================================================
; MACRO: m_Push_XY
; ------------------------------------------------------------------------------
; Descrizione:  Copia i registri .X e .Y sullo stack, riservando prima una
;               posizione per .A, che m_Pull_XY userà per ripristinarlo.
;
; Input:
;   - Nessuno
;
; Output:
;   - Nessuno
;
; Variazione Stack (.S):
;   - Decrementato di 3 byte
;
; Registri Modificati:  .A, .P
; Dipendenze Esterne:   Nessuna
; ==============================================================================
!macro m_Push_XY {
    pha                                                     ; Riserva una posizione sullo stack: servirà a m_Pull_XY.
                                                            ; Il contenuto di questa posizione è irrilevante.

    txa                                                     ; poi salva .X
    pha

    tya                                                     ; e per ultimo .Y
    pha
}

; ==============================================================================
; MACRO: m_Pull_XY
; ------------------------------------------------------------------------------
; Descrizione:  Recupera i registri .X e .Y dallo stack, lasciando invariato .A.
;
; Input:
;   - Nessuno
;
; Output:
;   - Nessuno
;
; Variazione Stack (.S):
;   - Incrementato di 3 byte
;
; Registri Modificati:  .X, .Y, .P
; Dipendenze Esterne:   <c64/symbols.asm>
; ==============================================================================
!macro m_Pull_XY {
    tsx                                                     ; Recupera il puntatore allo stack ed incrementalo di 3 unità:
    inx                                                     ; ora .X punta alla posizione riservata da m_Push_XY
    inx                                                     ; e che non contiene dati utili:
    inx                                                     ; poiché .A verrà alterato dalle istruzioni che seguono
    sta STACK,x                                             ; usala per per memorizzare il valore originario di .A

    pla                                                     ; Recupera .Y
    tay

    pla                                                     ; Recupera .X
    tax

    pla                                                     ; Ripristina .A
}

; ==============================================================================
; MACRO: m_SeV
; ------------------------------------------------------------------------------
; Descrizione:  Imposta il flag oVerflow senza alterare gli altri flag: spreca
;               cicli ed istruzioni.
;
; Input:
;   - Nessuno
;
; Output:
;   - Flag oVerflow (1 bit, .P) : sempre 1
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .P (oVerflow)
; Dipendenze Esterne:   Nessuna
; ==============================================================================
!macro m_SeV {
    php                                                     ; Copia .P in .A
    pla

    ora #%01000000                                          ; Setta il bit #6

    pha                                                     ; Copia .A in .P
    plp
}

; ==============================================================================
; MACRO: m_CCf
; ------------------------------------------------------------------------------
; Descrizione:  Complementa il flag Carry senza alterare gli altri flag: spreca
;               cicli ed istruzioni.
;
; Input:
;   - Nessuno
;
; Output:
;   - Flag Carry (1 bit, .P) : 0 = prima era 1; 1 = prima era 0
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .P (Carry)
; Dipendenze Esterne:   Nessuna
; ==============================================================================
!macro m_CCf {
    php                                                     ; Copia .P in .A
    pla

    eor #%00000001                                          ; Inverti il bit #0

    pha                                                     ; Copia .A in .P
    plp
}

; ==============================================================================
; MACRO: m_Skip1
; ------------------------------------------------------------------------------
; Descrizione:  Inserisce l'istruzione illegale NOP #imm (2 cicli) in modo da
;               mascherare l'istruzione da un byte che segue, senza alterare i
;               flag. Il byte emesso è l'opcode di NOP: il primo byte
;               dell'istruzione seguente ne diventa l'operando e non viene
;               eseguito.
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
; Registri Modificati:  Nessuno
; Dipendenze Esterne:   Nessuna
; ==============================================================================
!macro m_Skip1 {
    !byte $80                                               ; L'esecuzione di questa istruzione maschera l'opcode da un
                                                            ; byte che segue senza alterare i flag
}

; ==============================================================================
; MACRO: m_Skip2
; ------------------------------------------------------------------------------
; Descrizione:  Inserisce l'istruzione illegale NOP abs (4 cicli) in modo da
;               mascherare l'istruzione da due byte che segue, senza alterare i
;               flag. Il byte emesso è l'opcode di NOP: i due byte
;               dell'istruzione seguente ne diventano l'operando e non vengono
;               eseguiti.
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
; Registri Modificati:  Nessuno
; Dipendenze Esterne:   Nessuna
; ==============================================================================
!macro m_Skip2 {
    !byte $0C                                               ; L'esecuzione di questa istruzione maschera l'opcode da due
                                                            ; byte che segue senza alterare i flag
}

; ==============================================================================
; MACRO: m_Delay_5n1
; ------------------------------------------------------------------------------
; Descrizione:  Consuma un numero di cicli pari a 5n+1 con un ciclo di attesa su
;               .X o .Y.
;
; Input:
;   - .reg_ (stringa, Macro) : Registro contatore: ".X" oppure ".Y"
;   - .n_ (1 byte, Macro)    : Parametro n di 5n+1 (n = 0 equivale a n = 256)
;
; Output:
;   - Nessuno
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .reg_ (.X o .Y), .P
; Dipendenze Esterne:   Nessuna
; ==============================================================================
!macro m_Delay_5n1 .reg_, .n_ {
    !if (.reg_ = ".X") {                                    ; Esegui il ciclo usando .X come contatore.
      ldx #.n_
      dex
      bne *-1
    } else if (.reg_ = ".Y") {                              ; Esegui il ciclo usando .Y come contatore.
      ldy #.n_
      dey
      bne *-1
    } else {
      !error "Illegal register usage in m_Delay_5n1"
    }
}
