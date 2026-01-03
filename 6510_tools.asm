!zone Memory

; Titolo:                 Disabilita il BASIC
; Nome:                   DISBAS
; Scopo:                  Rendi visibile il banco di memoria LORAM ($A000-$BFFF), disabilitando il BASIC
; Parametri di ingresso:  Nessuno
; Parametri di uscita:    Nessuno
; Registri alterati:      A
; Puntatori zp alterati:  Nessuno
; Temporanei alterati:    Nessuno
; Dipendenze esterne:     Nessuna

DISBAS  LDA R6510               ; Azzera il bit 0
        AND #%11111110
        STA R6510

        RTS

; Titolo:                 Riabilita il BASIC
; Nome:                   ENABAS
; Scopo:                  Maschera il banco di memoria LORAM ($A000-$BFFF), riabilitando il BASIC
; Parametri di ingresso:  Nessuno
; Parametri di uscita:    Nessuno
; Registri alterati:      A
; Puntatori zp alterati:  Nessuno
; Temporanei alterati:    Nessuno
; Dipendenze esterne:     Nessuna

ENABAS  LDA R6510               ; Setta il bit 0
        ORA #%00000001
        STA R6510

        RTS

; Titolo:                 Disabilita il Kernal
; Nome:                   DISKER
; Scopo:                  Rendi visibile il banco di memoria HIRAM ($E000-$FFFF), disabilitando il Kernal
;                         ATTENZIONE: gli interrupt saranno disabilitati
; Parametri di ingresso:  Nessuno
; Parametri di uscita:    Nessuno
; Registri alterati:      A
; Puntatori zp alterati:  Nessuno
; Temporanei alterati:    Nessuno
; Dipendenze esterne:     Nessuna

DISKER  SEI                     ; Disabilita gli interrupt

        LDA R6510               ; Azzera il bit 1
        AND #%11111101
        STA R6510

        RTS

; Titolo:                 Riabilita il Kernal
; Nome:                   ENAKER
; Scopo:                  Maschera il banco di memoria HIRAM ($E000-$FFFF), riabilitando il Kernal
;                         ATTENZIONE: gli interrupt saranno riabilitati
; Parametri di ingresso:  Nessuno
; Parametri di uscita:    Nessuno
; Registri alterati:      A
; Puntatori zp alterati:  Nessuno
; Temporanei alterati:    Nessuno
; Dipendenze esterne:     Nessuna

ENAKER  LDA R6510               ; Setta il bit 1
        ORA #%00000010
        STA R6510

        CLI                     ; Riabilita gli interrupt

        RTS

; Titolo:                 Maschera il generatore di caratteri
; Nome:                   DISCHR
; Scopo:                  Maschera il banco di memoria CHARGEN ($D000-$DFFF), riabilitando l'I/O
; Parametri di ingresso:  Nessuno
; Parametri di uscita:    Nessuno
; Registri alterati:      A
; Puntatori zp alterati:  Nessuno
; Temporanei alterati:    Nessuno
; Dipendenze esterne:     Nessuna

DISCHR  LDA R6510               ; Setta il bit 2
        ORA #%00000100
        STA R6510

        LDA #%10000001          ; Riabilita l'interrupt del timer di sistema
        STA CIAICR

        RTS

; Titolo:                 Rendi visibile il generatore di caratteri
; Nome:                   ENACHR
; Scopo:                  Rendi visibile il banco di memoria CHARGEN ($D000-$DFFF), disabilitando l'I/O
; Parametri di ingresso:  Nessuno
; Parametri di uscita:    Nessuno
; Registri alterati:      A
; Puntatori zp alterati:  Definito dall'utente
; Temporanei alterati:    Nessuno
; Dipendenze esterne:     Nessuna

ENACHR  LDA #%01111111          ; Disabilita l'interrupt del timer di sistema
        STA CIAICR

        LDA R6510               ; Azzera il bit 2
        AND #%11111011
        STA R6510

        RTS

