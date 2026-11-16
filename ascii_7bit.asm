; ==============================================================================
; FILE:           ascii_7bit.asm
; PROGETTO:       Libreria di Sistema (system.c64)
; TARGET:         ACME Assembler / MOS 6510 (Commodore 64)
; DESCRIZIONE:    Codici ASCII a 7 bit, con simboli ASCII_<descrizione>.
; ==============================================================================

; ------------------------------------------------------------------------------
; Blocco 0 (0-31)
; ------------------------------------------------------------------------------

ASCII_NULL                = $00 ; Carattere nullo (NUL)
ASCII_CTRL_A              = $01 ; Inizio intestazione (SOH)
ASCII_CTRL_B              = $02 ; Inizio testo (STX)
ASCII_CTRL_C              = $03 ; Fine testo (ETX)
ASCII_CTRL_D              = $04 ; Fine trasmissione (EOT)
ASCII_CTRL_E              = $05 ; Richiesta (ENQ)
ASCII_CTRL_F              = $06 ; Conferma (ACK)
ASCII_BELL                = $07 ; Segnale acustico (BEL)
ASCII_BACKSPACE           = $08 ; Cancella il carattere precedente (BS)
ASCII_TAB                 = $09 ; Tabulazione orizzontale (HT)
ASCII_LINE_FEED           = $0A ; Avanza di una riga (LF)
ASCII_CTRL_K              = $0B ; Tabulazione verticale (VT)
ASCII_FORM_FEED           = $0C ; Avanza di una pagina (FF)
ASCII_CARRIAGE_RETURN     = $0D ; Ritorno a inizio riga (CR)
ASCII_CTRL_N              = $0E ; Fuori codice (SO)
ASCII_CTRL_O              = $0F ; Nel codice (SI)
ASCII_CTRL_P              = $10 ; Fuga dal collegamento dati (DLE)
ASCII_CTRL_Q              = $11 ; Controllo dispositivo 1 (DC1)
ASCII_CTRL_R              = $12 ; Controllo dispositivo 2 (DC2)
ASCII_CTRL_S              = $13 ; Controllo dispositivo 3 (DC3)
ASCII_CTRL_T              = $14 ; Controllo dispositivo 4 (DC4)
ASCII_CTRL_U              = $15 ; Conferma negativa (NAK)
ASCII_CTRL_V              = $16 ; Sincronismo (SYN)
ASCII_CTRL_W              = $17 ; Fine blocco di trasmissione (ETB)
ASCII_CTRL_X              = $18 ; Annulla (CAN)
ASCII_CTRL_Y              = $19 ; Fine del supporto (EM)
ASCII_CTRL_Z              = $1A ; Sostituzione (SUB)
ASCII_ESCAPE              = $1B ; Sequenza di escape (ESC)
ASCII_CTRL_BACKSLASH      = $1C ; Separatore di file (FS)
ASCII_CTRL_RIGHT_BRACKET  = $1D ; Separatore di gruppo (GS)
ASCII_CTRL_CIRCUMFLEX     = $1E ; Separatore di record (RS)
ASCII_CTRL_UNDERSCORE     = $1F ; Separatore di unità (US)

; ------------------------------------------------------------------------------
; Blocco 1 (32-63)
; ------------------------------------------------------------------------------

ASCII_SPACE               = $20
ASCII_EXCLAMATION_MARK    = $21
ASCII_QUOTATION_MARK      = $22
ASCII_NUMBER_SIGN         = $23
ASCII_DOLLAR_SIGN         = $24
ASCII_PERCENT_SIGN        = $25
ASCII_AMPERSAND           = $26
ASCII_APOSTROPHE          = $27
ASCII_LEFT_PARENTHESIS    = $28
ASCII_RIGHT_PARENTHESIS   = $29
ASCII_ASTERISK            = $2A
ASCII_PLUS                = $2B
ASCII_COMMA               = $2C
ASCII_MINUS               = $2D
ASCII_FULL_STOP           = $2E
ASCII_SLASH               = $2F
ASCII_DIGIT_0             = $30
ASCII_DIGIT_1             = $31
ASCII_DIGIT_2             = $32
ASCII_DIGIT_3             = $33
ASCII_DIGIT_4             = $34
ASCII_DIGIT_5             = $35
ASCII_DIGIT_6             = $36
ASCII_DIGIT_7             = $37
ASCII_DIGIT_8             = $38
ASCII_DIGIT_9             = $39
ASCII_COLON               = $3A
ASCII_SEMICOLON           = $3B
ASCII_LESS_THAN_SIGN      = $3C
ASCII_EQUALS              = $3D
ASCII_GREATER_THAN_SIGN   = $3E
ASCII_QUESTION_MARK       = $3F

