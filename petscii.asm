; ==============================================================================
; FILE:           petscii.asm
; PROGETTO:       Libreria di Sistema (c64.c64)
; TARGET:         ACME Assembler / MOS 6510 (Commodore 64)
; DESCRIZIONE:    Codici PETSCII, indicati con simboli PETSCII_<descrizione>, e
;                 codici per la selezione del colore di sfondo nella stampa in
;                 modo ECM (da ECM_BG0 a ECM_BG3).
; ==============================================================================

; ------------------------------------------------------------------------------
; Codici PETSCII per la selezione del colore di sfondo nella stampa in modo ECM
; ------------------------------------------------------------------------------

ECM_BG0                         = $01 ; Colore di sfondo #0
ECM_BG1                         = $02 ; Colore di sfondo #1
ECM_BG2                         = $03 ; Colore di sfondo #2
ECM_BG3                         = $04 ; Colore di sfondo #3

; ------------------------------------------------------------------------------
; Blocco 0 (0-31)
; ------------------------------------------------------------------------------

PETSCII_NULL                    = $00 ; Carattere nullo
PETSCII_CTRL_A                  = $01
PETSCII_CTRL_B                  = $02
PETSCII_STOP                    = $03 ; Tasto RUN/STOP
PETSCII_CTRL_D                  = $04
PETSCII_WHITE                   = $05 ; Colore di primo piano: bianco
PETSCII_CTRL_F                  = $06
PETSCII_CTRL_G                  = $07
PETSCII_DISABLE_SHIFT_COMMODORE = $08 ; Disabilita il cambio del set di caratteri con SHIFT+COMMODORE
PETSCII_ENABLE_SHIFT_COMMODORE  = $09 ; Abilita il cambio del set di caratteri con SHIFT+COMMODORE
PETSCII_CTRL_J                  = $0A
PETSCII_CTRL_K                  = $0B
PETSCII_CTRL_L                  = $0C
PETSCII_RETURN                  = $0D ; A capo (tasto RETURN)
PETSCII_LOWERCASE               = $0E ; Seleziona il set di caratteri minuscolo
PETSCII_CTRL_O                  = $0F
PETSCII_CTRL_P                  = $10
PETSCII_CURSOR_DOWN             = $11 ; Sposta il cursore in basso
PETSCII_REVERSE_ON              = $12 ; Attiva il modo inverso
PETSCII_HOME                    = $13 ; Porta il cursore in alto a sinistra
PETSCII_DELETE                  = $14 ; Cancella il carattere a sinistra del cursore
PETSCII_CTRL_U                  = $15
PETSCII_CTRL_V                  = $16
PETSCII_CTRL_W                  = $17
PETSCII_CTRL_X                  = $18
PETSCII_CTRL_Y                  = $19
PETSCII_CTRL_Z                  = $1A
PETSCII_CTRL_LEFT_BRACKET       = $1B
PETSCII_RED                     = $1C ; Colore di primo piano: rosso
PETSCII_CURSOR_RIGHT            = $1D ; Sposta il cursore a destra
PETSCII_GREEN                   = $1E ; Colore di primo piano: verde
PETSCII_BLUE                    = $1F ; Colore di primo piano: blu

; ------------------------------------------------------------------------------
; Blocco 1 (32-63)
; ------------------------------------------------------------------------------

PETSCII_SPACE                   = $20
PETSCII_EXCLAMATION_MARK        = $21
PETSCII_QUOTATION_MARK          = $22
PETSCII_NUMBER_SIGN             = $23
PETSCII_DOLLAR_SIGN             = $24
PETSCII_PERCENT_SIGN            = $25
PETSCII_AMPERSAND               = $26
PETSCII_APOSTROPHE              = $27
PETSCII_LEFT_PARENTHESIS        = $28
PETSCII_RIGHT_PARENTHESIS       = $29
PETSCII_ASTERISK                = $2A
PETSCII_PLUS                    = $2B
PETSCII_COMMA                   = $2C
PETSCII_MINUS                   = $2D
PETSCII_FULL_STOP               = $2E
PETSCII_SLASH                   = $2F
PETSCII_DIGIT_0                 = $30
PETSCII_DIGIT_1                 = $31
PETSCII_DIGIT_2                 = $32
PETSCII_DIGIT_3                 = $33
PETSCII_DIGIT_4                 = $34
PETSCII_DIGIT_5                 = $35
PETSCII_DIGIT_6                 = $36
PETSCII_DIGIT_7                 = $37
PETSCII_DIGIT_8                 = $38
PETSCII_DIGIT_9                 = $39
PETSCII_COLON                   = $3A
PETSCII_SEMICOLON               = $3B
PETSCII_LESS_THAN_SIGN          = $3C
PETSCII_EQUALS                  = $3D
PETSCII_GREATER_THAN_SIGN       = $3E
PETSCII_QUESTION_MARK           = $3F

