; ==============================================================================
; FILE:           screencodes.asm
; PROGETTO:       Libreria di Sistema (c64.c64)
; TARGET:         ACME Assembler / MOS 6510 (Commodore 64)
; DESCRIZIONE:    Codici Schermo, indicati con simboli SCREEN_<descrizione>. I
;                 codici in modo inverso (128-255) hanno il suffisso _REVERSE.
; ==============================================================================

; ------------------------------------------------------------------------------
; Blocco 0 (0-31)
; ------------------------------------------------------------------------------

SCREEN_AT_SIGN                    = $00
SCREEN_LETTER_A                   = $01
SCREEN_LETTER_B                   = $02
SCREEN_LETTER_C                   = $03
SCREEN_LETTER_D                   = $04
SCREEN_LETTER_E                   = $05
SCREEN_LETTER_F                   = $06
SCREEN_LETTER_G                   = $07
SCREEN_LETTER_H                   = $08
SCREEN_LETTER_I                   = $09
SCREEN_LETTER_J                   = $0A
SCREEN_LETTER_K                   = $0B
SCREEN_LETTER_L                   = $0C
SCREEN_LETTER_M                   = $0D
SCREEN_LETTER_N                   = $0E
SCREEN_LETTER_O                   = $0F
SCREEN_LETTER_P                   = $10
SCREEN_LETTER_Q                   = $11
SCREEN_LETTER_R                   = $12
SCREEN_LETTER_S                   = $13
SCREEN_LETTER_T                   = $14
SCREEN_LETTER_U                   = $15
SCREEN_LETTER_V                   = $16
SCREEN_LETTER_W                   = $17
SCREEN_LETTER_X                   = $18
SCREEN_LETTER_Y                   = $19
SCREEN_LETTER_Z                   = $1A
SCREEN_LEFT_BRACKET               = $1B
SCREEN_POUND                      = $1C ; Tasto sterlina; U+00A3 POUND SIGN
SCREEN_RIGHT_BRACKET              = $1D
SCREEN_UP_ARROW                   = $1E ; Tasto freccia in su; U+2191 UPWARDS ARROW
SCREEN_LEFT_ARROW                 = $1F ; Tasto freccia a sinistra; U+2190 LEFTWARDS ARROW

; ------------------------------------------------------------------------------
; Blocco 1 (32-63)
; ------------------------------------------------------------------------------

SCREEN_SPACE                      = $20
SCREEN_EXCLAMATION_MARK           = $21
SCREEN_QUOTATION_MARK             = $22
SCREEN_NUMBER_SIGN                = $23
SCREEN_DOLLAR_SIGN                = $24
SCREEN_PERCENT_SIGN               = $25
SCREEN_AMPERSAND                  = $26
SCREEN_APOSTROPHE                 = $27
SCREEN_LEFT_PARENTHESIS           = $28
SCREEN_RIGHT_PARENTHESIS          = $29
SCREEN_ASTERISK                   = $2A
SCREEN_PLUS                       = $2B
SCREEN_COMMA                      = $2C
SCREEN_MINUS                      = $2D
SCREEN_FULL_STOP                  = $2E
SCREEN_SLASH                      = $2F
SCREEN_DIGIT_0                    = $30
SCREEN_DIGIT_1                    = $31
SCREEN_DIGIT_2                    = $32
SCREEN_DIGIT_3                    = $33
SCREEN_DIGIT_4                    = $34
SCREEN_DIGIT_5                    = $35
SCREEN_DIGIT_6                    = $36
SCREEN_DIGIT_7                    = $37
SCREEN_DIGIT_8                    = $38
SCREEN_DIGIT_9                    = $39
SCREEN_COLON                      = $3A
SCREEN_SEMICOLON                  = $3B
SCREEN_LESS_THAN_SIGN             = $3C
SCREEN_EQUALS                     = $3D
SCREEN_GREATER_THAN_SIGN          = $3E
SCREEN_QUESTION_MARK              = $3F