; ------------------------------------------------------------------------------
; Blocco 2 (64-95)
; ------------------------------------------------------------------------------

ASCII_AT_SIGN             = $40 ; U+0040 COMMERCIAL AT
ASCII_LETTER_A            = $41
ASCII_LETTER_B            = $42
ASCII_LETTER_C            = $43
ASCII_LETTER_D            = $44
ASCII_LETTER_E            = $45
ASCII_LETTER_F            = $46
ASCII_LETTER_G            = $47
ASCII_LETTER_H            = $48
ASCII_LETTER_I            = $49
ASCII_LETTER_J            = $4A
ASCII_LETTER_K            = $4B
ASCII_LETTER_L            = $4C
ASCII_LETTER_M            = $4D
ASCII_LETTER_N            = $4E
ASCII_LETTER_O            = $4F
ASCII_LETTER_P            = $50
ASCII_LETTER_Q            = $51
ASCII_LETTER_R            = $52
ASCII_LETTER_S            = $53
ASCII_LETTER_T            = $54
ASCII_LETTER_U            = $55
ASCII_LETTER_V            = $56
ASCII_LETTER_W            = $57
ASCII_LETTER_X            = $58
ASCII_LETTER_Y            = $59
ASCII_LETTER_Z            = $5A
ASCII_LEFT_BRACKET        = $5B ; U+005B LEFT SQUARE BRACKET
ASCII_BACKSLASH           = $5C ; U+005C REVERSE SOLIDUS
ASCII_RIGHT_BRACKET       = $5D ; U+005D RIGHT SQUARE BRACKET
ASCII_CIRCUMFLEX          = $5E ; U+005E CIRCUMFLEX ACCENT
ASCII_UNDERSCORE          = $5F ; U+005F LOW LINE

; ------------------------------------------------------------------------------
; Blocco 3 (96-127)
; ------------------------------------------------------------------------------

ASCII_GRAVE_ACCENT        = $60 ; U+0060 GRAVE ACCENT
ASCII_LOWERCASE_LETTER_A  = $61
ASCII_LOWERCASE_LETTER_B  = $62
ASCII_LOWERCASE_LETTER_C  = $63
ASCII_LOWERCASE_LETTER_D  = $64
ASCII_LOWERCASE_LETTER_E  = $65
ASCII_LOWERCASE_LETTER_F  = $66
ASCII_LOWERCASE_LETTER_G  = $67
ASCII_LOWERCASE_LETTER_H  = $68
ASCII_LOWERCASE_LETTER_I  = $69
ASCII_LOWERCASE_LETTER_J  = $6A
ASCII_LOWERCASE_LETTER_K  = $6B
ASCII_LOWERCASE_LETTER_L  = $6C
ASCII_LOWERCASE_LETTER_M  = $6D
ASCII_LOWERCASE_LETTER_N  = $6E
ASCII_LOWERCASE_LETTER_O  = $6F
ASCII_LOWERCASE_LETTER_P  = $70
ASCII_LOWERCASE_LETTER_Q  = $71
ASCII_LOWERCASE_LETTER_R  = $72
ASCII_LOWERCASE_LETTER_S  = $73
ASCII_LOWERCASE_LETTER_T  = $74
ASCII_LOWERCASE_LETTER_U  = $75
ASCII_LOWERCASE_LETTER_V  = $76
ASCII_LOWERCASE_LETTER_W  = $77
ASCII_LOWERCASE_LETTER_X  = $78
ASCII_LOWERCASE_LETTER_Y  = $79
ASCII_LOWERCASE_LETTER_Z  = $7A
ASCII_LEFT_CURLY_BRACKET  = $7B ; U+007B LEFT CURLY BRACKET
ASCII_VERTICAL_BAR        = $7C ; U+007C VERTICAL LINE
ASCII_RIGHT_CURLY_BRACKET = $7D ; U+007D RIGHT CURLY BRACKET
ASCII_TILDE               = $7E ; U+007E TILDE
ASCII_DELETE              = $7F ; Cancellazione (DEL)