; ------------------------------------------------------------------------------
; Blocco 2 (64-95)
; ------------------------------------------------------------------------------

PETSCII_AT_SIGN                 = $40
PETSCII_LETTER_A                = $41
PETSCII_LETTER_B                = $42
PETSCII_LETTER_C                = $43
PETSCII_LETTER_D                = $44
PETSCII_LETTER_E                = $45
PETSCII_LETTER_F                = $46
PETSCII_LETTER_G                = $47
PETSCII_LETTER_H                = $48
PETSCII_LETTER_I                = $49
PETSCII_LETTER_J                = $4A
PETSCII_LETTER_K                = $4B
PETSCII_LETTER_L                = $4C
PETSCII_LETTER_M                = $4D
PETSCII_LETTER_N                = $4E
PETSCII_LETTER_O                = $4F
PETSCII_LETTER_P                = $50
PETSCII_LETTER_Q                = $51
PETSCII_LETTER_R                = $52
PETSCII_LETTER_S                = $53
PETSCII_LETTER_T                = $54
PETSCII_LETTER_U                = $55
PETSCII_LETTER_V                = $56
PETSCII_LETTER_W                = $57
PETSCII_LETTER_X                = $58
PETSCII_LETTER_Y                = $59
PETSCII_LETTER_Z                = $5A
PETSCII_LEFT_BRACKET            = $5B
PETSCII_POUND                   = $5C ; Tasto sterlina; U+00A3 POUND SIGN
PETSCII_RIGHT_BRACKET           = $5D
PETSCII_UP_ARROW                = $5E ; Tasto freccia in su; U+2191 UPWARDS ARROW
PETSCII_LEFT_ARROW              = $5F ; Tasto freccia a sinistra; U+2190 LEFTWARDS ARROW

; ------------------------------------------------------------------------------
; Blocco 3 (96-127)
; ------------------------------------------------------------------------------