; ------------------------------------------------------------------------------
; Blocco 2 (64-95)
; ------------------------------------------------------------------------------

SCREEN_SHIFT_ASTERISK             = $40 ; U+2500 BOX DRAWINGS LIGHT HORIZONTAL
SCREEN_SHIFT_A                    = $41 ; U+2660 BLACK SPADE SUIT (set 1)
SCREEN_SHIFT_B                    = $42 ; U+1FB72 VERTICAL ONE EIGHTH BLOCK-4 (set 1)
SCREEN_SHIFT_C                    = $43 ; U+1FB78 HORIZONTAL ONE EIGHTH BLOCK-4 (set 1)
SCREEN_SHIFT_D                    = $44 ; U+1FB77 HORIZONTAL ONE EIGHTH BLOCK-3 (set 1)
SCREEN_SHIFT_E                    = $45 ; U+1FB76 HORIZONTAL ONE EIGHTH BLOCK-2 (set 1)
SCREEN_SHIFT_F                    = $46 ; U+1FB7A HORIZONTAL ONE EIGHTH BLOCK-6 (set 1)
SCREEN_SHIFT_G                    = $47 ; U+1FB71 VERTICAL ONE EIGHTH BLOCK-3 (set 1)
SCREEN_SHIFT_H                    = $48 ; U+1FB74 VERTICAL ONE EIGHTH BLOCK-6 (set 1)
SCREEN_SHIFT_I                    = $49 ; U+256E BOX DRAWINGS LIGHT ARC DOWN AND LEFT (set 1)
SCREEN_SHIFT_J                    = $4A ; U+2570 BOX DRAWINGS LIGHT ARC UP AND RIGHT (set 1)
SCREEN_SHIFT_K                    = $4B ; U+256F BOX DRAWINGS LIGHT ARC UP AND LEFT (set 1)
SCREEN_SHIFT_L                    = $4C ; U+1FB7C LEFT AND LOWER ONE EIGHTH BLOCK (set 1)
SCREEN_SHIFT_M                    = $4D ; U+2572 BOX DRAWINGS LIGHT DIAGONAL UPPER LEFT TO LOWER RIGHT (set 1)
SCREEN_SHIFT_N                    = $4E ; U+2571 BOX DRAWINGS LIGHT DIAGONAL UPPER RIGHT TO LOWER LEFT (set 1)
SCREEN_SHIFT_O                    = $4F ; U+1FB7D LEFT AND UPPER ONE EIGHTH BLOCK (set 1)
SCREEN_SHIFT_P                    = $50 ; U+1FB7E RIGHT AND UPPER ONE EIGHTH BLOCK (set 1)
SCREEN_SHIFT_Q                    = $51 ; U+2022 BULLET (set 1)
SCREEN_SHIFT_R                    = $52 ; U+1FB7B HORIZONTAL ONE EIGHTH BLOCK-7 (set 1)
SCREEN_SHIFT_S                    = $53 ; U+2665 BLACK HEART SUIT (set 1)
SCREEN_SHIFT_T                    = $54 ; U+1FB70 VERTICAL ONE EIGHTH BLOCK-2 (set 1)
SCREEN_SHIFT_U                    = $55 ; U+256D BOX DRAWINGS LIGHT ARC DOWN AND RIGHT (set 1)
SCREEN_SHIFT_V                    = $56 ; U+2573 BOX DRAWINGS LIGHT DIAGONAL CROSS (set 1)
SCREEN_SHIFT_W                    = $57 ; U+25CB WHITE CIRCLE (set 1)
SCREEN_SHIFT_X                    = $58 ; U+2663 BLACK CLUB SUIT (set 1)
SCREEN_SHIFT_Y                    = $59 ; U+1FB75 VERTICAL ONE EIGHTH BLOCK-7 (set 1)
SCREEN_SHIFT_Z                    = $5A ; U+2666 BLACK DIAMOND SUIT (set 1)
SCREEN_SHIFT_PLUS                 = $5B ; U+253C BOX DRAWINGS LIGHT VERTICAL AND HORIZONTAL
SCREEN_COMMODORE_MINUS            = $5C ; U+1FB8C LEFT HALF MEDIUM SHADE
SCREEN_SHIFT_MINUS                = $5D ; U+2502 BOX DRAWINGS LIGHT VERTICAL
SCREEN_SHIFT_UP_ARROW             = $5E ; U+03C0 GREEK SMALL LETTER PI (set 1)
SCREEN_COMMODORE_ASTERISK         = $5F ; U+25E5 BLACK UPPER RIGHT TRIANGLE (set 1)

