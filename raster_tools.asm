; ==============================================================================
; FILE:           raster_tools.asm
; PROGETTO:       Libreria di Sistema (system.c64)
; TARGET:         ACME Assembler / MOS 6510 (Commodore 64)
; DESCRIZIONE:    Macro di utilità per la definizione di interruzioni di raster
;                 concatenate, sia stabili che instabili. Non adatte per codici
;                 iper-ottimizzati. Supportano tutte le versioni del chip VIC-II,
;                 sia PAL che NTSC.
; CONTENUTO:      m_Init_Raster_System  Prepara il sistema ai Raster IRQ
;                 m_Start_Raster_IRQ    Avvia una catena di Raster IRQ
;                 m_Enter_Raster_IRQ    Entra in un gestore Raster IRQ
;                 m_Next_Raster_IRQ     Prepara il prossimo Raster IRQ, esce
;                 m_Set_Rasterline      Imposta la linea di raster di confronto
;                 m_Raster_Grip         Compensa i cicli extra del VIC-II NTSC
;                 m_Start_Unstable_IRQ  Avvia una catena di IRQ instabili
;                 m_Enter_Unstable_IRQ  Entra in un gestore IRQ instabile
;                 m_Next_Unstable_IRQ   Prepara il prossimo IRQ instabile, esce
;                 m_Start_Stable_IRQ    Avvia una catena di IRQ stabili
;                 m_Enter_Stable_IRQ    Entra in un gestore IRQ stabile
;                 m_Next_Stable_IRQ     Prepara il prossimo IRQ stabile, esce
; DIPENDENZE:     Nessuna
; REQUISITI ZP:   __VIC_MODEL
; ==============================================================================

; ****************************************************************
; * TO-DO: Documentare un esempio di uso delle macro.            *
; *                                                              *
; * Cosa manca: la cornice del file e i contratti descrivono le  *
; * singole macro, ma nessun punto mostra come si usano insieme. *
; *                                                              *
; * Da scrivere: un esempio completo e commentato che prepari il *
; * sistema con m_Init_Raster_System, avvii una catena di Raster *
; * IRQ con m_Start_Raster_IRQ e la percorra con                 *
; * m_Enter_Raster_IRQ e m_Next_Raster_IRQ, nelle versioni       *
; * instabile e stabile.                                         *
; *                                                              *
; * Dove: nelle note d'uso del file (HDR-17). A lavoro finito il *
; * riquadro si toglie.                                          *
; ****************************************************************

