; Macro per impostare IRQ (in genere raster)

; Titolo:                 MACRO: Prepara il sistema all'esecuzione di una catena di IRQ raster
; Nome:                   Init_Raster_System
; Descrizione:            Disabilita tutte le sorgenti di interruzioni legate ai chip CIA
;                         ed attiva UNICAMENTE le interruzioni dovute al raster.
;                         Dato che tutte le altre interruzioni sono disabilitate, la gestione della tastiera
;                         e dell'I/O seriale sono demandate alla responsabilità del programmatore.
; Parametri di ingresso:  ---
; Parametri di uscita:    ---
; Alterazioni registri:   .A
; Alterazioni pag. zero:  ---
; Dipendenze esterne:     chip/vic_ii.asm, chip/cia.asm
!macro Init_Raster_System .flag {
  !zone Init_Raster_System

  !if .flag > 255 {
    !error "ERROR: __VIC_MODEL must be in zero-page."
  } else {
    !set __VIC_MODEL = .flag
  }

  .Loop_Wait_Top:
    bit SCROLY                  ; Gira a vuoto finché il raster non ritorna nell'intervallo 0-255.
    bmi .Loop_Wait_Top

    sei                         ; Disabilita le interruzioni.

  .Loop_Wait_Line_261:
    bit SCROLY                  ; A questo punto gira a vuoto finché il raster non entra nell'intervallo 256-???.
    bpl .Loop_Wait_Line_261

    lda #<261                   ; Ora si può continuare a girare a vuoto finché non si è raggiunta
                                ; la linea 261 = 256 + 5, che è l'ultima linea comune a tutte le versioni
  .Loop_Spin_261:               ; esistenti del VIC_II (Old NTSC = 0-261, New NTSC = 0-262, PAL = 0-311).
    cmp RASTER
    bne .Loop_Spin_261

  .Check_Line_262:
    ldx #$13                    ; Non appena entrati nella linea 261, facciamo passare 96 cicli in modo da
                                ; essere sicuri di essere ben entrati nella linea successiva.
  .Loop_Delay_1:
    dex
    bne .Loop_Delay_1

    bit SCROLY                  ; Se il contatore è ancora maggiore di 256 vuol dire che siamo ancora
    bmi .Check_Line_263         ; al fondo dello schermo, e l'identificazione non è ancora completa.

  .Old_NTSC:
    ldy #%01000000              ; Altrimenti siamo ritornati all'inizio dello schermo e siamo sicuri
    bne .Exit                   ; di aver identificato la versione "Old NTSC".

  .Check_Line_263:
    ldx #$13                    ; Facciamo passare altri 96 cicli e ripetiamo il test:

  .Loop_Delay_2:
    dex
    bne .Loop_Delay_2

    bit SCROLY                  ; Se il contatore è ancora maggiore di 256 allora non ci sono dubbi:
    bmi .PAL                    ; il chip VIC-II è in versione "PAL",

  .New_NTSC:
    ldy #%11000000              ; altrimenti non può che essere in versione "New NTSC".
    bne .Exit

  .PAL:
    ldy #%00000000

  .Exit:
    sty __VIC_MODEL             ; Memorizza il risultato, riabilita le interruzioni ed esci.

  !if __KERNAL_STATUS = "DISABLED" {
    +Disable_Kernal             ; Disabilita le interruzioni e la ROM del Kernal.
  }

  lda #%01111111                ; Disabilita tutte le sorgenti di interruzioni provenienti dai chip CIA.
  sta CIAICR                    ; ATTENZIONE: disabilitare le interruzioni del CIA #1 implica che
  sta CI2ICR                    ; la scansione della tastiera diventi responsabilità del programmatore!!!

  lda CIAICR                    ; Neutralizza eventuali IRQ in sospeso richiesti da CIA #1.
  lda CI2ICR                    ; Neutralizza eventuali IRQ in sospeso richiesti da CIA #2.

  asl VICIRQ                    ; Neutralizza eventuali IRQ in sospeso richiesti da VIC-II.

  lda #%00000001                ; Imposta il raster come unica sorgente di interruzioni
  sta IRQMSK                    ; provenienti dal VIC-II.
  !zone
}