; ------------------------------------------------------------------------------
; Blocco 3 (96-127)
; ------------------------------------------------------------------------------

SCREEN_SHIFT_SPACE                = $60 ; U+0020 SPACE
SCREEN_COMMODORE_K                = $61 ; U+258C LEFT HALF BLOCK
SCREEN_COMMODORE_I                = $62 ; U+2584 LOWER HALF BLOCK
SCREEN_COMMODORE_T                = $63 ; U+2594 UPPER ONE EIGHTH BLOCK
SCREEN_COMMODORE_AT_SIGN          = $64 ; U+2581 LOWER ONE EIGHTH BLOCK
SCREEN_COMMODORE_G                = $65 ; U+258F LEFT ONE EIGHTH BLOCK
SCREEN_COMMODORE_PLUS             = $66 ; U+2592 MEDIUM SHADE
SCREEN_COMMODORE_M                = $67 ; U+2595 RIGHT ONE EIGHTH BLOCK
SCREEN_COMMODORE_POUND            = $68 ; U+1FB8F LOWER HALF MEDIUM SHADE
SCREEN_SHIFT_POUND                = $69 ; U+25E4 BLACK UPPER LEFT TRIANGLE (set 1)
SCREEN_COMMODORE_N                = $6A ; U+1FB87 RIGHT ONE QUARTER BLOCK
SCREEN_COMMODORE_Q                = $6B ; U+251C BOX DRAWINGS LIGHT VERTICAL AND RIGHT
SCREEN_COMMODORE_D                = $6C ; U+2597 QUADRANT LOWER RIGHT
SCREEN_COMMODORE_Z                = $6D ; U+2514 BOX DRAWINGS LIGHT UP AND RIGHT
SCREEN_COMMODORE_S                = $6E ; U+2510 BOX DRAWINGS LIGHT DOWN AND LEFT
SCREEN_COMMODORE_P                = $6F ; U+2582 LOWER ONE QUARTER BLOCK
SCREEN_COMMODORE_A                = $70 ; U+250C BOX DRAWINGS LIGHT DOWN AND RIGHT
SCREEN_COMMODORE_E                = $71 ; U+2534 BOX DRAWINGS LIGHT UP AND HORIZONTAL
SCREEN_COMMODORE_R                = $72 ; U+252C BOX DRAWINGS LIGHT DOWN AND HORIZONTAL
SCREEN_COMMODORE_W                = $73 ; U+2524 BOX DRAWINGS LIGHT VERTICAL AND LEFT
SCREEN_COMMODORE_H                = $74 ; U+258E LEFT ONE QUARTER BLOCK
SCREEN_COMMODORE_J                = $75 ; U+258D LEFT THREE EIGHTHS BLOCK
SCREEN_COMMODORE_L                = $76 ; U+1FB88 RIGHT THREE EIGHTHS BLOCK
SCREEN_COMMODORE_Y                = $77 ; U+1FB82 UPPER ONE QUARTER BLOCK
SCREEN_COMMODORE_U                = $78 ; U+1FB83 UPPER THREE EIGHTHS BLOCK
SCREEN_COMMODORE_O                = $79 ; U+2583 LOWER THREE EIGHTHS BLOCK
SCREEN_SHIFT_AT_SIGN              = $7A ; U+1FB7F RIGHT AND LOWER ONE EIGHTH BLOCK (set 1)
SCREEN_COMMODORE_F                = $7B ; U+2596 QUADRANT LOWER LEFT
SCREEN_COMMODORE_C                = $7C ; U+259D QUADRANT UPPER RIGHT
SCREEN_COMMODORE_X                = $7D ; U+2518 BOX DRAWINGS LIGHT UP AND LEFT
SCREEN_COMMODORE_V                = $7E ; U+2598 QUADRANT UPPER LEFT
SCREEN_COMMODORE_B                = $7F ; U+259A QUADRANT UPPER LEFT AND LOWER RIGHT

