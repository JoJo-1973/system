; Macro per salti in caso di confronti tra valori con segno e privi di segno

; Titolo:                 MACRO: Salta sempre
; Nome:                   Bra
; Descrizione:            Sfruttando il fatto che il flag V è raramente utilizzato lo si può utilizzare per forzare un salto relativo.
; Parametri di ingresso:  addr_: Indirizzo di destinazione del salto relativo
; Parametri di uscita:    ---
; Alterazioni registri:   ---
; Alterazioni pag. zero:  ---
; Dipendenze esterne:     ---
!macro Bra addr_ {
  clv
  bvc addr_
}

; Titolo:                 MACRO: Salta mai
; Nome:                   Brn
; Descrizione:            A volte per motivi di chiarezza e/o dcoumentazione si vuole esplicitare il fatto che un salto relativo NON viene MAI eseguito.
; Parametri di ingresso:  addr_: Indirizzo di destinazione del salto relativo
; Parametri di uscita:    ---
; Alterazioni registri:   ---
; Alterazioni pag. zero:  ---
; Dipendenze esterne:     ---
!macro Brn addr_ {
  nop                           ; Spreca due byte e quattro cicli.
  nop
}

; Titolo:                 MACRO: Salta se più alto
; Nome:                   Bhi
; Descrizione:            Salta se dopo una comparazione (C && !Z) è 1, in altre parole se .A > M (confronto tra numeri privi di segno).
; Parametri di ingresso:  addr_: Indirizzo di destinazione del salto relativo
; Parametri di uscita:    ---
; Alterazioni registri:   ---
; Alterazioni pag. zero:  ---
; Dipendenze esterne:     ---
!macro Bhi addr_ {
  beq +                         ; Z = 0? Test non passato.
  bcs addr_                     ; Z = 1? Se anche C = 1 allora test passato,
+                               ; altrimenti test non passato
}

; Titolo:                 MACRO: Salta se più alto o lo stesso
; Nome:                   Bhs
; Descrizione:            Salta se dopo una comparazione C è 1, in altre parole se .A >= M (confronto tra numeri privi di segno).
;                         Alias di BCS.
; Parametri di ingresso:  addr_: Indirizzo di destinazione del salto relativo
; Parametri di uscita:    ---
; Alterazioni registri:   ---
; Alterazioni pag. zero:  ---
; Dipendenze esterne:     ---
!macro Bhs addr_ {
  bcs addr_                     ; C = 1? Test passato.
}

; Titolo:                 MACRO: Salta se più basso
; Nome:                   Blo
; Descrizione:            Salta se dopo una comparazione !C è 1, in altre parole se .A < M (confronto tra numeri privi di segno).
;                         Alias di BCC.
; Parametri di ingresso:  addr_: Indirizzo di destinazione del salto relativo
; Parametri di uscita:    ---
; Alterazioni registri:   ---
; Alterazioni pag. zero:  ---
; Dipendenze esterne:     ---
!macro Blo addr_ {
  bcc addr_                     ; C = 0? Test passato.
}

; Titolo:                 MACRO: Salta se più basso o lo stesso
; Nome:                   Bls
; Descrizione:            Salta se dopo una comparazione (!C || Z) è 1, in altre parole se .A <= M (confronto tra numeri privi di segno).
; Parametri di ingresso:  addr_: Indirizzo di destinazione del salto relativo
; Parametri di uscita:    ---
; Alterazioni registri:   ---
; Alterazioni pag. zero:  ---
; Dipendenze esterne:     ---
!macro Bls addr_ {
  bcc addr_                     ; C = 0? Test passato.
  beq addr_                     ; Z = 0? Test passato.
}

; Titolo:                 MACRO: Salta se maggiore
; Nome:                   Bgt
; Descrizione:            Salta se dopo una comparazione (!Z && N == V) è 1, in altre parole se .A > M (confronto tra numeri con segno).
; Parametri di ingresso:  addr_: Indirizzo di destinazione del salto relativo
; Parametri di uscita:    ---
; Alterazioni registri:   ---
; Alterazioni pag. zero:  ---
; Dipendenze esterne:     ---
!macro Bgt addr_ {
  beq ++                        ; Z = 0? Test non passato.
  bmi +                         ; N = 1? Controlla se V = 1.
  bvc addr_                     ; N = 0? Se anche V = 0 allora test passato,
  bvs ++                        ; ma se V = 1 allora test non passato.
+ bvs addr_                     ; N = 1: se anche .V = 1 allora test passato,
++                              ; altrimenti test non passato.
}

; Titolo:                 MACRO: Salta se maggiore o uguale
; Nome:                   Bge
; Descrizione:            Salta se dopo una comparazione (N == V) è 1, in altre parole se .A >= M (confronto tra numeri con segno).
; Parametri di ingresso:  addr_: Indirizzo di destinazione del salto relativo
; Parametri di uscita:    ---
; Alterazioni registri:   ---
; Alterazioni pag. zero:  ---
; Dipendenze esterne:     ---
!macro Bge addr_ {
  bmi +                         ; N = 1? Controlla se V = 1
  bvc addr_                     ; N = 0? Se anche V = 0 allora test passato,
  bvs ++                        ; ma se V = 1 allora test non passato.
+ bvs addr_                     ; N = 1: se anche V = 1 allora test passato,
++                              ; altrimenti test non passato.
}

; Titolo:                 MACRO: Salta se minore
; Nome:                   Blt
; Descrizione:            Salta se dopo una comparazione (N != V) è 1, in altre parole se .A < M (confronto tra numeri con segno).
; Parametri di ingresso:  addr_: Indirizzo di destinazione del salto relativo
; Parametri di uscita:    ---
; Alterazioni registri:   ---
; Alterazioni pag. zero:  ---
; Dipendenze esterne:     ---
!macro Blt addr_ {
  bpl +                         ; N = 0? Controlla se V = 1.
  bvc addr_                     ; N = 1? Se V = 0 allora test passato,
  bvs ++                        ; ma se V = 1 allora test non passato.
+ bvs addr_                     ; N = 0: se V = 1 allora test passato,
++                              ; altrimenti test non passato.
}

; Titolo:                 MACRO: Salta se minore o uguale
; Nome:                   Ble
; Descrizione:            Salta se dopo una comparazione (Z || N != V) è 1, in altre parole se .A <= M (confronto tra numeri con segno).
; Parametri di ingresso:  addr_: Indirizzo di destinazione del salto relativo
; Parametri di uscita:    ---
; Alterazioni registri:   ---
; Alterazioni pag. zero:  ---
; Dipendenze esterne:     ---
!macro Ble addr_ {
  beq addr_                     ; Z = 0? Test passato.
  bpl +                         ; N = 0? Controlla se V = 1.
  bvc addr_                     ; N = 1? Se V = 0 allora test passato,
  bvs ++                        ; ma se V = 1 allora test non passato.
+ bvs addr_                     ; N = 0: se V = 1 allora test passato,
++                              ; altrimenti test non passato.
}