!macro Start_Raster_IRQ .stable, .rasterline, .irq_handler {
  !if .stable = "STABLE" {
    +Start_Stable_IRQ .rasterline, .irq_handler
  } else {
    +Start_Unstable_IRQ .rasterline, .irq_handler
  }
}

!macro Enter_Raster_IRQ .stable, .rasterline {
  !if .stable = "STABLE" {
    +Enter_Stable_IRQ .rasterline
  } else {
    +Enter_Unstable_IRQ
  }
}

!macro Next_Raster_IRQ .stable, .rasterline, .irq_handler, .fast_exit {
  !if .stable = "STABLE" {
    +Next_Stable_IRQ .rasterline, .irq_handler, .fast_exit
  } else {
    +Next_Unstable_IRQ .rasterline, .irq_handler, .fast_exit
  }
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
!macro Set_Rasterline .rasterline {
  lda #<.rasterline                   ; I primi 8 bit della posizione della linea vanno qui.
  sta RASTER

  lda SCROLY
  !if .rasterline > 255 {
    ora #%10000000              ; Se la linea è > 255 allora setta il bit #7 di SCROLY
  } else {
    and #%01111111              ; altrimenti resettalo.
  }
  sta SCROLY
}

!macro Raster_Grip {
  bit+1 __VIC_MODEL             ; (+3) Testa il modello di chip VIC-II:
  bvs *+2                       ; (+2) se il chip è una qualsiasi versione NTSC allora (+3),
  bmi *+2                       ; (+2) se il chip è la versione "New NTSC" allora (+3).
}

!macro Start_Unstable_IRQ .rasterline, .irq_handler {
  !if __KERNAL_STATUS = "DISABLED" {
    lda #<.irq_handler              ; Se il Kernal è stato disabilitato usa il vettore a $FFFE.
    sta IRBVEC
    lda #>.irq_handler
    sta IRBVEC+1
  } else {
    lda #<.irq_handler              ; Se il Kernal è stato abilitato usa il vettore a $0314.
    sta CINV
    lda #>.irq_handler
    sta CINV+1
  }

  +Set_Rasterline .rasterline         ; Imposta il registro di confronto della rasterline.

  cli                           ; Riabilita le interruzioni.
}

!macro Enter_Unstable_IRQ {
  !if __KERNAL_STATUS = "DISABLED" {
      pha                       ; Se il Kernal è stato disabilitato salva per prima cosa .A

      txa                       ; poi .X
      pha

      tya                       ; ed infine .Y.
      pha
    }

  asl VICIRQ                    ; Recepisci l'esecuzione dell'interruzione dovuta al raster.
}

!macro Next_Unstable_IRQ .rasterline, .irq_handler, .fast_exit {
  !if __KERNAL_STATUS = "DISABLED" {
    lda #<.irq_handler              ; Se il Kernal è stato disabilitato usa il vettore a $FFFE.
    sta IRBVEC
    lda #>.irq_handler
    sta IRBVEC+1
  } else {
    lda #<.irq_handler              ; Se il Kernal è stato abilitato usa il vettore a $0314.
    sta CINV
    lda #>.irq_handler
    sta CINV+1
  }

  +Set_Rasterline .rasterline         ; Imposta il registro di confronto della rasterline.

  !if __KERNAL_STATUS = "DISABLED" {
    pla                         ; Se il Kernal è stato disabilitato il parametro '.fast_exit' non ha importanza:
    tay                         ; ripristina .Y

    pla                         ; poi .X
    tax

    pla                         ; ed infine .A.

    rti
  } else {
    !if .fast_exit = "FAST" {
      jmp IRQMIN                ; Se si richiede un'uscita veloce ripristina semplicemente i registri
    } else {
      jmp IRQHND                ; altrimenti salta al gestore delle interruzioni standard.
    }
  }
}

!macro Start_Stable_IRQ .rasterline, .irq_handler {
  !if __KERNAL_STATUS = "DISABLED" {
    lda #<.irq_handler              ; Se il Kernal è stato disabilitato usa il vettore a $FFFE.
    sta IRBVEC
    lda #>.irq_handler
    sta IRBVEC+1

    +Set_Rasterline (.rasterline-3)   ; La prima interruzione avverrà tre linee prima di quella desiderata
                                ; per dare il tempo al sistema di impostare la seconda interruzione.
  } else {
    lda #<.irq_handler              ; Se il Kernal è stato abilitato usa il vettore a $0314.
    sta CINV
    lda #>.irq_handler
    sta CINV+1

    +Set_Rasterline (.rasterline-3)   ; La prima interruzione avverrà tre linee prima di quella desiderata
                                ; per dare il tempo al sistema di impostare la seconda interruzione.
  }

  cli                           ; Riabilita le interruzioni.
}


; Il seguente gestore di interruzioni viene eseguito dopo che sono passati 38-44 cicli
; (9-15 cicli se il Kernal è stato disabilitato) dall'istante in cui il raster ha raggiunto
; la terzultima linea prima di quella realmente desiderata: in questo modo c'è tempo
; sufficiente per preparare il secondo gestore, introdurre i cicli aggiuntivi in caso
; di versioni NTSC del chip e gestire lo stack.
;
; In ogni commento c'è l'intervallo di cicli nel quale è possibile avvenga l'esecuzione
; dell'istruzione, seguita dalla durata in cicli dell'istruzione stessa.
; I valori si riferiscono alla versione PAL del chip VIC-II: la macro +Raster_Grip
; si occupa di gestire eventuali cicli aggiuntivi presenti nelle versioni Old e New NTSC.
!macro Enter_Stable_IRQ .rasterline {
  !if __KERNAL_STATUS = "DISABLED" {
    pha                         ; 09-15 (+3)   Se il Kernal è stato disabilitato salva per prima cosa .A

    txa                         ; 12-18 (+2)   poi .X
    pha                         ; 14-20 (+3)

    tya                         ; 17-23 (+2)   ed infine .Y.
    pha                         ; 19-25 (+3)

    asl VICIRQ                  ; 22-28 (+6)   Recepisci l'interruzione.

    lda #<@Sync                 ; 28-34 (+2)   Imposta il gestore di interruzioni definito dall'utente.
    sta IRBVEC                  ; 30-36 (+4)
    lda #>@Sync                 ; 34-40 (+2)
    sta IRBVEC+1                ; 36-42 (+4)

    +Set_Rasterline (.rasterline-1)   ; 40-46 (+16)  Imposta il registro di confronto della rasterline alla linea che precede quella desiderata.

    cli                         ; 56-62 (+2)

    inc UNUSE2                  ; 58-01 (+6)   Assicurati di passare alla linea successiva quale che sia la versione del VIC-II.
    dec UNUSE2                  ; 01-07 (+6)

    +Raster_Grip                ; 07-13 (+7)   Testa il modello di chip VIC-II e consuma eventuali cicli aggiuntivi se NTSC.

    +Delay_5n1 ".Y", 7          ; 14-20 (+36)  Gira a vuoto per un po'.
    nop                         ; 50-56 (+2)

    tsx                         ; 52-58 (+2)   Salva il valore dello stack
    nop                         ; 54-60 (+2)   Fino a questa istruzione è certo che non si è ancora giunti alla linea immediatamente
                                ;              precedente a quella desiderata.
  } else {
    asl VICIRQ                  ; 38-44 (+6)   Recepisci l'interruzione.

    lda #<@Sync                 ; 44-50 (+2)   Imposta il gestore di interruzioni definito dall'utente.
    sta CINV                    ; 46-52 (+4)
    lda #>@Sync                 ; 50-56 (+2)
    sta CINV+1                  ; 52-58 (+4)

    +Set_Rasterline (.rasterline-1)   ; 56-62 (+16)  Imposta il registro di confronto della rasterline alla linea che precede quella desiderata.

    cli                         ; 09-15 (+2)

    +Raster_Grip                ; 11-17 (+7)   Testa il modello di chip VIC-II e consuma eventuali cicli aggiuntivi se NTSC.

    +Delay_5n1 ".Y", 5          ; 18-24 (+26)  Gira a vuoto per un po'.

    tsx                         ; 44-50 (+2)   Salva il valore dello stack
    stx @Restore_Stack+1        ; 46-52 (+4)   con un po' di codice automodificante!
    nop                         ; 50-56 (+2)
    nop                         ; 52-58 (+2)
    nop                         ; 54-60 (+2)   Fino a questa istruzione è certo che non si è ancora giunti alla linea immediatamente
                                ;              precedente a quella desiderata.
  }

; Durante l'esecuzione di una qualsiasi delle prossime istruzioni "nop" è possibile che
; il raster incominci a disegnare la linea precedente a quella da noi desiderata.
; Qualora ciò avvenisse, scatterà un'interruzione ed il controllo arriverà al
; gestore precedentemente impostato solo a partire dal ciclo 38 o 39, quindi con
; un'incertezza di un solo ciclo.

    nop                         ; 56-62 (+2)   Possibile interruzione se l'istruzione viene eseguita al ciclo 61 o successivamente.
    nop                         ; 58-01 (+2)   Possibile interruzione se l'istruzione viene eseguita al ciclo 61 o successivamente.
    nop                         ; 60-03 (+2)   Possibile interruzione se l'istruzione viene eseguita al ciclo 61 o successivamente.
    nop                         ; 62-05 (+2)   Arrivati qui è certo che avverrà l'interruzione.
    nop                         ;              "nop" di margine.
    nop                         ;              "nop" di margine.

  !if __KERNAL_STATUS = "DISABLED" {
    @Sync:
      asl VICIRQ                ; 09-10 (+6)   Recepisci l'interruzione.

      +Delay_5n1 ".Y", 6        ; 15-16 (+31)  Gira a vuoto per un po'.

    @Restore_Stack:
      txs                       ; 46-47 (+2)   Ripristina lo stack in modo che l'istruzione "rti" finale
                                ;              realizzi l'uscita da entrambi le interruzioni di stabilizzazione.
  } else {
    @Sync:
      asl VICIRQ                ; 38-39 (+6)   Recepisci l'interruzione.

    @Restore_Stack:
      ldx #$00                  ; 44-45 (+2)   Ripristina lo stack in modo che l'istruzione "rti" finale
      txs                       ; 46-47 (+2)   realizzi l'uscita da entrambi le interruzioni di stabilizzazione.
  }
    +Raster_Grip                ; 48-49 (+7)   Testa il modello di chip VIC-II e consuma eventuali cicli aggiuntivi se NTSC.

    lda RASTER                  ; 55-56 (+4)   Il raster deve essere letto esattamente in questo ciclo
    cmp RASTER                  ; 59-60 (+4)   perchè il quarto ed ultimo ciclo dell'istruzione "cmp"
                                ;              deve avvenire:
                                ;              O in corrispondenza dell'ultimo ciclo della linea precedente a quella impostata
                                ;              OPPURE in corrispondenza del primo ciclo della linea impostata.

    beq *+2                     ; (+3/+2)  03  Nel primo caso Z=1 e l'istruzione "beq" impiega 3 cicli,
                                ;              nel secondo caso Z=0 e l'istruzione "beq" impiega 2 cicli.

                                ;              In entrambi i casi la prossima istruzione verrà eseguita a partire dal ciclo 3
                                ;              della linea impostata: RASTER STABILIZZATO!
}

!macro Next_Stable_IRQ .rasterline, .irq_handler, .fast_exit {
  !if __KERNAL_STATUS = "DISABLED" {
    lda #<.irq_handler              ; Se il Kernal è stato disabilitato usa il vettore a $FFFE.
    sta IRBVEC
    lda #>.irq_handler
    sta IRBVEC+1

    +Set_Rasterline (.rasterline-3)   ; Imposta il registro di confronto della rasterline.
  } else {
    lda #<.irq_handler              ; Se il Kernal è stato abilitato usa il vettore a $0314.
    sta CINV
    lda #>.irq_handler
    sta CINV+1

    +Set_Rasterline (.rasterline-3)   ; Imposta il registro di confronto della rasterline.
  }

  !if __KERNAL_STATUS = "DISABLED" {
    pla                         ; Se il Kernal è stato disabilitato il parametro '.fast_exit' non ha importanza:
    tay                         ; ripristina .Y

    pla                         ; poi .X
    tax

    pla                         ; ed infine .A.

    rti
  } else {
    !if .fast_exit = "FAST" {
      jmp IRQMIN                ; Se si richiede un'uscita veloce ripristina semplicemente i registri
    } else {
      jmp IRQHND                ; altrimenti salta al gestore delle interruzioni standard.
    }
  }
}