; ------------------------------------------------------------------------------
; Blocco 4 (128-159)
; ------------------------------------------------------------------------------

SCREEN_AT_SIGN_REVERSE            = $80 ; Inverso di SCREEN_AT_SIGN
SCREEN_LETTER_A_REVERSE           = $81 ; Inverso di SCREEN_LETTER_A
SCREEN_LETTER_B_REVERSE           = $82 ; Inverso di SCREEN_LETTER_B
SCREEN_LETTER_C_REVERSE           = $83 ; Inverso di SCREEN_LETTER_C
SCREEN_LETTER_D_REVERSE           = $84 ; Inverso di SCREEN_LETTER_D
SCREEN_LETTER_E_REVERSE           = $85 ; Inverso di SCREEN_LETTER_E
SCREEN_LETTER_F_REVERSE           = $86 ; Inverso di SCREEN_LETTER_F
SCREEN_LETTER_G_REVERSE           = $87 ; Inverso di SCREEN_LETTER_G
SCREEN_LETTER_H_REVERSE           = $88 ; Inverso di SCREEN_LETTER_H
SCREEN_LETTER_I_REVERSE           = $89 ; Inverso di SCREEN_LETTER_I
SCREEN_LETTER_J_REVERSE           = $8A ; Inverso di SCREEN_LETTER_J
SCREEN_LETTER_K_REVERSE           = $8B ; Inverso di SCREEN_LETTER_K
SCREEN_LETTER_L_REVERSE           = $8C ; Inverso di SCREEN_LETTER_L
SCREEN_LETTER_M_REVERSE           = $8D ; Inverso di SCREEN_LETTER_M
SCREEN_LETTER_N_REVERSE           = $8E ; Inverso di SCREEN_LETTER_N
SCREEN_LETTER_O_REVERSE           = $8F ; Inverso di SCREEN_LETTER_O
SCREEN_LETTER_P_REVERSE           = $90 ; Inverso di SCREEN_LETTER_P
SCREEN_LETTER_Q_REVERSE           = $91 ; Inverso di SCREEN_LETTER_Q
SCREEN_LETTER_R_REVERSE           = $92 ; Inverso di SCREEN_LETTER_R
SCREEN_LETTER_S_REVERSE           = $93 ; Inverso di SCREEN_LETTER_S
SCREEN_LETTER_T_REVERSE           = $94 ; Inverso di SCREEN_LETTER_T
SCREEN_LETTER_U_REVERSE           = $95 ; Inverso di SCREEN_LETTER_U
SCREEN_LETTER_V_REVERSE           = $96 ; Inverso di SCREEN_LETTER_V
SCREEN_LETTER_W_REVERSE           = $97 ; Inverso di SCREEN_LETTER_W
SCREEN_LETTER_X_REVERSE           = $98 ; Inverso di SCREEN_LETTER_X
SCREEN_LETTER_Y_REVERSE           = $99 ; Inverso di SCREEN_LETTER_Y
SCREEN_LETTER_Z_REVERSE           = $9A ; Inverso di SCREEN_LETTER_Z
SCREEN_LEFT_BRACKET_REVERSE       = $9B ; Inverso di SCREEN_LEFT_BRACKET
SCREEN_POUND_REVERSE              = $9C ; Inverso di SCREEN_POUND
SCREEN_RIGHT_BRACKET_REVERSE      = $9D ; Inverso di SCREEN_RIGHT_BRACKET
SCREEN_UP_ARROW_REVERSE           = $9E ; Inverso di SCREEN_UP_ARROW
SCREEN_LEFT_ARROW_REVERSE         = $9F ; Inverso di SCREEN_LEFT_ARROW

