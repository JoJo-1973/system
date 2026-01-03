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