; ==============================================================================
; MACRO: m_Init_Raster_System
; ------------------------------------------------------------------------------
; Descrizione:  Disabilita tutte le sorgenti di interruzioni legate ai chip CIA
;               ed attiva UNICAMENTE le interruzioni dovute al raster. Dato che
;               tutte le altre interruzioni sono disabilitate, la gestione della
;               tastiera e dell'I/O seriale sono demandate alla responsabilità
;               del programmatore.
;               La macro determina anche il tipo di chip VIC-II installato sul
;               computer sul quale sta girando: un codice identificativo viene
;               conservato nella locazione rappresentata dal punto di
;               configurazione __VIC_MODEL. Il significato del codice è
;               il seguente:
;
;                 $00 = PAL       63 cicli per linea
;                 $40 = Old NTSC  64 cicli per linea
;                 $C0 = New NTSC  65 cicli per linea
;
;               La macro m_Raster_Grip fa uso di questa informazione per
;               iniettare nel codice 1 o 2 cicli extra di temporizzazione in
;               base alla versione rilevata del chip VIC-II.
;
; Input:
;   - Nessuno
;
; Output:
;   - __VIC_MODEL (1 byte, ZP)   : Modello di VIC-II (vedi Descrizione)
;   - Flag Interrupt (1 bit, .P) : sempre 1
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .X, .Y,
;                       .P (Negative, oVerflow, Interrupt, Zero, Carry),
;                       __VIC_MODEL, CIAICR, CI2ICR, VICIRQ, IRQMSK,
;                       R6510 (se __DISABLE_KERNAL = 1)
; Dipendenze Esterne:   <c64/symbols.asm>
;                       <chip/cia.asm>
;                       <chip/vic_ii.asm>
;                       <system/6510_tools.asm>
;                       <system/standard.asm>
; ==============================================================================
!macro m_Init_Raster_System {
  !zone Init_Raster_System

    ; Gira a vuoto finché il raster non ritorna
    ; nell'intervallo 0-255.
    .Loop_Wait_Top:
      bit SCROLY                          ; REPEAT

    .Loop_Check_Top:
      bmi .Loop_Wait_Top                  ; REPEAT UNTIL: il raster è nell'intervallo 0-255

      sei                                 ; Disabilita le interruzioni.

    ; A questo punto gira a vuoto finché il raster non entra
    ; nell'intervallo 256-???.
    .Loop_Wait_Line_261:
      bit SCROLY                          ; REPEAT

    .Loop_Check_Line_261:
      bpl .Loop_Wait_Line_261             ; REPEAT UNTIL: il raster è nell'intervallo 256-???

      ; Ora si può continuare a girare a vuoto finché non si è
      ; raggiunta la linea 261 = 256 + 5, che è l'ultima linea
      ; comune a tutte le versioni esistenti del VIC_II (Old NTSC =
      ; 0-261, New NTSC = 0-262, PAL = 0-311).

      lda #<261

    .Loop_Spin_261:
      cmp RASTER                          ; REPEAT

    .Loop_Check_261:
      bne .Loop_Spin_261                  ; REPEAT UNTIL: il raster ha raggiunto la linea 261

    .Check_Line_262:
      +m_Delay_5n1 ".X", 19               ; Non appena entrati nella linea 261, facciamo passare 96
                                          ; cicli in modo da essere sicuri di essere ben entrati nella
                                          ; linea successiva.

      bit SCROLY                          ; Se il contatore è ancora maggiore di 256 vuol dire che siamo
                                          ; ancora al fondo dello schermo, e l'identificazione non è
      bmi .Else_If_Line_263               ; ancora completa.

    .Old_NTSC:
      ldy #%01000000                      ; Altrimenti siamo ritornati all'inizio dello schermo e siamo
                                          ; sicuri di aver identificato la versione "Old NTSC".
      bne .Exit_INIT_RASTER_SYSTEM

    .Else_If_Line_263:
      +m_Delay_5n1 ".X", 19               ; Facciamo passare altri 96 cicli e ripetiamo il test.

      bit SCROLY                          ; Se il contatore è ancora maggiore di 256 allora non ci sono
                                          ; dubbi: il chip VIC-II è in versione "PAL",
      bmi .Else_PAL

    .New_NTSC:
      ldy #%11000000                      ; altrimenti non può che essere in versione "New NTSC".
      bne .Exit_INIT_RASTER_SYSTEM

    .Else_PAL:
      ldy #%00000000

    .Exit_INIT_RASTER_SYSTEM:
      sty __VIC_MODEL                     ; Memorizza il risultato, riabilita le interruzioni ed esci.

      !if (__DISABLE_KERNAL = 1) {
        +m_Disable_Kernal                 ; Disabilita le interruzioni e la ROM del Kernal.
      }

      lda #%01111111                      ; Disabilita tutte le sorgenti di interruzioni provenienti dai
                                          ; chip CIA.
      sta CIAICR                          ; ATTENZIONE: disabilitare le interruzioni del CIA #1
                                          ; implica che
      sta CI2ICR                          ; la scansione della tastiera diventi responsabilità
                                          ; del programmatore!!!

      lda CIAICR                          ; Neutralizza eventuali IRQ in sospeso richiesti da CIA #1.
      lda CI2ICR                          ; Neutralizza eventuali IRQ in sospeso richiesti da CIA #2.

      asl VICIRQ                          ; Neutralizza eventuali IRQ in sospeso richiesti da VIC-II.

      lda #%00000001                      ; Imposta il raster come unica sorgente di interruzioni
      sta IRQMSK                          ; provenienti dal VIC-II.

  !zone
}

; ==============================================================================
; MACRO: m_Start_Raster_IRQ
; ------------------------------------------------------------------------------
; Descrizione:  Questa macro inizia una catena di interruzioni di raster: il
;               primo interrupt della catena può essere sia di tipo stabile che
;               instabile. Questa macro si limita solo a richiamare le macro
;               m_Start_Stable_IRQ e m_Start_Unstable_IRQ che si occupano
;               dell'effettiva realizzazione dell'interruzione.
;
; Input:
;   - .stable_ (stringa, Macro)     : "STABLE" = stabile, altro = instabile
;   - .rasterline_ (2 byte, Macro)  : Linea di raster desiderata
;   - .irq_handler_ (2 byte, Macro) : Indirizzo del gestore dell'interruzione
;
; Output:
;   - Flag Interrupt (1 bit, .P)    : sempre 0
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .P (Negative, Interrupt, Zero), RASTER, SCROLY,
;                       IRBVEC (se __DISABLE_KERNAL = 1),
;                       CINV (se __DISABLE_KERNAL = 0)
; Dipendenze Esterne:   <c64/symbols.asm>
;                       <chip/vic_ii.asm>
; ==============================================================================
!macro m_Start_Raster_IRQ .stable_, .rasterline_, .irq_handler_ {
    !if (.stable_ = "STABLE") {
      +m_Start_Stable_IRQ .rasterline_, .irq_handler_
    } else {
      +m_Start_Unstable_IRQ .rasterline_, .irq_handler_
    }
}