PETSCII_SHIFT_ASTERISK_ALT      = $60 ; Duplicato di PETSCII_SHIFT_ASTERISK; U+2500 BOX DRAWINGS LIGHT HORIZONTAL
PETSCII_SHIFT_A_ALT             = $61 ; Duplicato di PETSCII_SHIFT_A; U+2660 BLACK SPADE SUIT (set 1)
PETSCII_SHIFT_B_ALT             = $62 ; Duplicato di PETSCII_SHIFT_B; U+1FB72 VERTICAL ONE EIGHTH BLOCK-4 (set 1)
PETSCII_SHIFT_C_ALT             = $63 ; Duplicato di PETSCII_SHIFT_C; U+1FB78 HORIZONTAL ONE EIGHTH BLOCK-4 (set 1)
PETSCII_SHIFT_D_ALT             = $64 ; Duplicato di PETSCII_SHIFT_D; U+1FB77 HORIZONTAL ONE EIGHTH BLOCK-3 (set 1)
PETSCII_SHIFT_E_ALT             = $65 ; Duplicato di PETSCII_SHIFT_E; U+1FB76 HORIZONTAL ONE EIGHTH BLOCK-2 (set 1)
PETSCII_SHIFT_F_ALT             = $66 ; Duplicato di PETSCII_SHIFT_F; U+1FB7A HORIZONTAL ONE EIGHTH BLOCK-6 (set 1)
PETSCII_SHIFT_G_ALT             = $67 ; Duplicato di PETSCII_SHIFT_G; U+1FB71 VERTICAL ONE EIGHTH BLOCK-3 (set 1)
PETSCII_SHIFT_H_ALT             = $68 ; Duplicato di PETSCII_SHIFT_H; U+1FB74 VERTICAL ONE EIGHTH BLOCK-6 (set 1)
PETSCII_SHIFT_I_ALT             = $69 ; Duplicato di PETSCII_SHIFT_I; U+256E BOX DRAWINGS LIGHT ARC DOWN AND LEFT (set 1)
PETSCII_SHIFT_J_ALT             = $6A ; Duplicato di PETSCII_SHIFT_J; U+2570 BOX DRAWINGS LIGHT ARC UP AND RIGHT (set 1)
PETSCII_SHIFT_K_ALT             = $6B ; Duplicato di PETSCII_SHIFT_K; U+256F BOX DRAWINGS LIGHT ARC UP AND LEFT (set 1)
PETSCII_SHIFT_L_ALT             = $6C ; Duplicato di PETSCII_SHIFT_L; U+1FB7C LEFT AND LOWER ONE EIGHTH BLOCK (set 1)
PETSCII_SHIFT_M_ALT             = $6D ; Duplicato di PETSCII_SHIFT_M; U+2572 BOX DRAWINGS LIGHT DIAGONAL UPPER LEFT TO LOWER RIGHT (set 1)
PETSCII_SHIFT_N_ALT             = $6E ; Duplicato di PETSCII_SHIFT_N; U+2571 BOX DRAWINGS LIGHT DIAGONAL UPPER RIGHT TO LOWER LEFT (set 1)
PETSCII_SHIFT_O_ALT             = $6F ; Duplicato di PETSCII_SHIFT_O; U+1FB7D LEFT AND UPPER ONE EIGHTH BLOCK (set 1)
PETSCII_SHIFT_P_ALT             = $70 ; Duplicato di PETSCII_SHIFT_P; U+1FB7E RIGHT AND UPPER ONE EIGHTH BLOCK (set 1)
PETSCII_SHIFT_Q_ALT             = $71 ; Duplicato di PETSCII_SHIFT_Q; U+2022 BULLET (set 1)
PETSCII_SHIFT_R_ALT             = $72 ; Duplicato di PETSCII_SHIFT_R; U+1FB7B HORIZONTAL ONE EIGHTH BLOCK-7 (set 1)
PETSCII_SHIFT_S_ALT             = $73 ; Duplicato di PETSCII_SHIFT_S; U+2665 BLACK HEART SUIT (set 1)
PETSCII_SHIFT_T_ALT             = $74 ; Duplicato di PETSCII_SHIFT_T; U+1FB70 VERTICAL ONE EIGHTH BLOCK-2 (set 1)
PETSCII_SHIFT_U_ALT             = $75 ; Duplicato di PETSCII_SHIFT_U; U+256D BOX DRAWINGS LIGHT ARC DOWN AND RIGHT (set 1)
PETSCII_SHIFT_V_ALT             = $76 ; Duplicato di PETSCII_SHIFT_V; U+2573 BOX DRAWINGS LIGHT DIAGONAL CROSS (set 1)
PETSCII_SHIFT_W_ALT             = $77 ; Duplicato di PETSCII_SHIFT_W; U+25CB WHITE CIRCLE (set 1)
PETSCII_SHIFT_X_ALT             = $78 ; Duplicato di PETSCII_SHIFT_X; U+2663 BLACK CLUB SUIT (set 1)
PETSCII_SHIFT_Y_ALT             = $79 ; Duplicato di PETSCII_SHIFT_Y; U+1FB75 VERTICAL ONE EIGHTH BLOCK-7 (set 1)
PETSCII_SHIFT_Z_ALT             = $7A ; Duplicato di PETSCII_SHIFT_Z; U+2666 BLACK DIAMOND SUIT (set 1)
PETSCII_SHIFT_PLUS_ALT          = $7B ; Duplicato di PETSCII_SHIFT_PLUS; U+253C BOX DRAWINGS LIGHT VERTICAL AND HORIZONTAL
PETSCII_COMMODORE_MINUS_ALT     = $7C ; Duplicato di PETSCII_COMMODORE_MINUS; U+1FB8C LEFT HALF MEDIUM SHADE
PETSCII_SHIFT_MINUS_ALT         = $7D ; Duplicato di PETSCII_SHIFT_MINUS; U+2502 BOX DRAWINGS LIGHT VERTICAL
PETSCII_SHIFT_UP_ARROW_ALT      = $7E ; Duplicato di PETSCII_SHIFT_UP_ARROW; U+03C0 GREEK SMALL LETTER PI (set 1)
PETSCII_COMMODORE_ASTERISK_ALT  = $7F ; Duplicato di PETSCII_COMMODORE_ASTERISK; U+25E5 BLACK UPPER RIGHT TRIANGLE (set 1)