; Titolo:                 Sposta l'inizio della memoria BASIC
; Nome:                   LOMEM
; Scopo:                  Sposta l'inizio della memoria dedicata al BASIC aggiornando la variabile di sistema TXTTAB
;                         La routine richiede un puntatore precedente all'indirizzo che conterrà il primo carattere
;                         del testo del programma. Al termine i puntatori del BASIC conterranno il valore del puntatore
;                         incrementato di 1
; Parametri di ingresso:  X: Indirizzo del puntatore contenente la locazione iniziale dell'area BASIC meno 1
; Parametri di uscita:    Nessuno
; Registri alterati:      A
; Puntatori zp alterati:  Definito dall'utente
; Temporanei alterati:    Nessuno
; Dipendenze esterne:     Nessuna

LOMEM   LDA #$00                ; Scrivi $00 nella locazione puntata
        STA (0,X)
        INC 0,X                 ; Incrementa il puntatore di 1
        BNE +
        INC 1,X
+       LDA 0,X                 ; e scrivilo in TXTTAB
        STA TXTTAB
        LDA 1,X
        STA TXTTAB+1

        JSR NEW                 ; Esegui il comando NEW per aggiustare tutti gli altri
                                ; puntatori che dipendono da TXTTAB
        RTS

; Titolo:                 Sposta la fine della memoria BASIC
; Nome:                   HIMEM
; Scopo:                  Sposta la fine della memoria dedicata al BASIC aggiornando la variabile di sistema MEMSIZ
; Parametri di ingresso:  X: Indirizzo del puntatore contenente la locazione finale dell'area BASIC
; Parametri di uscita:    Nessuno
; Registri alterati:      A
; Puntatori zp alterati:  Nessuno
; Temporanei alterati:    Nessuno
; Dipendenze esterne:     Nessuna

HIMEM   LDA 0,X                 ; Prima il byte basso
        STA MEMSIZ
        LDA 1,X                 ; poi quello alto
        STA MEMSIZ+1

        JSR CLEAR               ; Esegui il comando CLR per aggiustare tutti gli altri
                                ; puntatori che dipendono da MEMSIZ
        RTS

; Titolo:                 Resetta HIBASE dopo RUN/STOP + RESTORE
; Nome:                   NMIHIB
; Scopo:                  Dopo un RUN/STOP + RESTORE il VIC viene riconfigurato con i valori di default
;                         salvo che la variabile di sistema HIBASE non viene reinizializzata; questa
;                         routine risolve il problema inserendosi nella routine di interrupt NMI
; Parametri di ingresso:  Nessuno
; Parametri di uscita:    Nessuno
; Registri alterati:      A
; Puntatori zp alterati:  Nessuno
; Temporanei alterati:    Nessuno
; Dipendenze esterne:     Nessuna

NMIHIB  LDA NMINV               ; Salva il vettore NMI originale
        STA OLDNMI
        LDA NMINV+1
        STA OLDNMI+1

        LDA #<NEWNMI            ; e sostituiscilo col nuovo
        STA NMINV
        LDA #>NEWNMI
        STA NMINV+1

        RTS

; Titolo:                 Ripristina il vettore NMI originale
; Nome:                   NMIRES
; Scopo:                  Questa routine ripristina il vettore NMI originale annullando
;                         le modifiche apportate da NMIHIB
; Parametri di ingresso:  Nessuno
; Parametri di uscita:    Nessuno
; Registri alterati:      A
; Puntatori zp alterati:  Nessuno
; Temporanei alterati:    Nessuno
; Dipendenze esterne:     Nessuna

NMIRES  LDA OLDNMI              ; e sostituiscilo col nuovo
        STA NMINV
        LDA OLDNMI+1
        STA NMINV+1

        RTS

; Titolo:                 Ripristina il valore di default di HIBASE
; Nome:                   NEWNMI
; Scopo:                  Questa routine ripristina il valore di default di HIBASE
;                         per poi proseguire con la normale routine di NMI
; Parametri di ingresso:  Nessuno
; Parametri di uscita:    Nessuno
; Registri alterati:      Nessuno
; Puntatori zp alterati:  Nessuno
; Temporanei alterati:    Nessuno
; Dipendenze esterne:     Nessuna

NEWNMI  PHA                     ; Salva i flag e l'accumulatore sullo stack
        LDA #4                  ; Resetta l'inizio della memoria schermo a 1024
        STA HIBASE
        PLA                     ; Recupera l'accumulatore e i flag dallo stack
        JMP (OLDNMI)            ; Esegui la normale routine interrupt NMI