; ==============================================================================
; MACRO: m_Enter_Raster_IRQ
; ------------------------------------------------------------------------------
; Descrizione:  La macro va obbligatoriamente invocata come prima istruzione del
;               gestore delle interruzioni di raster. Questa macro si limita
;               solo a richiamare le macro m_Enter_Stable_IRQ e
;               m_Enter_Unstable_IRQ che si occupano
;               dell'effettiva realizzazione.
;
; Input:
;   - .stable_ (stringa, Macro)    : "STABLE" = stabile, altro = instabile
;   - .rasterline_ (2 byte, Macro) : Linea di raster (solo se stabile)
;
; Output:
;   - Flag Interrupt (1 bit, .P)   : 0 = stabile; 1 = instabile
;
; Variazione Stack (.S):
;   - Decrementato di 3 byte
;
; Registri Modificati:  .A, .X, .Y,
;                       .P (Negative, oVerflow, Interrupt, Zero, Carry), RASTER,
;                       SCROLY, VICIRQ, IRBVEC (se __DISABLE_KERNAL = 1),
;                       CINV (se __DISABLE_KERNAL = 0)
; Dipendenze Esterne:   <c64/symbols.asm>
;                       <chip/vic_ii.asm>
;                       <system/standard.asm>
; ==============================================================================
!macro m_Enter_Raster_IRQ .stable_, .rasterline_ {
    !if (.stable_ = "STABLE") {
      +m_Enter_Stable_IRQ .rasterline_
    } else {
      +m_Enter_Unstable_IRQ
    }
}

; ==============================================================================
; MACRO: m_Next_Raster_IRQ
; ------------------------------------------------------------------------------
; Descrizione:  La macro va obbligatoriamente invocata come ultima istruzione
;               del gestore delle interruzioni di raster. Questa macro si limita
;               solo a richiamare le macro m_Next_Stable_IRQ e
;               m_Next_Unstable_IRQ che si occupano dell'effettiva
;               realizzazione. Affinché la catena di interruzioni di raster sia
;               ben formata è responsabilità del programmatore che l'ultimo
;               anello della catena richiami il primo gestore, quello definito
;               dalla macro m_Start_Raster_IRQ. Il parametro .fast_exit_ è
;               ignorato se __DISABLE_KERNAL = 1.
;
; Input:
;   - .stable_ (stringa, Macro)     : "STABLE" = stabile, altro = instabile
;   - .rasterline_ (2 byte, Macro)  : Linea di raster del prossimo IRQ
;   - .irq_handler_ (2 byte, Macro) : Indirizzo del gestore del prossimo IRQ
;   - .fast_exit_ (stringa, Macro)  : "FAST" = IRQMIN, altro = IRQHND
;
; Output:
;   - .PC (2 byte, CPU)             : Uscita con rti o salto a IRQMIN/IRQHND
;
; Variazione Stack (.S):
;   - Incrementato di 6 byte
;
; Registri Modificati:  .A, .P (Negative, Interrupt, Zero), RASTER, SCROLY,
;                       IRBVEC (se __DISABLE_KERNAL = 1),
;                       CINV (se __DISABLE_KERNAL = 0)
; Dipendenze Esterne:   <c64/symbols.asm>
;                       <chip/vic_ii.asm>
; ==============================================================================
!macro m_Next_Raster_IRQ .stable_, .rasterline_, .irq_handler_, .fast_exit_ {
    !if (.stable_ = "STABLE") {
      +m_Next_Stable_IRQ .rasterline_, .irq_handler_, .fast_exit_
    } else {
      +m_Next_Unstable_IRQ .rasterline_, .irq_handler_, .fast_exit_
    }
}

; ==============================================================================
; MACRO: m_Set_Rasterline
; ------------------------------------------------------------------------------
; Descrizione:  Macro di supporto per il settaggio del registro RASTER del chip
;               VIC-II. La macro viene eseguita in tempo costante (16 cicli) e
;               gestisce correttamente il settaggio del bit #9.
;
; Input:
;   - .rasterline_ (2 byte, Macro) : Linea di raster (9 bit, costante)
;
; Output:
;   - Nessuno
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .P (Negative, Zero), RASTER, SCROLY
; Dipendenze Esterne:   <chip/vic_ii.asm>
; ==============================================================================
!macro m_Set_Rasterline .rasterline_ {
    lda #<.rasterline_                    ; I primi 8 bit della posizione della linea vanno qui.
    sta RASTER

    lda SCROLY

    !if (.rasterline_ > 255) {
      ora #%10000000                      ; Se la linea è > 255 allora setta il bit #7 di SCROLY
    } else {
      and #%01111111                      ; altrimenti resettalo.
    }

    sta SCROLY
}

