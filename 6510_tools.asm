; ==============================================================================
; FILE:           6510_tools.asm
; PROGETTO:       Libreria di Sistema (system.c64)
; TARGET:         ACME Assembler / MOS 6510 (Commodore 64)
; DESCRIZIONE:    Macro per la configurazione dei banchi di memoria del 6510.
; CONTENUTO:      m_Disable_BASIC   Disabilita la ROM del BASIC
;                 m_Enable_BASIC    Riabilita la ROM del BASIC
;                 m_Disable_Kernal  Disabilita la ROM del Kernal
;                 m_Enable_Kernal   Riabilita la ROM del Kernal
;                 m_Disable_IO      Disabilita l'I/O (rende visibile CHARGEN)
;                 m_Enable_IO       Riabilita l'I/O
; DIPENDENZE:     Nessuna
; REQUISITI ZP:   Nessuno
; ==============================================================================

; ==============================================================================
; MACRO: m_Disable_BASIC
; ------------------------------------------------------------------------------
; Descrizione:  Disabilita la ROM del BASIC, rendendo visibile il banco di
;               memoria LORAM ($A000-$BFFF).
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
; Registri Modificati:  .A, .P, R6510
; Dipendenze Esterne:   <c64/symbols.asm>
; ==============================================================================
!macro m_Disable_BASIC {
    lda R6510                   ; Azzera il bit #0.
    and #%11111110
    sta R6510
}

; ==============================================================================
; MACRO: m_Enable_BASIC
; ------------------------------------------------------------------------------
; Descrizione:  Riabilita la ROM del BASIC, rendendo invisibile il banco di
;               memoria LORAM ($A000-$BFFF).
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
; Registri Modificati:  .A, .P, R6510
; Dipendenze Esterne:   <c64/symbols.asm>
; ==============================================================================
!macro m_Enable_BASIC {
    lda R6510                   ; Setta il bit #0.
    ora #%00000001
    sta R6510
}

; ==============================================================================
; MACRO: m_Disable_Kernal
; ------------------------------------------------------------------------------
; Descrizione:  Disabilita la ROM del Kernal, rendendo visibile il banco di
;               memoria HIRAM ($E000-$FFFF). ATTENZIONE: gli interrupt
;               saranno disabilitati.
;
; Input:
;   - Nessuno
;
; Output:
;   - Flag Interrupt (1 bit, .P) : sempre 1
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .P (Interrupt), R6510
; Dipendenze Esterne:   <c64/symbols.asm>
; ==============================================================================
!macro m_Disable_Kernal {
    sei                         ; Disabilita le interruzioni.

    lda R6510                   ; Azzera il bit #1.
    and #%11111101
    sta R6510
}

; ==============================================================================
; MACRO: m_Enable_Kernal
; ------------------------------------------------------------------------------
; Descrizione:  Riabilita la ROM del Kernal, rendendo invisibile il banco di
;               memoria HIRAM ($E000-$FFFF). ATTENZIONE: gli interrupt
;               saranno riabilitati.
;
; Input:
;   - Nessuno
;
; Output:
;   - Flag Interrupt (1 bit, .P) : sempre 0
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .P (Interrupt), R6510
; Dipendenze Esterne:   <c64/symbols.asm>
; ==============================================================================
!macro m_Enable_Kernal {
    lda R6510                   ; Setta il bit #1.
    ora #%00000010
    sta R6510

    cli                         ; Riabilita le interruzioni.
}

; ==============================================================================
; MACRO: m_Disable_IO
; ------------------------------------------------------------------------------
; Descrizione:  Disabilita le interruzioni del timer di sistema e gli indirizzi
;               di I/O, rendendo visibile il banco di memoria
;               CHARGEN ($D000-$DFFF).
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
; Registri Modificati:  .A, .P, R6510, CIAICR
; Dipendenze Esterne:   <c64/symbols.asm>
;                       <chip/cia.asm>
; ==============================================================================
!macro m_Disable_IO {
    lda #%01111111              ; Disabilita le interruzioni del timer di sistema.
    sta CIAICR

    lda R6510                   ; Azzera il bit #2.
    and #%11111011
    sta R6510
}

; ==============================================================================
; MACRO: m_Enable_IO
; ------------------------------------------------------------------------------
; Descrizione:  Riabilita gli indirizzi di I/O, rendendo invisibile il banco di
;               memoria CHARGEN ($D000-$DFFF), e le interruzioni del timer
;               di sistema.
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
; Registri Modificati:  .A, .P, R6510, CIAICR
; Dipendenze Esterne:   <c64/symbols.asm>
;                       <chip/cia.asm>
; ==============================================================================
!macro m_Enable_IO {
    lda R6510                   ; Setta il bit #2.
    ora #%00000100
    sta R6510

    lda #%10000001              ; Riabilita le interruzioni del timer di sistema.
    sta CIAICR
}
