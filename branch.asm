; Macro per salti  in caso di confronti tra valori con segno e privi di segno

; Titolo:                 MACRO: Salta sempre
; Nome:                   Bra
; Descrizione:            Sfruttando il fatto che il flag V è raramente utilizzato lo si può utilizzare per forzare un salto relativo.
; Parametri di ingresso:  addr: Indirizzo di destinazione del salto relativo
; Parametri di uscita:    ---
; Alterazioni registri:   ---
; Alterazioni pag. zero:  ---
; Dipendenze esterne:     ---
!macro Bra addr {
  clv
  bvc addr
}

; Titolo:                 MACRO: Salta mai
; Nome:                   Brn
; Descrizione:            A volte per motivi di chiarezza e/o dcoumentazione si vuole esplicitare il fatto che un salto relativo NON viene MAI eseguito.
; Parametri di ingresso:  addr: Indirizzo di destinazione del salto relativo
; Parametri di uscita:    ---
; Alterazioni registri:   ---
; Alterazioni pag. zero:  ---
; Dipendenze esterne:     ---
!macro Brn addr {
  nop                           ; Spreca due byte e quattro cicli
  nop
}

; Titolo:                 MACRO: Salta se più alto
; Nome:                   Bhi
; Descrizione:            Salta se dopo una comparazione (C && !Z) è 1, in altre parole se .A > M (confronto tra numeri privi di segno).
; Parametri di ingresso:  addr: Indirizzo di destinazione del salto relativo
; Parametri di uscita:    ---
; Alterazioni registri:   ---
; Alterazioni pag. zero:  ---
; Dipendenze esterne:     ---
!macro Bhi addr {
    beq +                       ; Z = 0? Test non passato
    bcs addr                    ; Z = 1? Se anche C = 1 allora test passato
+                               ; altrimenti test non passato
}

; Titolo:                 MACRO: Salta se più alto o lo stesso
; Nome:                   Bhs
; Descrizione:            Salta se dopo una comparazione C è 1, in altre parole se .A >= M (confronto tra numeri privi di segno).
;                         Alias di BCS.
; Parametri di ingresso:  addr: Indirizzo di destinazione del salto relativo
; Parametri di uscita:    ---
; Alterazioni registri:   ---
; Alterazioni pag. zero:  ---
; Dipendenze esterne:     ---
!macro Bhs addr {
  bcs addr                      ; C = 1? Test passato
}

; Titolo:                 MACRO: Salta se più basso
; Nome:                   Blo
; Descrizione:            Salta se dopo una comparazione !C è 1, in altre parole se .A < M (confronto tra numeri privi di segno).
;                         Alias di BCC.
; Parametri di ingresso:  addr: Indirizzo di destinazione del salto relativo
; Parametri di uscita:    ---
; Alterazioni registri:   ---
; Alterazioni pag. zero:  ---
; Dipendenze esterne:     ---
!macro Blo addr {
  bcc addr                      ; C = 0? Test passato
}

; Titolo:                 MACRO: Salta se più basso o lo stesso
; Nome:                   Bls
; Descrizione:            Salta se dopo una comparazione (!C || Z) è 1, in altre parole se .A <= M (confronto tra numeri privi di segno).
; Parametri di ingresso:  addr: Indirizzo di destinazione del salto relativo
; Parametri di uscita:    ---
; Alterazioni registri:   ---
; Alterazioni pag. zero:  ---
; Dipendenze esterne:     ---
!macro Bls addr {
  bcc addr                      ; C = 0? Test passato
  beq addr                      ; Z = 0? Test passato
}

; Titolo:                 MACRO: Salta se maggiore
; Nome:                   Bgt
; Descrizione:            Salta se dopo una comparazione (!Z && N == V) è 1, in altre parole se .A > M (confronto tra numeri con segno).
; Parametri di ingresso:  addr: Indirizzo di destinazione del salto relativo
; Parametri di uscita:    ---
; Alterazioni registri:   ---
; Alterazioni pag. zero:  ---
; Dipendenze esterne:     ---
!macro Bgt addr {
  beq ++                        ; Z = 0? Test non passato
  bmi +                         ; N = 1? Controlla se V = 1
  bvc addr                      ; N = 0? Se anche V = 0 allora test passato
  bvs ++                        ; ma se V = 1 allora test non passato
+ bvs addr                      ; N = 1: se anche .V = 1 allora test passato
++                              ; altrimenti test non passato
}

; Titolo:                 MACRO: Salta se maggiore o uguale
; Nome:                   Bge
; Descrizione:            Salta se dopo una comparazione (N == V) è 1, in altre parole se .A >= M (confronto tra numeri con segno).
; Parametri di ingresso:  addr: Indirizzo di destinazione del salto relativo
; Parametri di uscita:    ---
; Alterazioni registri:   ---
; Alterazioni pag. zero:  ---
; Dipendenze esterne:     ---
!macro Bge addr {
  bmi +                         ; N = 1? Controlla se V = 1
  bvc addr                      ; N = 0? Se anche V = 0 allora test passato
  bvs ++                        ; ma se V = 1 allora test non passato
+ bvs addr                      ; N = 1: se anche V = 1 allora test passato
++                              ; altrimenti test non passato
}

; Titolo:                 MACRO: Salta se minore
; Nome:                   Blt
; Descrizione:            Salta se dopo una comparazione (N != V) è 1, in altre parole se .A < M (confronto tra numeri con segno).
; Parametri di ingresso:  addr: Indirizzo di destinazione del salto relativo
; Parametri di uscita:    ---
; Alterazioni registri:   ---
; Alterazioni pag. zero:  ---
; Dipendenze esterne:     ---
!macro Blt addr {
  bpl +                         ; N = 0? Controlla se V = 1
  bvc addr                      ; N = 1? Se V = 0 allora test passato
  bvs ++                        ; ma se V = 1 allora test non passato
+ bvs addr                      ; N = 0: se V = 1 allora test passato
++                              ; altrimenti test non passato
}

; Titolo:                 MACRO: Salta se minore o uguale
; Nome:                   Ble
; Descrizione:            Salta se dopo una comparazione (Z || N != V) è 1, in altre parole se .A <= M (confronto tra numeri con segno).
; Parametri di ingresso:  addr: Indirizzo di destinazione del salto relativo
; Parametri di uscita:    ---
; Alterazioni registri:   ---
; Alterazioni pag. zero:  ---
; Dipendenze esterne:     ---
!macro Ble addr {
  beq addr                      ; Z = 0? Test passato
  bpl +                         ; N = 0? Controlla se V = 1
  bvc addr                      ; N = 1? Se V = 0 allora test passato
  bvs ++                        ; ma se V = 1 allora test non passato
+ bvs addr                      ; N = 0: se V = 1 allora test passato
++                              ; altrimenti test non passato
}