; ==============================================================================
; MACRO: m_Raster_Grip
; ------------------------------------------------------------------------------
; Descrizione:  Macro per la sincronizzazione del raster in maniera indipendente
;               dall'hardware: siccome le 3 versioni esistenti del chip VIC-II
;               (PAL, Old NTSC e New NTSC) producono una linea di raster in 63,
;               64 e 65 cicli rispettivamente, è necessario che il codice di
;               sincronizzazione consumi 1 o 2 cicli di ritardo in più qualora
;               l'hardware lo imponga. È pertanto obbligatorio che questa macro
;               venga eseguita solo dopo l'esecuzione della macro
;               m_Init_Raster_System che si occuperà dell'identificazione del
;               chip VIC-II.
;               La macro consuma 7 cicli su hardware PAL, 8 cicli su hardware
;               Old NTSC e 9 cicli su hardware New NTSC. Nei calcoli di
;               temporizzazione il programmatore dovrà sempre assumere che la
;               linea di raster venga disegnata in 63 cicli (PAL) e che
;               m_Raster_Grip duri 7 cicli: l'implementazione interna garantirà
;               la coerenza dei calcoli in caso di hardware NTSC.
;
; Input:
;   - __VIC_MODEL (1 byte, ZP) : Modello VIC-II (vedi m_Init_Raster_System)
;
; Output:
;   - Nessuno
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .P (Negative, oVerflow, Zero)
; Dipendenze Esterne:   Nessuna
; ==============================================================================
!macro m_Raster_Grip {
    bit+1 __VIC_MODEL                     ; 01-01 (+3)   Testa il modello di chip VIC-II: i bit #6 e #7 del contenuto
                                          ;              di __VIC_MODEL vengono copiati nei flag V e N.
    bvs @Any_NTSC                         ; 04-04 (+3/2) Se il chip è una qualsiasi versione NTSC (V=1) il salto
                                          ;              impiega 3 cicli, altrimenti 2.

  @Any_NTSC:
    bmi @New_NTSC                         ; 06-07 (+3/2) Se il chip è la versione "New NTSC" (N=1) il salto impiega 3
                                          ;              cicli, altrimenti 2.

  @New_NTSC:
}

; ==============================================================================
; MACRO: m_Start_Unstable_IRQ
; ------------------------------------------------------------------------------
; Descrizione:  La macro inizializza il vettore IRQ, la cui locazione differisce
;               in dipendenza dallo stato di attivazione del Kernal, con
;               l'indirizzo di partenza del gestore delle interruzioni poi
;               imposta la linea di raster alla quale far scattare
;               l'interruzione e ripristina il flag di Interrupt.
;
; Input:
;   - .rasterline_ (2 byte, Macro)  : Linea di raster desiderata
;   - .irq_handler_ (2 byte, Macro) : Indirizzo del gestore dell'interruzione
;
; Output:
;   - Flag Interrupt (1 bit, .P)    : sempre 0
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .P (Negative, Interrupt, Zero), RASTER, SCROLY,
;                       IRBVEC (se __DISABLE_KERNAL = 1),
;                       CINV (se __DISABLE_KERNAL = 0)
; Dipendenze Esterne:   <c64/symbols.asm>
;                       <chip/vic_ii.asm>
; ==============================================================================
!macro m_Start_Unstable_IRQ .rasterline_, .irq_handler_ {
    !if (__DISABLE_KERNAL = 1) {
      lda #<.irq_handler_                 ; Se il Kernal è stato disabilitato usa il vettore a $FFFE.
      sta IRBVEC
      lda #>.irq_handler_
      sta IRBVEC+1
    } else {
      lda #<.irq_handler_                 ; Se il Kernal è stato abilitato usa il vettore a $0314.
      sta CINV
      lda #>.irq_handler_
      sta CINV+1
    }

    +m_Set_Rasterline .rasterline_        ; Imposta il registro di confronto della linea di raster.

    cli                                   ; Riabilita le interruzioni.
}

; ==============================================================================
; MACRO: m_Enter_Unstable_IRQ
; ------------------------------------------------------------------------------
; Descrizione:  La macro implementa le buone pratiche da seguire all'esecuzione
;               di un gestore delle interruzioni: se il Kernal è disabilitato
;               provvede a salvare i registri .A, .X e .Y sullo stack (se il
;               Kernal è abilitato questa operazione viene svolta in automatico)
;               e poi altera il registro VICIRQ per segnalare l'avvenuto
;               riconoscimento dell'interruzione.
;
; Input:
;   - Nessuno
;
; Output:
;   - Flag Interrupt (1 bit, .P) : sempre 1
;
; Variazione Stack (.S):
;   - Decrementato di 3 byte
;
; Registri Modificati:  .A (se __DISABLE_KERNAL = 1),
;                       .P (Negative, Zero, Carry), VICIRQ
; Dipendenze Esterne:   <chip/vic_ii.asm>
; ==============================================================================
!macro m_Enter_Unstable_IRQ {
    !if (__DISABLE_KERNAL = 1) {
      pha                                 ; Se il Kernal è stato disabilitato salva per prima cosa .A

      txa                                 ; poi .X
      pha

      tya                                 ; ed infine .Y.
      pha
    }

    asl VICIRQ                            ; Recepisci l'esecuzione dell'interruzione dovuta al raster.
}

