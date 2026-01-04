; Titolo:                 ROUTINE: Resetta HIBASE dopo RUN/STOP + RESTORE
; Nome:                   NMI_HIBASE
; Scopo:                  Dopo un RUN/STOP + RESTORE il VIC viene riconfigurato con i valori di default
;                         salvo che la variabile di sistema HIBASE non viene reinizializzata; questa
;                         routine risolve il problema inserendosi nella routine di interrupt NMI.
; Parametri di ingresso:  ---
; Parametri di uscita:    ---
; Registri alterati:      .A
; Puntatori zp alterati:  ---
; Temporanei alterati:    ---
; Dipendenze esterne:     symbols.asm
!zone NMI_HiBase
NMI_HIBASE:
  lda #<.New_NMI_Handler        ; Imposta il nuovo gestore delle interruzioni non mascherabili.
  sta NMIVEC
  lda #>.New_NMI_Handler
  sta NMIVEC+1

.Exit_NMI_HIBASE:
  rts

.New_NMI_Handler:
  pha                           ; Salva l'accumulatore sullo stack.
  lda #>VICSCN                  ; Resetta il byte alto dell'indirizzo base dello schermo a 1024.
  sta HIBASE
  pla                           ; Recupera l'accumulatore dallo stack.
  jmp NMIHND                    ; Esegui il normale gestore delle interruzioni non mascherabili.
!zone

; Titolo:                 ROUTINE: Ripristina il vettore NMI originale
; Nome:                   NMI_Restore
; Scopo:                  Questa routine ripristina il vettore NMI originale annullando le modifiche apportate da NMI_HIBASE.
; Parametri di ingresso:  ---
; Parametri di uscita:    ---
; Registri alterati:      .A
; Puntatori zp alterati:  ---
; Temporanei alterati:    ---
; Dipendenze esterne:     symbols.asm
!zone NMI_Restore
NMI_RESTORE:
  lda #<NMIHND
  sta NMIVEC
  lda #>NMIHND
  sta NMIVEC+1

.Exit_NMI_RESTORE:
  rts
!zone