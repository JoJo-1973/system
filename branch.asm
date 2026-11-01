; ==============================================================================
; FILE:           branch.asm
; PROGETTO:       Libreria di Sistema (system.c64)
; TARGET:         ACME Assembler / MOS 6510 (Commodore 64)
; DESCRIZIONE:    Macro per salti condizionati relativi e con flag di overflow.
; DIPENDENZE:     Nessuna
; REQUISITI ZP:   Nessuno
; ==============================================================================

; ==============================================================================
; MACRO: m_Bra
; ------------------------------------------------------------------------------
; Descrizione: Salta sempre sfruttando il flag V.
; Input:
;   - .addr_ : Indirizzo di destinazione
; Output:
;   - Nessuno
; Variazione Stack (.S):
;   - Stabile (0 byte)
; Registri Modificati: .P (oVerflow)
; Dipendenze Esterne:  Nessuna
; ==============================================================================
!macro m_Bra .addr_ {
    clv
    bvc .addr_
}

; ==============================================================================
; MACRO: m_Brn
; ------------------------------------------------------------------------------
; Descrizione: Salta mai (spreca cicli per allineamento/chiarezza).
; Input:
;   - .addr_ : Indirizzo (ignorato)
; Output:
;   - Nessuno
; Variazione Stack (.S):
;   - Stabile (0 byte)
; Registri Modificati: Nessuno
; Dipendenze Esterne:  Nessuna
; ==============================================================================
!macro m_Brn .addr_ {
    nop
    nop
}

; ==============================================================================
; MACRO: m_L_Bra
; ------------------------------------------------------------------------------
; Descrizione: Salta lungo sempre (jmp).
; Input:
;   - .addr_ : Indirizzo di destinazione
; Output:
;   - Nessuno
; Variazione Stack (.S):
;   - Stabile (0 byte)
; Registri Modificati: Nessuno
; Dipendenze Esterne:  Nessuna
; ==============================================================================
!macro m_L_Bra .addr_ {
    jmp .addr_
}

; ==============================================================================
; MACRO: m_L_Brn
; ------------------------------------------------------------------------------
; Descrizione: Salta lungo mai (nop).
; Input:
;   - .addr_ : Indirizzo (ignorato)
; Output:
;   - Nessuno
; Variazione Stack (.S):
;   - Stabile (0 byte)
; Registri Modificati: Nessuno
; Dipendenze Esterne:  Nessuna
; ==============================================================================
!macro m_L_Brn .addr_ {
    nop
    nop
}

; ==============================================================================
; MACRO: m_Bhi
; ------------------------------------------------------------------------------
; Descrizione: Salta se più alto (.A > M senza segno).
; Input:
;   - .addr_ : Indirizzo di destinazione
; Output:
;   - Nessuno
; Variazione Stack (.S):
;   - Stabile (0 byte)
; Registri Modificati: Nessuno
; Dipendenze Esterne:  Nessuna
; ==============================================================================
!macro m_Bhi .addr_ {
    beq @False
    bcs .addr_

  @False:
}

; ==============================================================================
; MACRO: m_Bhs
; ------------------------------------------------------------------------------
; Descrizione: Salta se più alto o uguale (.A >= M senza segno).
; Input:
;   - .addr_ : Indirizzo di destinazione
; Output:
;   - Nessuno
; Variazione Stack (.S):
;   - Stabile (0 byte)
; Registri Modificati: Nessuno
; Dipendenze Esterne:  Nessuna
; ==============================================================================
!macro m_Bhs .addr_ {
    bcs .addr_
}

; ==============================================================================
; MACRO: m_Blo
; ------------------------------------------------------------------------------
; Descrizione: Salta se più basso (.A < M senza segno).
; Input:
;   - .addr_ : Indirizzo di destinazione
; Output:
;   - Nessuno
; Variazione Stack (.S):
;   - Stabile (0 byte)
; Registri Modificati: Nessuno
; Dipendenze Esterne:  Nessuna
; ==============================================================================
!macro m_Blo .addr_ {
    bcc .addr_
}