; ------------------------------------------------------------------------------
; Blocco 5 (160-191)
; ------------------------------------------------------------------------------

SCREEN_SPACE_REVERSE              = $A0 ; Inverso di SCREEN_SPACE
SCREEN_EXCLAMATION_MARK_REVERSE   = $A1 ; Inverso di SCREEN_EXCLAMATION_MARK
SCREEN_QUOTATION_MARK_REVERSE     = $A2 ; Inverso di SCREEN_QUOTATION_MARK
SCREEN_NUMBER_SIGN_REVERSE        = $A3 ; Inverso di SCREEN_NUMBER_SIGN
SCREEN_DOLLAR_SIGN_REVERSE        = $A4 ; Inverso di SCREEN_DOLLAR_SIGN
SCREEN_PERCENT_SIGN_REVERSE       = $A5 ; Inverso di SCREEN_PERCENT_SIGN
SCREEN_AMPERSAND_REVERSE          = $A6 ; Inverso di SCREEN_AMPERSAND
SCREEN_APOSTROPHE_REVERSE         = $A7 ; Inverso di SCREEN_APOSTROPHE
SCREEN_LEFT_PARENTHESIS_REVERSE   = $A8 ; Inverso di SCREEN_LEFT_PARENTHESIS
SCREEN_RIGHT_PARENTHESIS_REVERSE  = $A9 ; Inverso di SCREEN_RIGHT_PARENTHESIS
SCREEN_ASTERISK_REVERSE           = $AA ; Inverso di SCREEN_ASTERISK
SCREEN_PLUS_REVERSE               = $AB ; Inverso di SCREEN_PLUS
SCREEN_COMMA_REVERSE              = $AC ; Inverso di SCREEN_COMMA
SCREEN_MINUS_REVERSE              = $AD ; Inverso di SCREEN_MINUS
SCREEN_FULL_STOP_REVERSE          = $AE ; Inverso di SCREEN_FULL_STOP
SCREEN_SLASH_REVERSE              = $AF ; Inverso di SCREEN_SLASH
SCREEN_DIGIT_0_REVERSE            = $B0 ; Inverso di SCREEN_DIGIT_0
SCREEN_DIGIT_1_REVERSE            = $B1 ; Inverso di SCREEN_DIGIT_1
SCREEN_DIGIT_2_REVERSE            = $B2 ; Inverso di SCREEN_DIGIT_2
SCREEN_DIGIT_3_REVERSE            = $B3 ; Inverso di SCREEN_DIGIT_3
SCREEN_DIGIT_4_REVERSE            = $B4 ; Inverso di SCREEN_DIGIT_4
SCREEN_DIGIT_5_REVERSE            = $B5 ; Inverso di SCREEN_DIGIT_5
SCREEN_DIGIT_6_REVERSE            = $B6 ; Inverso di SCREEN_DIGIT_6
SCREEN_DIGIT_7_REVERSE            = $B7 ; Inverso di SCREEN_DIGIT_7
SCREEN_DIGIT_8_REVERSE            = $B8 ; Inverso di SCREEN_DIGIT_8
SCREEN_DIGIT_9_REVERSE            = $B9 ; Inverso di SCREEN_DIGIT_9
SCREEN_COLON_REVERSE              = $BA ; Inverso di SCREEN_COLON
SCREEN_SEMICOLON_REVERSE          = $BB ; Inverso di SCREEN_SEMICOLON
SCREEN_LESS_THAN_SIGN_REVERSE     = $BC ; Inverso di SCREEN_LESS_THAN_SIGN
SCREEN_EQUALS_REVERSE             = $BD ; Inverso di SCREEN_EQUALS
SCREEN_GREATER_THAN_SIGN_REVERSE  = $BE ; Inverso di SCREEN_GREATER_THAN_SIGN
SCREEN_QUESTION_MARK_REVERSE      = $BF ; Inverso di SCREEN_QUESTION_MARK

