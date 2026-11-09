; ==============================================================================
; FILE:           branch.asm
; PROGETTO:       Libreria di Sistema (system.c64)
; TARGET:         ACME Assembler / MOS 6510 (Commodore 64)
; DESCRIZIONE:    Macro per salti condizionati relativi e con flag di oVerflow.
; CONTENUTO:      m_Bra     Salta sempre
;                 m_Brn     Salta mai
;                 m_L_Bra   Salta lungo sempre
;                 m_L_Brn   Salta lungo mai
;                 m_Bhi     Salta se più alto (.A > M senza segno)
;                 m_Bhs     Salta se più alto o uguale (.A >= M senza segno)
;                 m_Blo     Salta se più basso (.A < M senza segno)
;                 m_Bls     Salta se più basso o uguale (.A <= M senza segno)
;                 m_Bgt     Salta se maggiore (.A > M con segno)
;                 m_Bge     Salta se maggiore o uguale (.A >= M con segno)
;                 m_Blt     Salta se minore (.A < M con segno)
;                 m_Ble     Salta se minore o uguale (.A <= M con segno)
;                 m_L_Bhi   Salta lungo se più alto (senza segno)
;                 m_L_Bhs   Salta lungo se più alto o uguale (senza segno)
;                 m_L_Blo   Salta lungo se più basso (senza segno)
;                 m_L_Bls   Salta lungo se più basso o uguale (senza segno)
;                 m_L_Bgt   Salta lungo se maggiore (con segno)
;                 m_L_Bge   Salta lungo se maggiore o uguale (con segno)
;                 m_L_Blt   Salta lungo se minore (con segno)
;                 m_L_Ble   Salta lungo se minore o uguale (con segno)
;                 m_L_Bcc   Salta lungo se Carry = 0
;                 m_L_Bcs   Salta lungo se Carry = 1
;                 m_L_Beq   Salta lungo se Zero = 1 (Equal)
;                 m_L_Bne   Salta lungo se Zero = 0 (Not Equal)
;                 m_L_Bpl   Salta lungo se Negative = 0 (Plus)
;                 m_L_Bmi   Salta lungo se Negative = 1 (Minus)
;                 m_L_Bvc   Salta lungo se oVerflow = 0 (Clear)
;                 m_L_Bvs   Salta lungo se oVerflow = 1 (Set)
; DIPENDENZE:     Nessuna
; REQUISITI ZP:   Nessuno
; ==============================================================================

; ==============================================================================
; MACRO: m_Bra
; ------------------------------------------------------------------------------
; Descrizione:  Salta sempre.
;
; Input:
;   - .addr_ (2 byte, Macro) : Indirizzo di destinazione
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
!macro m_Bra .addr_ {
    jmp .addr_
}

; ==============================================================================
; MACRO: m_Brn
; ------------------------------------------------------------------------------
; Descrizione:  Salta mai.
;
; Input:
;   - .addr_ (2 byte, Macro) : Indirizzo (ignorato)
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
!macro m_Brn .addr_ {
}

; ==============================================================================
; MACRO: m_L_Bra
; ------------------------------------------------------------------------------
; Descrizione:  Salta lungo sempre.
;
; Input:
;   - .addr_ (2 byte, Macro) : Indirizzo di destinazione
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
!macro m_L_Bra .addr_ {
    jmp .addr_
}

; ==============================================================================
; MACRO: m_L_Brn
; ------------------------------------------------------------------------------
; Descrizione:  Salta lungo mai.
;
; Input:
;   - .addr_ (2 byte, Macro) : Indirizzo (ignorato)
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
!macro m_L_Brn .addr_ {
}

; ==============================================================================
; MACRO: m_Bhi
; ------------------------------------------------------------------------------
; Descrizione:  Salta se più alto (.A > M senza segno).
;
; Input:
;   - .addr_ (2 byte, Macro) : Indirizzo di destinazione
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
!macro m_Bhi .addr_ {
    beq @No_Jump
    bcs .addr_

  @No_Jump:
}

; ==============================================================================
; MACRO: m_Bhs
; ------------------------------------------------------------------------------
; Descrizione:  Salta se più alto o uguale (.A >= M senza segno).
;
; Input:
;   - .addr_ (2 byte, Macro) : Indirizzo di destinazione
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
!macro m_Bhs .addr_ {
    bcs .addr_
}