; ==============================================================================
; MACRO: m_Bls
; ------------------------------------------------------------------------------
; Descrizione: Salta se più basso o uguale (.A <= M senza segno).
; Input:
;   - .addr_ : Indirizzo di destinazione
; Output:
;   - Nessuno
; Variazione Stack (.S):
;   - Stabile (0 byte)
; Registri Modificati: Nessuno
; Dipendenze Esterne:  Nessuna
; ==============================================================================
!macro m_Bls .addr_ {
    bcc .addr_
    beq .addr_
}

; ==============================================================================
; MACRO: m_Bgt
; ------------------------------------------------------------------------------
; Descrizione: Salta se maggiore (.A > M con segno).
; Input:
;   - .addr_ : Indirizzo di destinazione
; Output:
;   - Nessuno
; Variazione Stack (.S):
;   - Stabile (0 byte)
; Registri Modificati: Nessuno
; Dipendenze Esterne:  Nessuna
; ==============================================================================
!macro m_Bgt .addr_ {
    beq @False
    bmi @Check_V
    bvc .addr_
    bvs @False

  @Check_V:
      bvs .addr_

  @False:
}

; ==============================================================================
; MACRO: m_Bge
; ------------------------------------------------------------------------------
; Descrizione: Salta se maggiore o uguale (.A >= M con segno).
; Input:
;   - .addr_ : Indirizzo di destinazione
; Output:
;   - Nessuno
; Variazione Stack (.S):
;   - Stabile (0 byte)
; Registri Modificati: Nessuno
; Dipendenze Esterne:  Nessuna
; ==============================================================================
!macro m_Bge .addr_ {
    bmi @Check_V
    bvc .addr_
    bvs @False

  @Check_V:
    bvs .addr_

  @False:
}

; ==============================================================================
; MACRO: m_Blt
; ------------------------------------------------------------------------------
; Descrizione: Salta se minore (.A < M con segno).
; Input:
;   - .addr_ : Indirizzo di destinazione
; Output:
;   - Nessuno
; Variazione Stack (.S):
;   - Stabile (0 byte)
; Registri Modificati: Nessuno
; Dipendenze Esterne:  Nessuna
; ==============================================================================
!macro m_Blt .addr_ {
    bpl @Check_V
    bvc .addr_
    bvs @False

  @Check_V:
    bvs .addr_

  @False:
}

; ==============================================================================
; MACRO: m_Ble
; ------------------------------------------------------------------------------
; Descrizione: Salta se minore o uguale (.A <= M con segno).
; Input:
;   - .addr_ : Indirizzo di destinazione
; Output:
;   - Nessuno
; Variazione Stack (.S):
;   - Stabile (0 byte)
; Registri Modificati: Nessuno
; Dipendenze Esterne:  Nessuna
; ==============================================================================
!macro m_Ble .addr_ {
    beq .addr_
    bpl @Check_V
    bvc .addr_
    bvs @False

  @Check_V:
    bvs .addr_

  @False:
}

; ==============================================================================
; MACRO: m_L_Bhi
; ------------------------------------------------------------------------------
; Descrizione: Salta lungo se più alto (senza segno).
; Input:
;   - .addr_ : Indirizzo di destinazione
; Output:
;   - Nessuno
; Variazione Stack (.S):
;   - Stabile (0 byte)
; Registri Modificati: Nessuno
; Dipendenze Esterne:  Nessuna
; ==============================================================================
!macro m_L_Bhi .addr_ {
    +m_Bls @True_Bhi
    jmp .addr_

  @True_Bhi:
}

; ==============================================================================
; MACRO: m_L_Bhs
; ------------------------------------------------------------------------------
; Descrizione: Salta lungo se più alto o uguale (senza segno).
; Input:
;   - .addr_ : Indirizzo di destinazione
; Output:
;   - Nessuno
; Variazione Stack (.S):
;   - Stabile (0 byte)
; Registri Modificati: Nessuno
; Dipendenze Esterne:  Nessuna
; ==============================================================================
!macro m_L_Bhs .addr_ {
    +m_Blo @True_Blo
    jmp .addr_

  @True_Blo:
}