; ------------------------------------------------------------------------------
; Blocco 6 (192-223)
; ------------------------------------------------------------------------------

SCREEN_SHIFT_ASTERISK_REVERSE     = $C0 ; Inverso di SCREEN_SHIFT_ASTERISK
SCREEN_SHIFT_A_REVERSE            = $C1 ; Inverso di SCREEN_SHIFT_A
SCREEN_SHIFT_B_REVERSE            = $C2 ; Inverso di SCREEN_SHIFT_B
SCREEN_SHIFT_C_REVERSE            = $C3 ; Inverso di SCREEN_SHIFT_C
SCREEN_SHIFT_D_REVERSE            = $C4 ; Inverso di SCREEN_SHIFT_D
SCREEN_SHIFT_E_REVERSE            = $C5 ; Inverso di SCREEN_SHIFT_E
SCREEN_SHIFT_F_REVERSE            = $C6 ; Inverso di SCREEN_SHIFT_F
SCREEN_SHIFT_G_REVERSE            = $C7 ; Inverso di SCREEN_SHIFT_G
SCREEN_SHIFT_H_REVERSE            = $C8 ; Inverso di SCREEN_SHIFT_H
SCREEN_SHIFT_I_REVERSE            = $C9 ; Inverso di SCREEN_SHIFT_I
SCREEN_SHIFT_J_REVERSE            = $CA ; Inverso di SCREEN_SHIFT_J
SCREEN_SHIFT_K_REVERSE            = $CB ; Inverso di SCREEN_SHIFT_K
SCREEN_SHIFT_L_REVERSE            = $CC ; Inverso di SCREEN_SHIFT_L
SCREEN_SHIFT_M_REVERSE            = $CD ; Inverso di SCREEN_SHIFT_M
SCREEN_SHIFT_N_REVERSE            = $CE ; Inverso di SCREEN_SHIFT_N
SCREEN_SHIFT_O_REVERSE            = $CF ; Inverso di SCREEN_SHIFT_O
SCREEN_SHIFT_P_REVERSE            = $D0 ; Inverso di SCREEN_SHIFT_P
SCREEN_SHIFT_Q_REVERSE            = $D1 ; Inverso di SCREEN_SHIFT_Q
SCREEN_SHIFT_R_REVERSE            = $D2 ; Inverso di SCREEN_SHIFT_R
SCREEN_SHIFT_S_REVERSE            = $D3 ; Inverso di SCREEN_SHIFT_S
SCREEN_SHIFT_T_REVERSE            = $D4 ; Inverso di SCREEN_SHIFT_T
SCREEN_SHIFT_U_REVERSE            = $D5 ; Inverso di SCREEN_SHIFT_U
SCREEN_SHIFT_V_REVERSE            = $D6 ; Inverso di SCREEN_SHIFT_V
SCREEN_SHIFT_W_REVERSE            = $D7 ; Inverso di SCREEN_SHIFT_W
SCREEN_SHIFT_X_REVERSE            = $D8 ; Inverso di SCREEN_SHIFT_X
SCREEN_SHIFT_Y_REVERSE            = $D9 ; Inverso di SCREEN_SHIFT_Y
SCREEN_SHIFT_Z_REVERSE            = $DA ; Inverso di SCREEN_SHIFT_Z
SCREEN_SHIFT_PLUS_REVERSE         = $DB ; Inverso di SCREEN_SHIFT_PLUS
SCREEN_COMMODORE_MINUS_REVERSE    = $DC ; Inverso di SCREEN_COMMODORE_MINUS
SCREEN_SHIFT_MINUS_REVERSE        = $DD ; Inverso di SCREEN_SHIFT_MINUS
SCREEN_SHIFT_UP_ARROW_REVERSE     = $DE ; Inverso di SCREEN_SHIFT_UP_ARROW
SCREEN_COMMODORE_ASTERISK_REVERSE = $DF ; Inverso di SCREEN_COMMODORE_ASTERISK

; ------------------------------------------------------------------------------
; Blocco 7 (224-255)
; ------------------------------------------------------------------------------