; ------------------------------------------------------------------------------
; Blocco 4 (128-159)
; ------------------------------------------------------------------------------

PETSCII_CTRL_SHIFT_AT_SIGN      = $80
PETSCII_ORANGE                  = $81 ; Colore di primo piano: arancione
PETSCII_CTRL_SHIFT_B            = $82
PETSCII_RUN                     = $83 ; Tasto SHIFT+RUN/STOP
PETSCII_CTRL_SHIFT_D            = $84
PETSCII_F1                      = $85 ; Tasto funzione F1
PETSCII_F3                      = $86 ; Tasto funzione F3
PETSCII_F5                      = $87 ; Tasto funzione F5
PETSCII_F7                      = $88 ; Tasto funzione F7
PETSCII_F2                      = $89 ; Tasto funzione F2
PETSCII_F4                      = $8A ; Tasto funzione F4
PETSCII_F6                      = $8B ; Tasto funzione F6
PETSCII_F8                      = $8C ; Tasto funzione F8
PETSCII_SHIFT_RETURN            = $8D ; A capo (tasto SHIFT+RETURN)
PETSCII_UPPERCASE               = $8E ; Seleziona il set di caratteri maiuscolo
PETSCII_CTRL_SHIFT_O            = $8F
PETSCII_BLACK                   = $90 ; Colore di primo piano: nero
PETSCII_CURSOR_UP               = $91 ; Sposta il cursore in alto
PETSCII_REVERSE_OFF             = $92 ; Disattiva il modo inverso
PETSCII_CLEAR_SCREEN            = $93 ; Cancella lo schermo e porta il cursore in alto a sinistra
PETSCII_INSERT                  = $94 ; Inserisce uno spazio nella posizione del cursore
PETSCII_BROWN                   = $95 ; Colore di primo piano: marrone
PETSCII_LIGHT_RED               = $96 ; Colore di primo piano: rosso chiaro
PETSCII_DARK_GREY               = $97 ; Colore di primo piano: grigio scuro
PETSCII_MEDIUM_GREY             = $98 ; Colore di primo piano: grigio medio
PETSCII_LIGHT_GREEN             = $99 ; Colore di primo piano: verde chiaro
PETSCII_LIGHT_BLUE              = $9A ; Colore di primo piano: blu chiaro
PETSCII_LIGHT_GREY              = $9B ; Colore di primo piano: grigio chiaro
PETSCII_PURPLE                  = $9C ; Colore di primo piano: viola
PETSCII_CURSOR_LEFT             = $9D ; Sposta il cursore a sinistra
PETSCII_YELLOW                  = $9E ; Colore di primo piano: giallo
PETSCII_CYAN                    = $9F ; Colore di primo piano: ciano

; ------------------------------------------------------------------------------
; Blocco 5 (160-191)
; ------------------------------------------------------------------------------

