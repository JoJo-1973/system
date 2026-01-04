; Macro per la configurazione dei banchi di memoria del 6510

; Titolo:                 MACRO: Disabilita il BASIC
; Nome:                   Disable_BASIC
; Scopo:                  Disabilita la ROM del BASIC rendendo visibile il banco di memoria LORAM ($A000-$BFFF).
; Parametri di ingresso:  ---
; Parametri di uscita:    ---
; Registri alterati:      .A
; Puntatori zp alterati:  ---
; Temporanei alterati:    ---
; Dipendenze esterne:     symbols.asm
!macro Disable_BASIC {
  lda R6510                     ; Azzera il bit #0.
  and #%11111110
  sta R6510
}

; Titolo:                 MACRO: Riabilita il BASIC
; Nome:                   Enable_BASIC
; Scopo:                  Riabilita la ROM del BASIC rendendo invisibile il banco di memoria LORAM ($A000-$BFFF).
; Parametri di ingresso:  ---
; Parametri di uscita:    ---
; Registri alterati:      .A
; Puntatori zp alterati:  ---
; Temporanei alterati:    ---
; Dipendenze esterne:     symbols.asm
!macro Enable_BASIC {
  lda R6510                     ; Setta il bit #0.
  ora #%00000001
  sta R6510
}

; Titolo:                 MACRO: Disabilita il Kernal
; Nome:                   Disable_Kernal
; Scopo:                  Disabilita la ROM del Kernal rendendo visibile il banco di memoria HIRAM ($E000-$FFFF).
;                         ATTENZIONE: gli interrupt saranno disabilitati.
; Parametri di ingresso:  ---
; Parametri di uscita:    ---
; Registri alterati:      .A
; Puntatori zp alterati:  ---
; Temporanei alterati:    ---
; Dipendenze esterne:     symbols.asm
!macro Disable_Kernal {
  sei                           ; Disabilita le interruzioni.

  lda R6510                     ; Azzera il bit #1.
  and #%11111101
  sta R6510
}

; Titolo:                 MACRO: Riabilita il Kernal
; Nome:                   Enable_Kernal
; Scopo:                  Riabilita la ROM del Kernal rendendo invisibile il banco di memoria HIRAM ($E000-$FFFF).
;                         ATTENZIONE: gli interrupt saranno riabilitati.
; Parametri di ingresso:  ---
; Parametri di uscita:    ---
; Registri alterati:      .A
; Puntatori zp alterati:  ---
; Temporanei alterati:    ---
; Dipendenze esterne:     symbols.asm
!macro Enable_Kernal {
  lda R6510                     ; Setta il bit #1.
  ora #%00000010
  sta R6510

  cli                           ; Riabilita le interruzioni.
}

; Titolo:                 MACRO: Disabilita l'I/O
; Nome:                   Disable_IO
; Scopo:                  Disabilita gli indirizzi di I/O rendendo visibile il banco di memoria CHARGEN ($D000-$DFFF).
; Parametri di ingresso:  ---
; Parametri di uscita:    ---
; Registri alterati:      .A
; Puntatori zp alterati:  Definito dall'utente
; Temporanei alterati:    ---
; Dipendenze esterne:     symbols.asm, cia.asm
!macro Disable_IO {
  lda #%01111111                ; Disabilita le interruzioni del timer di sistema.
  sta CIAICR

  lda R6510                     ; Azzera il bit #2.
  and #%11111011
  sta R6510
}

; Titolo:                 MACRO: Riabilita l'I/O
; Nome:                   Enable_IO
; Scopo:                  Riabilita gli indirizzi di I/O rendendo invisibile il banco di memoria CHARGEN ($D000-$DFFF).
; Parametri di ingresso:  ---
; Parametri di uscita:    ---
; Registri alterati:      .A
; Puntatori zp alterati:  ---
; Temporanei alterati:    ---
; Dipendenze esterne:     symbols.asm, cia.asm
!macro Enable_IO {
  lda R6510                     ; Setta il bit #2.
  ora #%00000100
  sta R6510

  lda #%10000001                ; Riabilita le interruzioni del timer di sistema.
  sta CIAICR
}