SCREEN_SHIFT_SPACE_REVERSE        = $E0 ; Inverso di SCREEN_SHIFT_SPACE
SCREEN_COMMODORE_K_REVERSE        = $E1 ; Inverso di SCREEN_COMMODORE_K
SCREEN_COMMODORE_I_REVERSE        = $E2 ; Inverso di SCREEN_COMMODORE_I
SCREEN_COMMODORE_T_REVERSE        = $E3 ; Inverso di SCREEN_COMMODORE_T
SCREEN_COMMODORE_AT_SIGN_REVERSE  = $E4 ; Inverso di SCREEN_COMMODORE_AT_SIGN
SCREEN_COMMODORE_G_REVERSE        = $E5 ; Inverso di SCREEN_COMMODORE_G
SCREEN_COMMODORE_PLUS_REVERSE     = $E6 ; Inverso di SCREEN_COMMODORE_PLUS
SCREEN_COMMODORE_M_REVERSE        = $E7 ; Inverso di SCREEN_COMMODORE_M
SCREEN_COMMODORE_POUND_REVERSE    = $E8 ; Inverso di SCREEN_COMMODORE_POUND
SCREEN_SHIFT_POUND_REVERSE        = $E9 ; Inverso di SCREEN_SHIFT_POUND
SCREEN_COMMODORE_N_REVERSE        = $EA ; Inverso di SCREEN_COMMODORE_N
SCREEN_COMMODORE_Q_REVERSE        = $EB ; Inverso di SCREEN_COMMODORE_Q
SCREEN_COMMODORE_D_REVERSE        = $EC ; Inverso di SCREEN_COMMODORE_D
SCREEN_COMMODORE_Z_REVERSE        = $ED ; Inverso di SCREEN_COMMODORE_Z
SCREEN_COMMODORE_S_REVERSE        = $EE ; Inverso di SCREEN_COMMODORE_S
SCREEN_COMMODORE_P_REVERSE        = $EF ; Inverso di SCREEN_COMMODORE_P
SCREEN_COMMODORE_A_REVERSE        = $F0 ; Inverso di SCREEN_COMMODORE_A
SCREEN_COMMODORE_E_REVERSE        = $F1 ; Inverso di SCREEN_COMMODORE_E
SCREEN_COMMODORE_R_REVERSE        = $F2 ; Inverso di SCREEN_COMMODORE_R
SCREEN_COMMODORE_W_REVERSE        = $F3 ; Inverso di SCREEN_COMMODORE_W
SCREEN_COMMODORE_H_REVERSE        = $F4 ; Inverso di SCREEN_COMMODORE_H
SCREEN_COMMODORE_J_REVERSE        = $F5 ; Inverso di SCREEN_COMMODORE_J
SCREEN_COMMODORE_L_REVERSE        = $F6 ; Inverso di SCREEN_COMMODORE_L
SCREEN_COMMODORE_Y_REVERSE        = $F7 ; Inverso di SCREEN_COMMODORE_Y
SCREEN_COMMODORE_U_REVERSE        = $F8 ; Inverso di SCREEN_COMMODORE_U
SCREEN_COMMODORE_O_REVERSE        = $F9 ; Inverso di SCREEN_COMMODORE_O
SCREEN_SHIFT_AT_SIGN_REVERSE      = $FA ; Inverso di SCREEN_SHIFT_AT_SIGN
SCREEN_COMMODORE_F_REVERSE        = $FB ; Inverso di SCREEN_COMMODORE_F
SCREEN_COMMODORE_C_REVERSE        = $FC ; Inverso di SCREEN_COMMODORE_C
SCREEN_COMMODORE_X_REVERSE        = $FD ; Inverso di SCREEN_COMMODORE_X
SCREEN_COMMODORE_V_REVERSE        = $FE ; Inverso di SCREEN_COMMODORE_V
SCREEN_COMMODORE_B_REVERSE        = $FF ; Inverso di SCREEN_COMMODORE_B
