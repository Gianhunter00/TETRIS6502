.org $8000

delay: ;save old val
    STA $40  ; save val
    LDA #$00
    STA $41  ; start val for loop
delayloop: ;~1 second loop
    ADC #01
    NOP
    NOP
    NOP
    NOP
    NOP
    BNE delayloop
    CLC
    JSR moveForm
    INC $01
    BNE delayloop
    CLC
    LDA $40  ; restore val
    RTS
smallDelay:
    STA $40  ; save val
    LDA $41
smallDelayloop: ;
    ADC #01
    BNE smallDelayloop
    CLC
    INC $02
    BNE smallDelayloop
    CLC
    LDA #$02 ;save num to sum
    STA $23
    LDA #$80
    STA $24
    LDA #$39
    STA $25
    LDA $0500
    BEQ setJumpBack2
    BEQ helperCallLForm
    LDA #$44
    STA $25
    LDA $0501
    BEQ setJumpBack2
    BEQ helperCallCForm
    LDA $40  ; restore val
    RTS
helperCallLForm:
    JSR drawLForm
    RTS
helperCallCForm:
    JSR createCubeForm
    RTS
setCorrectCarry2:
    LDA $24
    CLC
    ADC #$01
    PHA
    JMP ifCarryJumpHere2
setJumpBack2: ;CHANGE STACK POS 24 AND 25 FOR PUSHING INTO THE STACK
    LDA $24
    PHA
    LDA $25 ;CHANGE TO WHERE IS NEEDED
    ADC $23
    PHA
ifCarryJumpHere2:
    LDA $24
    PHA
    LDA $25
    PHA
    LDA #$00
END2:
    RTS
clear:
    STY $20 ;save old y val
    STA $30 ; save old a val
    LDY #$00
    LDA #$00
    STY $21 ;color to clear pos
    STA $31 ;counter to clear pos
clearLoop: ;loop from 0400 to 04ff to set the background
    LDA $0400, Y
    STA $0200, Y
    INY
    BNE clearLoop
    CLC ;clear carry flag
    LDY $20 ;restore old val
    LDA $30
    RTS ;return
saveBackground:
    STY $10 ;save old y val
    STA $15 ; save old a val
    LDY #$00
    LDA #$00
    STY $11 ;color to clear pos
    STA $16 ;counter to clear pos
saveBackgroundLoop: ;loop from 0200 to 02ff and save it to 0400 to 04FF
    LDA $0200, Y
    STA $0400, Y
    INY
    BNE saveBackgroundLoop
    CLC ;clear carry flag
    LDY $10 ;restore old val
    LDA $15
    RTS ;return
clearRegister:
    LDA #$00
    STA $0000, X
    INX
    BNE clearRegister
    CLC
;secondRegister: ;save jmp location in register 01, do not clear
;    STA $0100, X
;    INX
;    BNE secondRegister
;    CLC
thirdRegister:
    STA $0200,X
    INX
    BNE thirdRegister
    CLC
fourthRegister:
    STA $0300, X
    INX
    BNE fourthRegister
    CLC
fifthRegister:
    STA $0400, X
    INX
    BNE fifthRegister
    CLC
sixthRegister:
    STA $0500, X
    INX
    BNE sixthRegister
    CLC
seventhRegister:
    STA $0600, X
    INX
    BNE seventhRegister
    CLC
eigthRegister:
    STA $0700, X
    INX
    BNE eigthRegister
    CLC
    RTS
increaseWidth:
    JSR clear
    STY $A0
    STA $B0
    LDY $90
    INY
    STY $C0
    LDA $E0 ;checker
    ADC $C0
    STA $D0
    TYA
    ORA #$0F
    CMP $D0
    BMI helperWallRight
    STY $90
helperWallRight:
    LDY $90
    LDA #$02 ;save num to sum
    STA $23
    LDA #$81
    STA $24
    LDA #$02
    STA $25
    LDA $0500
    BEQ helperJumpCaller
    BEQ drawLForm
    LDA #$0D
    STA $25
    LDA $0501
    BEQ helperJumpCaller
    BEQ helperCreateCubeCaller
    JSR smallDelay
    LDA $B0
    LDY $A0
    RTS
moveForm:
    LDA $4000
    AND #$08
    BNE increaseWidth
    LDA $4000
    AND #$04
    BNE decreaseWidth
    RTS
decreaseWidth:
    JSR clear
    STY $A0
    STA $B0
    LDY $90
    DEY
    STY $C0
    LDA #$00 ;checker
    ORA $C0
    ROL A
    ROL A
    ROL A
    ROL A
    CMP #$F0
    BCS helperWallLeft
    STY $90
helperWallLeft:
    LDY $90
    LDA #$02 ;save num to sum
    STA $23
    LDA #$81
    STA $24
    LDA #$53
    STA $25
    LDA $0500
    BEQ helperJumpCaller
    BEQ drawLForm
    LDA #$5E
    STA $25
    LDA $0501
    BEQ helperJumpCaller
    BEQ helperCreateCubeCaller
    JSR smallDelay
    LDA $B0
    LDY $A0
    RTS
helperJumpCaller:
    JSR setJumpBack
    RTS
helperCreateCubeCaller:
    JSR createCubeForm
    RTS
SetCarry:
    SEC
    JMP helper