; ==============================================================================
; MACRO: m_L_Blo
; ------------------------------------------------------------------------------
; Descrizione: Salta lungo se più basso (senza segno).
; Input:
;   - .addr_ : Indirizzo di destinazione
; Output:
;   - Nessuno
; Variazione Stack (.S):
;   - Stabile (0 byte)
; Registri Modificati: Nessuno
; Dipendenze Esterne:  Nessuna
; ==============================================================================
!macro m_L_Blo .addr_ {
    +m_Bhs @True_Bhs
    jmp .addr_

  @True_Bhs:
}

; ==============================================================================
; MACRO: m_L_Bls
; ------------------------------------------------------------------------------
; Descrizione: Salta lungo se più basso o uguale (senza segno).
; Input:
;   - .addr_ : Indirizzo di destinazione
; Output:
;   - Nessuno
; Variazione Stack (.S):
;   - Stabile (0 byte)
; Registri Modificati: Nessuno
; Dipendenze Esterne:  Nessuna
; ==============================================================================
!macro m_L_Bls .addr_ {
    +m_Bhi @True_Bhi
    jmp .addr_

  @True_Bhi:
}

; ==============================================================================
; MACRO: m_L_Bgt
; ------------------------------------------------------------------------------
; Descrizione: Salta lungo se maggiore (con segno).
; Input:
;   - .addr_ : Indirizzo di destinazione
; Output:
;   - Nessuno
; Variazione Stack (.S):
;   - Stabile (0 byte)
; Registri Modificati: Nessuno
; Dipendenze Esterne:  Nessuna
; ==============================================================================
!macro m_L_Bgt .addr_ {
    +m_Ble @True_Ble
    jmp .addr_

  @True_Ble:
}

; ==============================================================================
; MACRO: m_L_Bge
; ------------------------------------------------------------------------------
; Descrizione: Salta lungo se maggiore o uguale (con segno).
; Input:
;   - .addr_ : Indirizzo di destinazione
; Output:
;   - Nessuno
; Variazione Stack (.S):
;   - Stabile (0 byte)
; Registri Modificati: Nessuno
; Dipendenze Esterne:  Nessuna
; ==============================================================================
!macro m_L_Bge .addr_ {
    +m_Blt @True_Blt
    jmp .addr_

  @True_Blt:
}

; ==============================================================================
; MACRO: m_L_Blt
; ------------------------------------------------------------------------------
; Descrizione: Salta lungo se minore (con segno).
; Input:
;   - .addr_ : Indirizzo di destinazione
; Output:
;   - Nessuno
; Variazione Stack (.S):
;   - Stabile (0 byte)
; Registri Modificati: Nessuno
; Dipendenze Esterne:  Nessuna
; ==============================================================================
!macro m_L_Blt .addr_ {
    +m_Bge @True_Bge
    jmp .addr_

  @True_Bge:
}

; ==============================================================================
; MACRO: m_L_Ble
; ------------------------------------------------------------------------------
; Descrizione: Salta lungo se minore o uguale (con segno).
; Input:
;   - .addr_ : Indirizzo di destinazione
; Output:
;   - Nessuno
; Variazione Stack (.S):
;   - Stabile (0 byte)
; Registri Modificati: Nessuno
; Dipendenze Esterne:  Nessuna
; ==============================================================================
!macro m_L_Ble .addr_ {
    +m_Bgt @True_Bgt
    jmp .addr_

  @True_Bgt:
}

; ==============================================================================
; MACRO: m_L_Bcc
; ------------------------------------------------------------------------------
; Descrizione: Salta lungo se Carry = 0.
; Input:
;   - .addr_ : Indirizzo di destinazione
; Output:
;   - Nessuno
; Variazione Stack (.S):
;   - Stabile (0 byte)
; Registri Modificati: Nessuno
; Dipendenze Esterne:  Nessuna
; ==============================================================================
!macro m_L_Bcc .addr_ {
    bcs @False
    jmp .addr_

  @False:
}