PETSCII_SHIFT_SPACE             = $A0 ; U+0020 SPACE
PETSCII_COMMODORE_K             = $A1 ; U+258C LEFT HALF BLOCK
PETSCII_COMMODORE_I             = $A2 ; U+2584 LOWER HALF BLOCK
PETSCII_COMMODORE_T             = $A3 ; U+2594 UPPER ONE EIGHTH BLOCK
PETSCII_COMMODORE_AT_SIGN       = $A4 ; U+2581 LOWER ONE EIGHTH BLOCK
PETSCII_COMMODORE_G             = $A5 ; U+258F LEFT ONE EIGHTH BLOCK
PETSCII_COMMODORE_PLUS          = $A6 ; U+2592 MEDIUM SHADE
PETSCII_COMMODORE_M             = $A7 ; U+2595 RIGHT ONE EIGHTH BLOCK
PETSCII_COMMODORE_POUND         = $A8 ; U+1FB8F LOWER HALF MEDIUM SHADE
PETSCII_SHIFT_POUND             = $A9 ; U+25E4 BLACK UPPER LEFT TRIANGLE (set 1)
PETSCII_COMMODORE_N             = $AA ; U+1FB87 RIGHT ONE QUARTER BLOCK
PETSCII_COMMODORE_Q             = $AB ; U+251C BOX DRAWINGS LIGHT VERTICAL AND RIGHT
PETSCII_COMMODORE_D             = $AC ; U+2597 QUADRANT LOWER RIGHT
PETSCII_COMMODORE_Z             = $AD ; U+2514 BOX DRAWINGS LIGHT UP AND RIGHT
PETSCII_COMMODORE_S             = $AE ; U+2510 BOX DRAWINGS LIGHT DOWN AND LEFT
PETSCII_COMMODORE_P             = $AF ; U+2582 LOWER ONE QUARTER BLOCK
PETSCII_COMMODORE_A             = $B0 ; U+250C BOX DRAWINGS LIGHT DOWN AND RIGHT
PETSCII_COMMODORE_E             = $B1 ; U+2534 BOX DRAWINGS LIGHT UP AND HORIZONTAL
PETSCII_COMMODORE_R             = $B2 ; U+252C BOX DRAWINGS LIGHT DOWN AND HORIZONTAL
PETSCII_COMMODORE_W             = $B3 ; U+2524 BOX DRAWINGS LIGHT VERTICAL AND LEFT
PETSCII_COMMODORE_H             = $B4 ; U+258E LEFT ONE QUARTER BLOCK
PETSCII_COMMODORE_J             = $B5 ; U+258D LEFT THREE EIGHTHS BLOCK
PETSCII_COMMODORE_L             = $B6 ; U+1FB88 RIGHT THREE EIGHTHS BLOCK
PETSCII_COMMODORE_Y             = $B7 ; U+1FB82 UPPER ONE QUARTER BLOCK
PETSCII_COMMODORE_U             = $B8 ; U+1FB83 UPPER THREE EIGHTHS BLOCK
PETSCII_COMMODORE_O             = $B9 ; U+2583 LOWER THREE EIGHTHS BLOCK
PETSCII_SHIFT_AT_SIGN           = $BA ; U+1FB7F RIGHT AND LOWER ONE EIGHTH BLOCK (set 1)
PETSCII_COMMODORE_F             = $BB ; U+2596 QUADRANT LOWER LEFT
PETSCII_COMMODORE_C             = $BC ; U+259D QUADRANT UPPER RIGHT
PETSCII_COMMODORE_X             = $BD ; U+2518 BOX DRAWINGS LIGHT UP AND LEFT
PETSCII_COMMODORE_V             = $BE ; U+2598 QUADRANT UPPER LEFT
PETSCII_COMMODORE_B             = $BF ; U+259A QUADRANT UPPER LEFT AND LOWER RIGHT

; ------------------------------------------------------------------------------
; Blocco 6 (192-223)
; ------------------------------------------------------------------------------

