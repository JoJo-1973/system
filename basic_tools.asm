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
