; ==============================================================================
; FILE:           keycodes.asm
; PROGETTO:       Libreria di Sistema (c64.c64)
; TARGET:         ACME Assembler / MOS 6510 (Commodore 64)
; DESCRIZIONE:    Codici della matrice della tastiera. Con __C128_C64_MODE = 1
;                 aggiunge il supporto per i registri extra usati nella versione
;                 del chip installata sul C128.
; ==============================================================================

KEYCODE_DELETE              = $00 ; Cancella il carattere a sinistra del cursore
KEYCODE_RETURN              = $01 ; A capo (tasto RETURN)
KEYCODE_CURSOR_RIGHT        = $02 ; Sposta il cursore a destra
KEYCODE_F7                  = $03 ; Tasto funzione F7
KEYCODE_F1                  = $04 ; Tasto funzione F1
KEYCODE_F3                  = $05 ; Tasto funzione F3
KEYCODE_F5                  = $06 ; Tasto funzione F5
KEYCODE_CURSOR_DOWN         = $07 ; Sposta il cursore in basso
KEYCODE_DIGIT_3             = $08 ; Tasto 3
KEYCODE_LETTER_W            = $09 ; Tasto W
KEYCODE_LETTER_A            = $0A ; Tasto A
KEYCODE_DIGIT_4             = $0B ; Tasto 4
KEYCODE_LETTER_Z            = $0C ; Tasto Z
KEYCODE_LETTER_S            = $0D ; Tasto S
KEYCODE_LETTER_E            = $0E ; Tasto E
KEYCODE_LEFT_SHIFT          = $0F ; Tasto SHIFT sinistro
KEYCODE_DIGIT_5             = $10 ; Tasto 5
KEYCODE_LETTER_R            = $11 ; Tasto R
KEYCODE_LETTER_D            = $12 ; Tasto D
KEYCODE_DIGIT_6             = $13 ; Tasto 6
KEYCODE_LETTER_C            = $14 ; Tasto C
KEYCODE_LETTER_F            = $15 ; Tasto F
KEYCODE_LETTER_T            = $16 ; Tasto T
KEYCODE_LETTER_X            = $17 ; Tasto X
KEYCODE_DIGIT_7             = $18 ; Tasto 7
KEYCODE_LETTER_Y            = $19 ; Tasto Y
KEYCODE_LETTER_G            = $1A ; Tasto G
KEYCODE_DIGIT_8             = $1B ; Tasto 8
KEYCODE_LETTER_B            = $1C ; Tasto B
KEYCODE_LETTER_H            = $1D ; Tasto H
KEYCODE_LETTER_U            = $1E ; Tasto U
KEYCODE_LETTER_V            = $1F ; Tasto V
KEYCODE_DIGIT_9             = $20 ; Tasto 9
KEYCODE_LETTER_I            = $21 ; Tasto I
KEYCODE_LETTER_J            = $22 ; Tasto J
KEYCODE_DIGIT_0             = $23 ; Tasto 0
KEYCODE_LETTER_M            = $24 ; Tasto M
KEYCODE_LETTER_K            = $25 ; Tasto K
KEYCODE_LETTER_O            = $26 ; Tasto O
KEYCODE_LETTER_N            = $27 ; Tasto N
KEYCODE_PLUS                = $28 ; Tasto più
KEYCODE_LETTER_P            = $29 ; Tasto P
KEYCODE_LETTER_L            = $2A ; Tasto L
KEYCODE_MINUS               = $2B ; Tasto meno
KEYCODE_FULL_STOP           = $2C ; Tasto punto
KEYCODE_COLON               = $2D ; Tasto due punti
KEYCODE_AT_SIGN             = $2E ; Tasto chiocciola
KEYCODE_COMMA               = $2F ; Tasto virgola
KEYCODE_POUND               = $30 ; Tasto sterlina; U+00A3 POUND SIGN
KEYCODE_ASTERISK            = $31 ; Tasto asterisco
KEYCODE_SEMICOLON           = $32 ; Tasto punto e virgola
KEYCODE_HOME                = $33 ; Porta il cursore in alto a sinistra
KEYCODE_RIGHT_SHIFT         = $34 ; Tasto SHIFT destro
KEYCODE_EQUALS              = $35 ; Tasto uguale
KEYCODE_UP_ARROW            = $36 ; Tasto freccia in su; U+2191 UPWARDS ARROW
KEYCODE_SLASH               = $37 ; Tasto barra
KEYCODE_DIGIT_1             = $38 ; Tasto 1
KEYCODE_LEFT_ARROW          = $39 ; Tasto freccia a sinistra; U+2190 LEFTWARDS ARROW
KEYCODE_CONTROL             = $3A ; Tasto CTRL
KEYCODE_DIGIT_2             = $3B ; Tasto 2
KEYCODE_SPACE               = $3C ; Barra spaziatrice
KEYCODE_COMMODORE           = $3D ; Tasto Commodore
KEYCODE_LETTER_Q            = $3E ; Tasto Q
KEYCODE_STOP                = $3F ; Tasto RUN/STOP

!if (__C128_C64_MODE = 1) {       ; Codici extra del C128.
  KEYCODE_HELP              = $40 ; Tasto HELP
  KEYCODE_KEYPAD_DIGIT_8    = $41 ; Tasto 8 del tastierino numerico
  KEYCODE_KEYPAD_DIGIT_5    = $42 ; Tasto 5 del tastierino numerico
  KEYCODE_TAB               = $43 ; Tasto TAB
  KEYCODE_KEYPAD_DIGIT_2    = $44 ; Tasto 2 del tastierino numerico
  KEYCODE_KEYPAD_DIGIT_4    = $45 ; Tasto 4 del tastierino numerico
  KEYCODE_KEYPAD_DIGIT_7    = $46 ; Tasto 7 del tastierino numerico
  KEYCODE_KEYPAD_DIGIT_1    = $47 ; Tasto 1 del tastierino numerico
  KEYCODE_ESC               = $48 ; Tasto ESC
  KEYCODE_KEYPAD_PLUS       = $49 ; Tasto più del tastierino numerico
  KEYCODE_KEYPAD_MINUS      = $4A ; Tasto meno del tastierino numerico
  KEYCODE_LINE_FEED         = $4B ; Tasto LINE FEED
  KEYCODE_ENTER             = $4C ; Tasto ENTER del tastierino numerico
  KEYCODE_KEYPAD_DIGIT_6    = $4D ; Tasto 6 del tastierino numerico
  KEYCODE_KEYPAD_DIGIT_9    = $4E ; Tasto 9 del tastierino numerico
  KEYCODE_KEYPAD_DIGIT_3    = $4F ; Tasto 3 del tastierino numerico
  KEYCODE_ALT               = $50 ; Tasto ALT
  KEYCODE_KEYPAD_DIGIT_0    = $51 ; Tasto 0 del tastierino numerico
  KEYCODE_KEYPAD_FULL_STOP  = $52 ; Tasto punto del tastierino numerico
  KEYCODE_UP                = $53 ; Tasto cursore su
  KEYCODE_DOWN              = $54 ; Tasto cursore giù
  KEYCODE_LEFT              = $55 ; Tasto cursore a sinistra
  KEYCODE_RIGHT             = $56 ; Tasto cursore a destra
  KEYCODE_NO_SCROLL         = $57 ; Tasto NO SCROLL
  KEYCODE_NO_KEY            = $58 ; Nessun tasto premuto
} else {                          ; Sul C64 i codici arrivano fino a $3F.
  KEYCODE_NO_KEY            = $40 ; Nessun tasto premuto
}