PETSCII_SHIFT_ASTERISK          = $C0 ; U+2500 BOX DRAWINGS LIGHT HORIZONTAL
PETSCII_SHIFT_A                 = $C1 ; U+2660 BLACK SPADE SUIT (set 1)
PETSCII_SHIFT_B                 = $C2 ; U+1FB72 VERTICAL ONE EIGHTH BLOCK-4 (set 1)
PETSCII_SHIFT_C                 = $C3 ; U+1FB78 HORIZONTAL ONE EIGHTH BLOCK-4 (set 1)
PETSCII_SHIFT_D                 = $C4 ; U+1FB77 HORIZONTAL ONE EIGHTH BLOCK-3 (set 1)
PETSCII_SHIFT_E                 = $C5 ; U+1FB76 HORIZONTAL ONE EIGHTH BLOCK-2 (set 1)
PETSCII_SHIFT_F                 = $C6 ; U+1FB7A HORIZONTAL ONE EIGHTH BLOCK-6 (set 1)
PETSCII_SHIFT_G                 = $C7 ; U+1FB71 VERTICAL ONE EIGHTH BLOCK-3 (set 1)
PETSCII_SHIFT_H                 = $C8 ; U+1FB74 VERTICAL ONE EIGHTH BLOCK-6 (set 1)
PETSCII_SHIFT_I                 = $C9 ; U+256E BOX DRAWINGS LIGHT ARC DOWN AND LEFT (set 1)
PETSCII_SHIFT_J                 = $CA ; U+2570 BOX DRAWINGS LIGHT ARC UP AND RIGHT (set 1)
PETSCII_SHIFT_K                 = $CB ; U+256F BOX DRAWINGS LIGHT ARC UP AND LEFT (set 1)
PETSCII_SHIFT_L                 = $CC ; U+1FB7C LEFT AND LOWER ONE EIGHTH BLOCK (set 1)
PETSCII_SHIFT_M                 = $CD ; U+2572 BOX DRAWINGS LIGHT DIAGONAL UPPER LEFT TO LOWER RIGHT (set 1)
PETSCII_SHIFT_N                 = $CE ; U+2571 BOX DRAWINGS LIGHT DIAGONAL UPPER RIGHT TO LOWER LEFT (set 1)
PETSCII_SHIFT_O                 = $CF ; U+1FB7D LEFT AND UPPER ONE EIGHTH BLOCK (set 1)
PETSCII_SHIFT_P                 = $D0 ; U+1FB7E RIGHT AND UPPER ONE EIGHTH BLOCK (set 1)
PETSCII_SHIFT_Q                 = $D1 ; U+2022 BULLET (set 1)
PETSCII_SHIFT_R                 = $D2 ; U+1FB7B HORIZONTAL ONE EIGHTH BLOCK-7 (set 1)
PETSCII_SHIFT_S                 = $D3 ; U+2665 BLACK HEART SUIT (set 1)
PETSCII_SHIFT_T                 = $D4 ; U+1FB70 VERTICAL ONE EIGHTH BLOCK-2 (set 1)
PETSCII_SHIFT_U                 = $D5 ; U+256D BOX DRAWINGS LIGHT ARC DOWN AND RIGHT (set 1)
PETSCII_SHIFT_V                 = $D6 ; U+2573 BOX DRAWINGS LIGHT DIAGONAL CROSS (set 1)
PETSCII_SHIFT_W                 = $D7 ; U+25CB WHITE CIRCLE (set 1)
PETSCII_SHIFT_X                 = $D8 ; U+2663 BLACK CLUB SUIT (set 1)
PETSCII_SHIFT_Y                 = $D9 ; U+1FB75 VERTICAL ONE EIGHTH BLOCK-7 (set 1)
PETSCII_SHIFT_Z                 = $DA ; U+2666 BLACK DIAMOND SUIT (set 1)
PETSCII_SHIFT_PLUS              = $DB ; U+253C BOX DRAWINGS LIGHT VERTICAL AND HORIZONTAL
PETSCII_COMMODORE_MINUS         = $DC ; U+1FB8C LEFT HALF MEDIUM SHADE
PETSCII_SHIFT_MINUS             = $DD ; U+2502 BOX DRAWINGS LIGHT VERTICAL
PETSCII_SHIFT_UP_ARROW_ALT_2    = $DE ; Duplicato di PETSCII_SHIFT_UP_ARROW; U+03C0 GREEK SMALL LETTER PI (set 1)
PETSCII_COMMODORE_ASTERISK      = $DF ; U+25E5 BLACK UPPER RIGHT TRIANGLE (set 1)

; ------------------------------------------------------------------------------
; Blocco 7 (224-255)
; ------------------------------------------------------------------------------

