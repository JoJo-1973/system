; Macro per la configurazione dei banchi di memoria del 6510

; Titolo:                 Disabilita il BASIC
; Nome:                   Disable_BASIC
; Scopo:                  Rendi visibile il banco di memoria LORAM ($A000-$BFFF), disabilitando il BASIC
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

; Titolo:                 Riabilita il BASIC
; Nome:                   Enable_BASIC
; Scopo:                  Maschera il banco di memoria LORAM ($A000-$BFFF), riabilitando il BASIC
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

; Titolo:                 Disabilita il Kernal
; Nome:                   Disable_Kernal
; Scopo:                  Rendi visibile il banco di memoria HIRAM ($E000-$FFFF), disabilitando il Kernal
;                         ATTENZIONE: gli interrupt saranno disabilitati
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

; Titolo:                 Riabilita il Kernal
; Nome:                   Enable_Kernal
; Scopo:                  Maschera il banco di memoria HIRAM ($E000-$FFFF), riabilitando il Kernal
;                         ATTENZIONE: gli interrupt saranno riabilitati
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

; Titolo:                 Maschera il generatore di caratteri
; Nome:                   Disable_CharGen
; Scopo:                  Maschera il banco di memoria CHARGEN ($D000-$DFFF), riabilitando l'I/O
; Parametri di ingresso:  ---
; Parametri di uscita:    ---
; Registri alterati:      .A
; Puntatori zp alterati:  ---
; Temporanei alterati:    ---
; Dipendenze esterne:     symbols.asm, cia.asm
!macro Disable_CharGen {
  lda R6510                     ; Setta il bit #2.
  ora #%00000100
  sta R6510

  lda #%10000001                ; Riabilita le interruzioni del timer di sistema.
  sta CIAICR
}

; Titolo:                 Rendi visibile il generatore di caratteri
; Nome:                   Enable_CharGen
; Scopo:                  Rendi visibile il banco di memoria CHARGEN ($D000-$DFFF), disabilitando l'I/O
; Parametri di ingresso:  ---
; Parametri di uscita:    ---
; Registri alterati:      .A
; Puntatori zp alterati:  Definito dall'utente
; Temporanei alterati:    ---
; Dipendenze esterne:     symbols.asm, cia.asm
!macro Enable_CharGen {
  lda #%01111111                ; Disabilita le interruzioni del timer di sistema.
  sta CIAICR

  lda R6510                     ; Azzera il bit #2.
  and #%11111011
  sta R6510
}