; ==============================================================================
; MACRO: m_Blo
; ------------------------------------------------------------------------------
; Descrizione:  Salta se più basso (.A < M senza segno).
;
; Input:
;   - .addr_ (2 byte, Macro) : Indirizzo di destinazione
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
!macro m_Blo .addr_ {
    bcc .addr_
}

; ==============================================================================
; MACRO: m_Bls
; ------------------------------------------------------------------------------
; Descrizione:  Salta se più basso o uguale (.A <= M senza segno).
;
; Input:
;   - .addr_ (2 byte, Macro) : Indirizzo di destinazione
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
!macro m_Bls .addr_ {
    bcc .addr_
    beq .addr_
}

; ==============================================================================
; MACRO: m_Bgt
; ------------------------------------------------------------------------------
; Descrizione:  Salta se maggiore (.A > M con segno).
;
; Input:
;   - .addr_ (2 byte, Macro) : Indirizzo di destinazione
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
!macro m_Bgt .addr_ {
    beq @No_Jump
    bmi @Jump_If_V_Set
    bvc .addr_
    bvs @No_Jump

  @Jump_If_V_Set:
    bvs .addr_

  @No_Jump:
}

; ==============================================================================
; MACRO: m_Bge
; ------------------------------------------------------------------------------
; Descrizione:  Salta se maggiore o uguale (.A >= M con segno).
;
; Input:
;   - .addr_ (2 byte, Macro) : Indirizzo di destinazione
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
!macro m_Bge .addr_ {
    bmi @Jump_If_V_Set
    bvc .addr_
    bvs @No_Jump

  @Jump_If_V_Set:
    bvs .addr_

  @No_Jump:
}

; ==============================================================================
; MACRO: m_Blt
; ------------------------------------------------------------------------------
; Descrizione:  Salta se minore (.A < M con segno).
;
; Input:
;   - .addr_ (2 byte, Macro) : Indirizzo di destinazione
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
!macro m_Blt .addr_ {
    bpl @Jump_If_V_Set
    bvc .addr_
    bvs @No_Jump

  @Jump_If_V_Set:
    bvs .addr_

  @No_Jump:
}

; ==============================================================================
; MACRO: m_Ble
; ------------------------------------------------------------------------------
; Descrizione:  Salta se minore o uguale (.A <= M con segno).
;
; Input:
;   - .addr_ (2 byte, Macro) : Indirizzo di destinazione
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
!macro m_Ble .addr_ {
    beq .addr_
    bpl @Jump_If_V_Set
    bvc .addr_
    bvs @No_Jump

  @Jump_If_V_Set:
    bvs .addr_

  @No_Jump:
}

; ==============================================================================
; MACRO: m_L_Bhi
; ------------------------------------------------------------------------------
; Descrizione:  Salta lungo se più alto (senza segno).
;
; Input:
;   - .addr_ (2 byte, Macro) : Indirizzo di destinazione
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
!macro m_L_Bhi .addr_ {
    +m_Bls @Skip_Jump
    jmp .addr_

  @Skip_Jump:
}

; ==============================================================================
; MACRO: m_L_Bhs
; ------------------------------------------------------------------------------
; Descrizione:  Salta lungo se più alto o uguale (senza segno).
;
; Input:
;   - .addr_ (2 byte, Macro) : Indirizzo di destinazione
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
!macro m_L_Bhs .addr_ {
    +m_Blo @Skip_Jump
    jmp .addr_

  @Skip_Jump:
}

; ==============================================================================
; MACRO: m_L_Blo
; ------------------------------------------------------------------------------
; Descrizione:  Salta lungo se più basso (senza segno).
;
; Input:
;   - .addr_ (2 byte, Macro) : Indirizzo di destinazione
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
!macro m_L_Blo .addr_ {
    +m_Bhs @Skip_Jump
    jmp .addr_

  @Skip_Jump:
}

; ==============================================================================
; MACRO: m_L_Bls
; ------------------------------------------------------------------------------
; Descrizione:  Salta lungo se più basso o uguale (senza segno).
;
; Input:
;   - .addr_ (2 byte, Macro) : Indirizzo di destinazione
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
!macro m_L_Bls .addr_ {
    +m_Bhi @Skip_Jump
    jmp .addr_

  @Skip_Jump:
}

; ==============================================================================
; MACRO: m_L_Bgt
; ------------------------------------------------------------------------------
; Descrizione:  Salta lungo se maggiore (con segno).
;
; Input:
;   - .addr_ (2 byte, Macro) : Indirizzo di destinazione
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
!macro m_L_Bgt .addr_ {
    +m_Ble @Skip_Jump
    jmp .addr_

  @Skip_Jump:
}