PETSCII_SHIFT_SPACE_ALT         = $E0 ; Duplicato di PETSCII_SHIFT_SPACE; U+0020 SPACE
PETSCII_COMMODORE_K_ALT         = $E1 ; Duplicato di PETSCII_COMMODORE_K; U+258C LEFT HALF BLOCK
PETSCII_COMMODORE_I_ALT         = $E2 ; Duplicato di PETSCII_COMMODORE_I; U+2584 LOWER HALF BLOCK
PETSCII_COMMODORE_T_ALT         = $E3 ; Duplicato di PETSCII_COMMODORE_T; U+2594 UPPER ONE EIGHTH BLOCK
PETSCII_COMMODORE_AT_SIGN_ALT   = $E4 ; Duplicato di PETSCII_COMMODORE_AT_SIGN; U+2581 LOWER ONE EIGHTH BLOCK
PETSCII_COMMODORE_G_ALT         = $E5 ; Duplicato di PETSCII_COMMODORE_G; U+258F LEFT ONE EIGHTH BLOCK
PETSCII_COMMODORE_PLUS_ALT      = $E6 ; Duplicato di PETSCII_COMMODORE_PLUS; U+2592 MEDIUM SHADE
PETSCII_COMMODORE_M_ALT         = $E7 ; Duplicato di PETSCII_COMMODORE_M; U+2595 RIGHT ONE EIGHTH BLOCK
PETSCII_COMMODORE_POUND_ALT     = $E8 ; Duplicato di PETSCII_COMMODORE_POUND; U+1FB8F LOWER HALF MEDIUM SHADE
PETSCII_SHIFT_POUND_ALT         = $E9 ; Duplicato di PETSCII_SHIFT_POUND; U+25E4 BLACK UPPER LEFT TRIANGLE (set 1)
PETSCII_COMMODORE_N_ALT         = $EA ; Duplicato di PETSCII_COMMODORE_N; U+1FB87 RIGHT ONE QUARTER BLOCK
PETSCII_COMMODORE_Q_ALT         = $EB ; Duplicato di PETSCII_COMMODORE_Q; U+251C BOX DRAWINGS LIGHT VERTICAL AND RIGHT
PETSCII_COMMODORE_D_ALT         = $EC ; Duplicato di PETSCII_COMMODORE_D; U+2597 QUADRANT LOWER RIGHT
PETSCII_COMMODORE_Z_ALT         = $ED ; Duplicato di PETSCII_COMMODORE_Z; U+2514 BOX DRAWINGS LIGHT UP AND RIGHT
PETSCII_COMMODORE_S_ALT         = $EE ; Duplicato di PETSCII_COMMODORE_S; U+2510 BOX DRAWINGS LIGHT DOWN AND LEFT
PETSCII_COMMODORE_P_ALT         = $EF ; Duplicato di PETSCII_COMMODORE_P; U+2582 LOWER ONE QUARTER BLOCK
PETSCII_COMMODORE_A_ALT         = $F0 ; Duplicato di PETSCII_COMMODORE_A; U+250C BOX DRAWINGS LIGHT DOWN AND RIGHT
PETSCII_COMMODORE_E_ALT         = $F1 ; Duplicato di PETSCII_COMMODORE_E; U+2534 BOX DRAWINGS LIGHT UP AND HORIZONTAL
PETSCII_COMMODORE_R_ALT         = $F2 ; Duplicato di PETSCII_COMMODORE_R; U+252C BOX DRAWINGS LIGHT DOWN AND HORIZONTAL
PETSCII_COMMODORE_W_ALT         = $F3 ; Duplicato di PETSCII_COMMODORE_W; U+2524 BOX DRAWINGS LIGHT VERTICAL AND LEFT
PETSCII_COMMODORE_H_ALT         = $F4 ; Duplicato di PETSCII_COMMODORE_H; U+258E LEFT ONE QUARTER BLOCK
PETSCII_COMMODORE_J_ALT         = $F5 ; Duplicato di PETSCII_COMMODORE_J; U+258D LEFT THREE EIGHTHS BLOCK
PETSCII_COMMODORE_L_ALT         = $F6 ; Duplicato di PETSCII_COMMODORE_L; U+1FB88 RIGHT THREE EIGHTHS BLOCK
PETSCII_COMMODORE_Y_ALT         = $F7 ; Duplicato di PETSCII_COMMODORE_Y; U+1FB82 UPPER ONE QUARTER BLOCK
PETSCII_COMMODORE_U_ALT         = $F8 ; Duplicato di PETSCII_COMMODORE_U; U+1FB83 UPPER THREE EIGHTHS BLOCK
PETSCII_COMMODORE_O_ALT         = $F9 ; Duplicato di PETSCII_COMMODORE_O; U+2583 LOWER THREE EIGHTHS BLOCK
PETSCII_SHIFT_AT_SIGN_ALT       = $FA ; Duplicato di PETSCII_SHIFT_AT_SIGN; U+1FB7F RIGHT AND LOWER ONE EIGHTH BLOCK (set 1)
PETSCII_COMMODORE_F_ALT         = $FB ; Duplicato di PETSCII_COMMODORE_F; U+2596 QUADRANT LOWER LEFT
PETSCII_COMMODORE_C_ALT         = $FC ; Duplicato di PETSCII_COMMODORE_C; U+259D QUADRANT UPPER RIGHT
PETSCII_COMMODORE_X_ALT         = $FD ; Duplicato di PETSCII_COMMODORE_X; U+2518 BOX DRAWINGS LIGHT UP AND LEFT
PETSCII_COMMODORE_V_ALT         = $FE ; Duplicato di PETSCII_COMMODORE_V; U+2598 QUADRANT UPPER LEFT
PETSCII_SHIFT_UP_ARROW          = $FF ; Codice letto dal Kernal per il pigreco; U+03C0 GREEK SMALL LETTER PI (set 1)
