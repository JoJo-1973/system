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
