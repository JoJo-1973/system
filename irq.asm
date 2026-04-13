; Macro per impostare IRQ (in genere raster)

; Titolo:                 MACRO: Prepara il sistema all'esecuzione di una catena di IRQ raster
; Nome:                   Init_Raster
; Descrizione:            Disabilita tutte le sorgenti di interruzioni legate ai chip CIA
;                         ed attiva UNICAMENTE le interruzioni dovute al raster.
;                         Dato che tutte le altre interruzioni sono disabilitate, la gestione della tastiera
;                         e dell'I/O seriale sono demandate alla responsabilità del programmatore.
; Parametri di ingresso:  ---
; Parametri di uscita:    ---
; Alterazioni registri:   .A
; Alterazioni pag. zero:  ---
; Dipendenze esterne:     vic.asm, cia.asm
!macro Init_Raster {
  lda #%01111111                ; Disabilita tutte le sorgenti di interruzioni provenienti dai chip CIA
  sta CIAICR                    ; ATTENZIONE: disabilitare le interruzioni del CIA #1 implica che
  sta CI2ICR                    ; la scansione della tastiera sarà responsabilità del programmatore!!!

  lda CIAICR                    ; Esegui eventuali IRQ in sospeso richiesti da CIA #1
  lda CI2ICR                    ; Esegui eventuali IRQ in sospeso richiesti da CIA #2

  lda #%00000001                ; Imposta il raster come unica sorgente di interruzioni
  sta IRQMSK
}

; Titolo:                 MACRO: Imposta il registro di confronto della rasterline
; Nome:                   Set_Rasterline
; Descrizione:            Imposta il valore del registro di confronto della rasterline al valore desiderato, tenendo conto
;                         che il valore è a 9 bit suddivisi tra il registro RASTER e il registro SCROLY.
; Parametri di ingresso:  line: Numero della rasterline
; Parametri di uscita:    ---
; Alterazioni registri:   .A
; Alterazioni pag. zero:  ---
; Dipendenze esterne:     vic.asm, cia.asm
!macro Set_Rasterline line {
  lda #<line                    ; I primi 8 bit della posizione della linea vanno qui
  sta RASTER

  lda SCROLY
  !if line > 255 {
    ora #%10000000              ; Se la linea è > 255 allora setta il bit #7
  } else {
    and #%01111111              ; altrimenti resettalo
  }
  sta SCROLY
}

!macro Set_Raster_IRQ line, handler {
  sei                           ; Disabilita le interruzioni

  lda #<handler                 ; Setta l'indirizzo del gestore dell'interruzione
  sta CINV
  lda #>handler
  sta CINV+1

  +Set_Rasterline line          ; Imposta il registro di confronto della rasterline

  inc VICIRQ                    ; Reimposta il flag di riconoscimento IRQ raster che è stato resettato
                                ; nel momento che il gestore è stato eseguito

  cli                           ; Riabilita le interruzioni
}