; ==============================================================================
; MACRO: m_Next_Unstable_IRQ
; ------------------------------------------------------------------------------
; Descrizione:  La macro implementa le buone pratiche da seguire all'uscita di
;               un gestore delle interruzioni: il vettore IRQ (tenendo conto
;               dello stato di attivazione del Kernal) viene impostato
;               all'indirizzo del prossimo anello della catena, idem per la
;               linea di raster alla quale dovrà essere eseguito e poi si
;               provvede a ripristinare lo stack: se il Kernal è abilitato si
;               salta a IRQMIN (nel caso si desideri un'uscita "fast") o a
;               IRQHND (se si desiderà un'uscita "slow" che scansioni la
;               tastiera, aggiorni i timer, eccetera). Se invece il Kernal è
;               disabilitato non vi sono alternative: l'uscita sarà sempre
;               "fast" ed il ripristino sarà realizzato mediante apposito
;               codice in-line.
;
; Input:
;   - .rasterline_ (2 byte, Macro)  : Linea di raster del prossimo IRQ
;   - .irq_handler_ (2 byte, Macro) : Indirizzo del gestore del prossimo IRQ
;   - .fast_exit_ (stringa, Macro)  : "FAST" = IRQMIN, altro = IRQHND
;
; Output:
;   - .PC (2 byte, CPU)             : Uscita con rti o salto a IRQMIN/IRQHND
;
; Variazione Stack (.S):
;   - Incrementato di 6 byte
;
; Registri Modificati:  .A, .P (Negative, Interrupt, Zero), RASTER, SCROLY,
;                       IRBVEC (se __DISABLE_KERNAL = 1),
;                       CINV (se __DISABLE_KERNAL = 0)
; Dipendenze Esterne:   <c64/symbols.asm>
;                       <chip/vic_ii.asm>
; ==============================================================================
!macro m_Next_Unstable_IRQ .rasterline_, .irq_handler_, .fast_exit_ {
    !if (__DISABLE_KERNAL = 1) {
      lda #<.irq_handler_                 ; Se il Kernal è stato disabilitato usa il vettore a $FFFE.
      sta IRBVEC
      lda #>.irq_handler_
      sta IRBVEC+1
    } else {
      lda #<.irq_handler_                 ; Se il Kernal è stato abilitato usa il vettore a $0314.
      sta CINV
      lda #>.irq_handler_
      sta CINV+1
    }

    +m_Set_Rasterline .rasterline_        ; Imposta il registro di confronto della linea di raster.

    !if (__DISABLE_KERNAL = 1) {
      pla                                 ; Se il Kernal è stato disabilitato il parametro '.fast_exit_'
                                          ; non ha importanza:
      tay                                 ; ripristina .Y

      pla                                 ; poi .X
      tax

      pla                                 ; ed infine .A.

      rti
    } else {
      !if (.fast_exit_ = "FAST") {
        jmp IRQMIN                        ; Se si richiede un'uscita veloce ripristina semplicemente
                                          ; i registri
      } else {
        jmp IRQHND                        ; altrimenti salta al gestore delle interruzioni standard.
      }
    }
}

; ==============================================================================
; MACRO: m_Start_Stable_IRQ
; ------------------------------------------------------------------------------
; Descrizione:  La macro inizializza il vettore IRQ, la cui locazione differisce
;               in dipendenza dallo stato di attivazione del Kernal, con
;               l'indirizzo di partenza del gestore delle interruzioni poi
;               imposta la linea di raster (vedi sotto) alla quale far scattare
;               l'interruzione e ripristina il flag di Interrupt.
;               Per ottenere la stabilizzazione dell'interruzione di raster si
;               utilizza la tecnica del doppio interrupt: questa macro serve ad
;               impostare con congruo anticipo (3 linee di raster) il primo
;               dei due.
;
;               IMPORTANTE: la macro presuppone che (.rasterline_-3) non
;               corrisponda ad una "badline". In caso contrario i calcoli di
;               temporizzazione su cui si basa il processo di sincronizzazione
;               non saranno validi, con effetti imprevedibili.
;
; Input:
;   - .rasterline_ (2 byte, Macro)  : Linea di raster desiderata
;   - .irq_handler_ (2 byte, Macro) : Indirizzo del gestore dell'interruzione
;
; Output:
;   - Flag Interrupt (1 bit, .P)    : sempre 0
;
; Variazione Stack (.S):
;   - Stabile
;
; Registri Modificati:  .A, .P (Negative, Interrupt, Zero), RASTER, SCROLY,
;                       IRBVEC (se __DISABLE_KERNAL = 1),
;                       CINV (se __DISABLE_KERNAL = 0)
; Dipendenze Esterne:   <c64/symbols.asm>
;                       <chip/vic_ii.asm>
; ==============================================================================
!macro m_Start_Stable_IRQ .rasterline_, .irq_handler_ {
    !if (__DISABLE_KERNAL = 1) {
      lda #<.irq_handler_                 ; Se il Kernal è stato disabilitato usa il vettore a $FFFE.
      sta IRBVEC
      lda #>.irq_handler_
      sta IRBVEC+1

      +m_Set_Rasterline (.rasterline_-3)  ; La prima interruzione avverrà tre linee prima di quella
                                          ; desiderata per dare il tempo al sistema di impostare la
                                          ; seconda interruzione.
    } else {
      lda #<.irq_handler_                 ; Se il Kernal è stato abilitato usa il vettore a $0314.
      sta CINV
      lda #>.irq_handler_
      sta CINV+1

      +m_Set_Rasterline (.rasterline_-3)  ; La prima interruzione avverrà tre linee prima di quella
                                          ; desiderata per dare il tempo al sistema di impostare la
                                          ; seconda interruzione.
    }

    cli                                   ; Riabilita le interruzioni.
}

; ==============================================================================
; MACRO: m_Enter_Stable_IRQ
; ------------------------------------------------------------------------------
; Descrizione:  La macro implementa la seconda parte della tecnica di
;               stabilizzazione del raster mediante doppio interrupt.
;               Per prima cosa si effettuano le operazioni di riconoscimento del
;               primo interrupt secondo le buone pratiche descritte in
;               m_Enter_Unstable_IRQ impostando il secondo interrupt in modo che
;               scatti a .rasterline_-1 (il codice di sincronizzazione parte
;               dall'etichetta @Sync); le operazioni differiscono in base allo
;               stato di attivazione del Kernal.
;               Il tempo rimanente viene impiegato per salvare il valore di .S,
;               dopodiché si consumano cicli in attesa che scatti il secondo
;               interrupt mentre si eseguono istruzioni di durata nota.
;               Il secondo interrupt procede a bruciare cicli (il numero dipende
;               dallo stato di attivazione del Kernal) per eseguire
;               un'operazione di comparazione esattamente al ciclo 59 o 60.
;               Un'operazione di salto fittizia brucerà 2 oppure 3 cicli a
;               seconda del risultato della comparazione garantendo che
;               l'istruzione successiva venga eseguita con certezza al ciclo 3
;               della linea di raster .rasterline_, stabilizzando così
;               il raster!
;
;               IMPORTANTE: la macro presuppone che (.rasterline_-1) non
;               corrisponda ad una "badline". In caso contrario i calcoli di
;               temporizzazione su cui si basa il processo di sincronizzazione
;               non saranno validi, con effetti imprevedibili.
;
;               ATTENZIONE: codice automodificante indicato con (!!!)
;
; Input:
;   - .rasterline_ (2 byte, Macro) : Linea di raster desiderata
;   - __VIC_MODEL (1 byte, ZP)     : Modello VIC-II (vedi m_Init_Raster_System)
;
; Output:
;   - Flag Interrupt (1 bit, .P)   : sempre 0
;
; Variazione Stack (.S):
;   - Decrementato di 3 byte
;
; Registri Modificati:  .A, .X, .Y,
;                       .P (Negative, oVerflow, Interrupt, Zero, Carry), RASTER,
;                       SCROLY, VICIRQ, IRBVEC (se __DISABLE_KERNAL = 1),
;                       CINV (se __DISABLE_KERNAL = 0)
; Dipendenze Esterne:   <c64/symbols.asm>
;                       <chip/vic_ii.asm>
;                       <system/standard.asm>
; ==============================================================================
!macro m_Enter_Stable_IRQ .rasterline_ {
    ; ****************************************************************
    ; * TO-DO: campionamento dell'IRQ in m_Enter_Stable_IRQ,         *
    ; * possibile discrepanza di un ciclo.                           *
    ; *                                                              *
    ; * Origine: è stato chiesto di verificare se la sequenza di nop *
    ; * usata nella fase di sincronizzazione del raster ha la        *
    ; * lunghezza giusta, se i commenti che la descrivono sono       *
    ; * corretti e se dipendono dal modello di VIC-II (Old NTSC, New *
    ; * NTSC o PAL).                                                 *
    ; *                                                              *
    ; * Cosa succede: da quella verifica è emersa una possibile      *
    ; * discrepanza di un ciclo, legata alla temporizzazione esatta  *
    ; * del VIC-II. La discrepanza non è dimostrata: non è stata né  *
    ; * confermata né esclusa, e gli altri passaggi del ragionamento *
    ; * non sono stati registrati.                                   *
    ; *                                                              *
    ; * Da fare: ricontrollare la sequenza di nop e i conteggi       *
    ; * (finestre di cicli, comparazione al ciclo 59 o 60, ciclo 3   *
    ; * della linea) per ciascun modello di VIC-II, con un emulatore *
    ; * a temporizzazione esatta o su macchina reale. Se la          *
    ; * discrepanza c'è, correggere i commenti o il codice.          *
    ; ****************************************************************

    ; Il seguente gestore delle interruzioni viene eseguito dopo
    ; che sono passati 38-44 cicli (9-15 cicli se il Kernal è
    ; stato disabilitato) dall'istante in cui il raster ha
    ; raggiunto la terzultima linea prima di quella realmente
    ; desiderata: in questo modo c'è tempo sufficiente per
    ; preparare il secondo gestore, introdurre i cicli aggiuntivi
    ; in caso di versioni NTSC del chip e gestire lo stack.
    ;
    ; In ogni commento c'è l'intervallo di cicli nel quale è
    ; possibile avvenga l'esecuzione dell'istruzione, seguita
    ; dalla durata in cicli dell'istruzione stessa. I valori si
    ; riferiscono alla versione PAL del chip VIC-II: la macro
    ; +m_Raster_Grip si occupa di gestire eventuali cicli
    ; aggiuntivi presenti nelle versioni Old e New NTSC.

    !if (__DISABLE_KERNAL = 1) {
      pha                                 ; 09-15 (+3)   Se il Kernal è stato disabilitato salva per prima cosa .A

      txa                                 ; 12-18 (+2)   poi .X
      pha                                 ; 14-20 (+3)

      tya                                 ; 17-23 (+2)   ed infine .Y.
      pha                                 ; 19-25 (+3)

      asl VICIRQ                          ; 22-28 (+6)   Recepisci l'interruzione.

      lda #<@Sync                         ; 28-34 (+2)   Imposta il gestore delle interruzioni definito dall'utente.
      sta IRBVEC                          ; 30-36 (+4)
      lda #>@Sync                         ; 34-40 (+2)
      sta IRBVEC+1                        ; 36-42 (+4)

      +m_Set_Rasterline (.rasterline_-1)  ; 40-46 (+16)  Imposta il registro di confronto della linea di raster alla
                                          ;              linea che precede quella desiderata.

      cli                                 ; 56-62 (+2)

      inc UNUSE2                          ; 58-01 (+6)   Assicurati di passare alla linea successiva quale che sia la
                                          ;              versione del VIC-II.
      dec UNUSE2                          ; 01-07 (+6)

      +m_Raster_Grip                      ; 07-13 (+7)   Testa il modello di chip VIC-II e consuma eventuali cicli
                                          ;              aggiuntivi se NTSC.

      +m_Delay_5n1 ".Y", 7                ; 14-20 (+36)  Gira a vuoto per un po'.
      nop                                 ; 50-56 (+2)

      tsx                                 ; 52-58 (+2)   Salva il valore dello stack.
      nop                                 ; 54-60 (+2)   Fino a questa istruzione è certo che non si è ancora giunti
                                          ;              alla linea immediatamente precedente a quella desiderata.
    } else {
      asl VICIRQ                          ; 38-44 (+6)   Recepisci l'interruzione.

      lda #<@Sync                         ; 44-50 (+2)   Imposta il gestore delle interruzioni definito dall'utente.
      sta CINV                            ; 46-52 (+4)
      lda #>@Sync                         ; 50-56 (+2)
      sta CINV+1                          ; 52-58 (+4)

      +m_Set_Rasterline (.rasterline_-1)  ; 56-62 (+16)  Imposta il registro di confronto della linea di raster alla
                                          ;              linea che precede quella desiderata.

      cli                                 ; 09-15 (+2)

      +m_Raster_Grip                      ; 11-17 (+7)   Testa il modello di chip VIC-II e consuma eventuali cicli
                                          ;              aggiuntivi se NTSC.

      +m_Delay_5n1 ".Y", 5                ; 18-24 (+26)  Gira a vuoto per un po'.

      tsx                                 ; 44-50 (+2)   Salva il valore dello stack
      stx @Restore_Stack+1                ; 46-52 (+4)   (!!!#1) con un po' di codice automodificante!
      nop                                 ; 50-56 (+2)
      nop                                 ; 52-58 (+2)
      nop                                 ; 54-60 (+2)   Fino a questa istruzione è certo che non si è ancora giunti
                                          ;              alla linea immediatamente precedente a quella desiderata.
    }

    ; Durante una delle prossime istruzioni "nop" il raster può
    ; iniziare a disegnare la linea precedente a quella da noi
    ; desiderata: in tal caso scatta un'interruzione e il
    ; controllo arriva al gestore precedentemente impostato
    ; (@Sync) con un'incertezza di un solo ciclo, cioè al ciclo 38
    ; o 39 se il Kernal è abilitato, al ciclo 09 o 10 se
    ; è disabilitato.
    ;
    ; Un "nop" viene interrotto se e solo se inizia al ciclo 63 o
    ; 01: la finestra è ricavata dalla temporizzazione di @Sync
    ; (cicli 09-10 con Kernal disabilitato, 38-39 con
    ; Kernal abilitato).

    nop                                   ; 56-62 (+2)   Non viene mai interrotta: inizia al più tardi al ciclo 62.
    nop                                   ; 58-01 (+2)   Viene interrotta solo se inizia al ciclo 63 o 01.
    nop                                   ; 60-03 (+2)   Viene interrotta solo se inizia al ciclo 63 o 01.
    nop                                   ; 62-05 (+2)   Viene interrotta solo se inizia al ciclo 63 o 01.
    nop                                   ; 01-07 (+2)   Viene interrotta con certezza: inizia al ciclo 01.
    nop                                   ; 03-09 (+2)   Non viene mai eseguita: l'interruzione è già avvenuta.

  !if (__DISABLE_KERNAL = 1) {

    @Sync:
      asl VICIRQ                          ; 09-10 (+6)   Recepisci l'interruzione.

      +m_Delay_5n1 ".Y", 6                ; 15-16 (+31)  Gira a vuoto per un po'.

    @Restore_Stack:
      txs                                 ; 46-47 (+2)   Ripristina lo stack in modo che l'istruzione "rti" finale
                                          ;              realizzi l'uscita da entrambi le interruzioni
                                          ;              di stabilizzazione.
  } else {

    @Sync:
      asl VICIRQ                          ; 38-39 (+6)   Recepisci l'interruzione.

    @Restore_Stack:
      ldx #$00                            ; 44-45 (+2)   (!!!#1) Ripristina lo stack in modo che l'istruzione "rti" finale
      txs                                 ; 46-47 (+2)   realizzi l'uscita da entrambi le interruzioni
                                          ;              di stabilizzazione.
  }

    +m_Raster_Grip                        ; 48-49 (+7)   Testa il modello di chip VIC-II e consuma eventuali cicli
                                          ;              aggiuntivi se NTSC.

    lda RASTER                            ; 55-56 (+4)   Il raster deve essere letto esattamente in questo ciclo
    cmp RASTER                            ; 59-60 (+4)   perchè il quarto ed ultimo ciclo dell'istruzione "cmp" deve
                                          ;              avvenire: O in corrispondenza dell'ultimo ciclo della linea
                                          ;              precedente a quella impostata OPPURE in corrispondenza del
                                          ;              primo ciclo della linea impostata.

    beq *+2                               ; 63-01 (+3/2) Nel primo caso Z=1 e l'istruzione "beq" impiega 3 cicli, nel
                                          ;              secondo caso Z=0 e l'istruzione "beq" impiega 2 cicli. In
                                          ;              entrambi i casi la prossima istruzione verrà eseguita a
                                          ;              partire dal ciclo 3 della linea impostata:
                                          ;              RASTER STABILIZZATO!
}

; ==============================================================================
; MACRO: m_Next_Stable_IRQ
; ------------------------------------------------------------------------------
; Descrizione:  La macro implementa le buone pratiche da seguire all'uscita di
;               un gestore delle interruzioni: il vettore IRQ (tenendo conto
;               dello stato di attivazione del Kernal) viene impostato
;               all'indirizzo del prossimo anello della catena, idem per la
;               linea di raster alla quale dovrà essere eseguito e poi si
;               provvede a ripristinare lo stack: se il Kernal è abilitato si
;               salta a IRQMIN (nel caso si desideri un'uscita "fast") o a
;               IRQHND (se si desiderà un'uscita "slow" che scansioni la
;               tastiera, aggiorni i timer, eccetera). Se invece il Kernal è
;               disabilitato non vi sono alternative: l'uscita sarà sempre
;               "fast" ed il ripristino sarà realizzato mediante apposito
;               codice in-line.
;               Siccome la macro presuppone che il prossimo anello della catena
;               sarà ancora un IRQ stabile, la prossima linea di raster sarà
;               impostata a .rasterline_-3, coerentemente con quanto fatto
;               da m_Start_Stable_IRQ.
;
; Input:
;   - .rasterline_ (2 byte, Macro)  : Linea di raster del prossimo IRQ
;   - .irq_handler_ (2 byte, Macro) : Indirizzo del gestore del prossimo IRQ
;   - .fast_exit_ (stringa, Macro)  : "FAST" = IRQMIN, altro = IRQHND
;
; Output:
;   - .PC (2 byte, CPU)             : Uscita con rti o salto a IRQMIN/IRQHND
;
; Variazione Stack (.S):
;   - Incrementato di 6 byte
;
; Registri Modificati:  .A, .P (Negative, Interrupt, Zero), RASTER, SCROLY,
;                       IRBVEC (se __DISABLE_KERNAL = 1),
;                       CINV (se __DISABLE_KERNAL = 0)
; Dipendenze Esterne:   <c64/symbols.asm>
;                       <chip/vic_ii.asm>
; ==============================================================================
!macro m_Next_Stable_IRQ .rasterline_, .irq_handler_, .fast_exit_ {
    !if (__DISABLE_KERNAL = 1) {
      lda #<.irq_handler_                 ; Se il Kernal è stato disabilitato usa il vettore a $FFFE.
      sta IRBVEC
      lda #>.irq_handler_
      sta IRBVEC+1

      +m_Set_Rasterline (.rasterline_-3)  ; Imposta il registro di confronto della linea di raster.
    } else {
      lda #<.irq_handler_                 ; Se il Kernal è stato abilitato usa il vettore a $0314.
      sta CINV
      lda #>.irq_handler_
      sta CINV+1

      +m_Set_Rasterline (.rasterline_-3)  ; Imposta il registro di confronto della linea di raster.
    }

    !if (__DISABLE_KERNAL = 1) {
      pla                                 ; Se il Kernal è stato disabilitato il parametro '.fast_exit_'
                                          ; non ha importanza:
      tay                                 ; ripristina .Y

      pla                                 ; poi .X
      tax

      pla                                 ; ed infine .A.

      rti
    } else {
      !if (.fast_exit_ = "FAST") {
        jmp IRQMIN                        ; Se si richiede un'uscita veloce ripristina semplicemente
                                          ; i registri
      } else {
        jmp IRQHND                        ; altrimenti salta al gestore delle interruzioni standard.
      }
    }
}