; ==============================================================================
; MACRO: m_L_Bge
; ------------------------------------------------------------------------------
; Descrizione:  Salta lungo se maggiore o uguale (con segno).
;
; Input:
;   - .addr_ (2 byte, Macro) : Indirizzo di destinazione
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
!macro m_L_Bge .addr_ {
    +m_Blt @Skip_Jump
    jmp .addr_

  @Skip_Jump:
}

; ==============================================================================
; MACRO: m_L_Blt
; ------------------------------------------------------------------------------
; Descrizione:  Salta lungo se minore (con segno).
;
; Input:
;   - .addr_ (2 byte, Macro) : Indirizzo di destinazione
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
!macro m_L_Blt .addr_ {
    +m_Bge @Skip_Jump
    jmp .addr_

  @Skip_Jump:
}

; ==============================================================================
; MACRO: m_L_Ble
; ------------------------------------------------------------------------------
; Descrizione:  Salta lungo se minore o uguale (con segno).
;
; Input:
;   - .addr_ (2 byte, Macro) : Indirizzo di destinazione
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
!macro m_L_Ble .addr_ {
    +m_Bgt @Skip_Jump
    jmp .addr_

  @Skip_Jump:
}

; ==============================================================================
; MACRO: m_L_Bcc
; ------------------------------------------------------------------------------
; Descrizione:  Salta lungo se Carry = 0.
;
; Input:
;   - .addr_ (2 byte, Macro) : Indirizzo di destinazione
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
!macro m_L_Bcc .addr_ {
    bcs @No_Jump
    jmp .addr_

  @No_Jump:
}

; ==============================================================================
; MACRO: m_L_Bcs
; ------------------------------------------------------------------------------
; Descrizione:  Salta lungo se Carry = 1.
;
; Input:
;   - .addr_ (2 byte, Macro) : Indirizzo di destinazione
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
!macro m_L_Bcs .addr_ {
    bcc @No_Jump
    jmp .addr_

  @No_Jump:
}

; ==============================================================================
; MACRO: m_L_Beq
; ------------------------------------------------------------------------------
; Descrizione:  Salta lungo se Zero = 1 (Equal).
;
; Input:
;   - .addr_ (2 byte, Macro) : Indirizzo di destinazione
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
!macro m_L_Beq .addr_ {
    bne @No_Jump
    jmp .addr_

  @No_Jump:
}

; ==============================================================================
; MACRO: m_L_Bne
; ------------------------------------------------------------------------------
; Descrizione:  Salta lungo se Zero = 0 (Not Equal).
;
; Input:
;   - .addr_ (2 byte, Macro) : Indirizzo di destinazione
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
!macro m_L_Bne .addr_ {
    beq @No_Jump
    jmp .addr_

  @No_Jump:
}

; ==============================================================================
; MACRO: m_L_Bpl
; ------------------------------------------------------------------------------
; Descrizione:  Salta lungo se Negative = 0 (Plus).
;
; Input:
;   - .addr_ (2 byte, Macro) : Indirizzo di destinazione
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
!macro m_L_Bpl .addr_ {
    bmi @No_Jump
    jmp .addr_

  @No_Jump:
}

; ==============================================================================
; MACRO: m_L_Bmi
; ------------------------------------------------------------------------------
; Descrizione:  Salta lungo se Negative = 1 (Minus).
;
; Input:
;   - .addr_ (2 byte, Macro) : Indirizzo di destinazione
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
!macro m_L_Bmi .addr_ {
    bpl @No_Jump
    jmp .addr_

  @No_Jump:
}

; ==============================================================================
; MACRO: m_L_Bvc
; ------------------------------------------------------------------------------
; Descrizione:  Salta lungo se oVerflow = 0 (Clear).
;
; Input:
;   - .addr_ (2 byte, Macro) : Indirizzo di destinazione
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
!macro m_L_Bvc .addr_ {
    bvs @No_Jump
    jmp .addr_

  @No_Jump:
}

; ==============================================================================
; MACRO: m_L_Bvs
; ------------------------------------------------------------------------------
; Descrizione:  Salta lungo se oVerflow = 1 (Set).
;
; Input:
;   - .addr_ (2 byte, Macro) : Indirizzo di destinazione
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
!macro m_L_Bvs .addr_ {
    bvc @No_Jump
    jmp .addr_

  @No_Jump:
}