drawLForm:
    STA $80 ;save old state
    STY $70 ;save old state
    LDY $90 ;inc val
    LDA #$03 ;color
    STA $0200, Y ;pos + inc + draw
    STA $0201, Y
    STA $0202, Y
    STA $0203, Y
    STA $01F3, Y
    LDA #$03
    STA $E0
    LDA $80 ;reset A to old val
    LDY $70 ; reset Y to old val
    RTS
setCorrectCarry:
    LDA $24
    ADC #$01
    PHA
    JMP ifCarryJumpHere
setJumpBack: ;CHANGE STACK POS 24 AND 25 FOR PUSHING INTO THE STACK THE CELL TO JUMP TO -2
    LDA $24
    PHA
    LDA $25 ;CHANGE TO WHERE IS NEEDED
    CLC
    ADC $23
    BCS setCorrectCarry
    PHA
ifCarryJumpHere:
    LDA $24
    PHA
    LDA $25
    PHA
    LDA #$00
    RTS
checkLCollision:
    LDA $0200, Y
    BNE SetCarry ;Set false carry to stop
    LDA $0201, Y
    BNE SetCarry ;Set false carry to stop
    LDA $0202, Y
    BNE SetCarry ;Set false carry to stop
    LDA $0203, Y
    BNE SetCarry ;Set false carry to stop
    RTS ;return
createForm:
    ;has to do random form and random pos
    STA $80 ;save old state
    STY $70 ;save old state
    LDA #$02 ;save num to sum
    STA $23
    LDA #$81
    STA $24 ;save start jump point for every form
    LDA #$DA
    STA $25 ;save start jump point for every form
    LDA $0500
    BEQ setJumpBack
    BEQ drawLForm
    LDA #$E5
    STA $25 ;save start jump point for every form
    LDA $0501
    BEQ setJumpBack
    BEQ createCubeForm
    LDA $90 ;get inc col ;address to jump back
    ADC #$10 ;increment column
    BCS helper
    STA $90 ;resave col count
    TAY ;set column inc to Y
    LDA #$02 ;save num to sum
    STA $23
    LDA #$82
    STA $24
    LDA #$01
    STA $25
    LDA $0500
    BEQ setJumpBack
    BEQ checkLCollision
    LDA #$82
    STA $24
    LDA #$10
    STA $25
    LDA $0501
    BEQ setJumpBack
    BEQ checkCubeCollision
helper:
    LDA $80 ;reset A to old val
    LDY $70 ; reset Y to old val
    RTS ;return
createCubeForm:
    STA $80 ;save old state
    STY $70 ;save old state
    LDY $90 ;inc val
    LDA #$0B ;color
    STA $0200, Y ;pos + inc + draw
    STA $0201, Y
    STA $01F0, Y
    STA $01F1, Y
    LDA #$01
    STA $E0
    LDA $80 ;reset A to old val
    LDY $70 ; reset Y to old val
    RTS
checkCubeCollision:
    LDA $0200, Y
    BNE SetCarry2 ;Set false carry to stop
    LDA $0201, Y
    BNE SetCarry2 ;Set false carry to stop
    RTS ;return
SetCarry2:
    SEC
    JMP helper
FormDecider: ;to do
    STA $55
    LDA $0500
    STA $0502
    LDA $501
    STA $0500
    LDA $0502
    STA $0501
    LDA $55
    RTS
decideFormLoop:
    LDA #$01
    STA $0500
    LDA #$00
    STA $0501
    RTS
init:
    LDA #$82
    STA $01FF
    LDA #$70
    STA $01FE
    RTS
    JSR clearRegister
    JSR decideFormLoop
    LDA #$00 ;init a first column (has to be 00)
    LDY #$00 ;init increase count for form to falling
    STY $70 ;save init count in 70
    STA $60 ;save val in 60
    JSR update ;start update
    JSR delay
    JSR delay
    JSR delay
    JSR delay
    JSR delay
    JSR delay
    JSR delay
    JSR delay
    JSR delay
update:
    JSR delay ;delay 1 second
    JSR clear ; clear console with 0400-04ff
    JSR createForm
    BCC update ;restart update if block arrived at ground (will have to check if form arrived at destination next, for now its fine)
    ;reset count for form
    LDA #$00
    TAX
    STX $F4
    STA $60
    TAY
    STY $90
    CLC
    JSR saveBackground ;save current background state after form arrived at destination
    JSR checkFilledRow
    JSR FormDecider
    JMP update
    RTS
checkFilledRow:
    STA $55
    LDX $F4
    INC $05
    LDA $05
    CMP #$10
    BEQ deleteLine
    INX
    STX $F4
    LDA $03FF, X
    BNE checkFilledRow
    LDA $D5
    ADC #$10
    BCS noLineToDelete
    STA $D5
    STA $F4
    LDA #$00
    STA $05
    JMP checkFilledRow
noLineToDelete:
    CLC
    LDA #$00
    STA $D5
    STA $05
    LDA $55
    RTS
incrementXthenDelete:
    INX
    STX $D5
deleteLine:
    ;delete actual line and fall all by 10
    LDA #$00
    LDX $D5
    STA $0400, X
    LDA $D5
    CMP $F4
    BNE incrementXthenDelete
    CLC
    LDA $D5
    ADC #$01
    BCS checkedAll
    STA $D5
    STA $F4
    LDA #$00
    STA $05
    JMP checkFilledRow
checkedAll:
    LDA #$00
    STA $D5
    STA $05
    LDA $55
    RTS
interrupt:
    LDX #$50
    RTI
nonmaskable:
    LDX #$70
    RTI
.goto $FFFA
.dw nonmaskable
.dw init
.dw interrupt