; ==============================================================================
; MACRO: m_L_Bcs
; ------------------------------------------------------------------------------
; Descrizione: Salta lungo se Carry = 1.
; Input:
;   - .addr_ : Indirizzo di destinazione
; Output:
;   - Nessuno
; Variazione Stack (.S):
;   - Stabile (0 byte)
; Registri Modificati: Nessuno
; Dipendenze Esterne:  Nessuna
; ==============================================================================
!macro m_L_Bcs .addr_ {
    bcc @False
    jmp .addr_

  @False:
}

; ==============================================================================
; MACRO: m_L_Beq
; ------------------------------------------------------------------------------
; Descrizione: Salta lungo se Zero = 1 (Equal).
; Input:
;   - .addr_ : Indirizzo di destinazione
; Output:
;   - Nessuno
; Variazione Stack (.S):
;   - Stabile (0 byte)
; Registri Modificati: Nessuno
; Dipendenze Esterne:  Nessuna
; ==============================================================================
!macro m_L_Beq .addr_ {
    bne @False
    jmp .addr_

  @False:
}

; ==============================================================================
; MACRO: m_L_Bne
; ------------------------------------------------------------------------------
; Descrizione: Salta lungo se Zero = 0 (Not Equal).
; Input:
;   - .addr_ : Indirizzo di destinazione
; Output:
;   - Nessuno
; Variazione Stack (.S):
;   - Stabile (0 byte)
; Registri Modificati: Nessuno
; Dipendenze Esterne:  Nessuna
; ==============================================================================
!macro m_L_Bne .addr_ {
    beq @False
    jmp .addr_

  @False:
}

; ==============================================================================
; MACRO: m_L_Bpl
; ------------------------------------------------------------------------------
; Descrizione: Salta lungo se Negative = 0 (Plus).
; Input:
;   - .addr_ : Indirizzo di destinazione
; Output:
;   - Nessuno
; Variazione Stack (.S):
;   - Stabile (0 byte)
; Registri Modificati: Nessuno
; Dipendenze Esterne:  Nessuna
; ==============================================================================
!macro m_L_Bpl .addr_ {
    bmi @False
    jmp .addr_

  @False:
}

; ==============================================================================
; MACRO: m_L_Bmi
; ------------------------------------------------------------------------------
; Descrizione: Salta lungo se Negative = 1 (Minus).
; Input:
;   - .addr_ : Indirizzo di destinazione
; Output:
;   - Nessuno
; Variazione Stack (.S):
;   - Stabile (0 byte)
; Registri Modificati: Nessuno
; Dipendenze Esterne:  Nessuna
; ==============================================================================
!macro m_L_Bmi .addr_ {
    bpl @False
    jmp .addr_

  @False:
}

; ==============================================================================
; MACRO: m_L_Bvc
; ------------------------------------------------------------------------------
; Descrizione: Salta lungo se oVerflow = 0 (Clear).
; Input:
;   - .addr_ : Indirizzo di destinazione
; Output:
;   - Nessuno
; Variazione Stack (.S):
;   - Stabile (0 byte)
; Registri Modificati: Nessuno
; Dipendenze Esterne:  Nessuna
; ==============================================================================
!macro m_L_Bvc .addr_ {
    bvs @False
    jmp .addr_

  @False:
}

; ==============================================================================
; MACRO: m_L_Bvs
; ------------------------------------------------------------------------------
; Descrizione: Salta lungo se oVerflow = 1 (Set).
; Input:
;   - .addr_ : Indirizzo di destinazione
; Output:
;   - Nessuno
; Variazione Stack (.S):
;   - Stabile (0 byte)
; Registri Modificati: Nessuno
; Dipendenze Esterne:  Nessuna
; ==============================================================================
!macro m_L_Bvs .addr_ {
    bvc @False
    jmp .addr_

  @False:
}
