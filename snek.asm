; R0 is Head of Snek
; R1 is Tail of Snek
; P0 is Input
; 11111110 Up
; 11111101 Down
; 11111011 Left
; 11110111 Right
; Encoding of Tail:
; FB Parent Up
; FC Parent Down
; FD Parent Left
; FE Parent Right

; C3 Fruit
ZUF8R EQU 0x07

CSEG At 0H
jmp init
ORG 100H

Init:
Init_Random:
;Put Seed in R7
MOV A, #01Fh
MOV R7, A
MOV R0, #030h
MOV @R0, #0C3h

MOV R0, #024h
MOV R1, #024h
JMP GameLoop

Move:
; Move Input into Akku
MOV A, P0

; Check Up
CJNE A, #11111110b, NotUp
JMP MoveUp

NotUp:
; Check Down
CJNE A, #11111101b, NotDown
JMP MoveDown

NotDown:
; Check Left
CJNE A, #11111011b, NotLeft
JMP MoveLeft

NotLeft:
; Check Right
CJNE A, #11110111b, NotRight
JMP MoveRight

NotRight:
JMP Moved

; Improve move : When snake is left or right it should wrap around

MoveUp:
MOV @R0, #0FBh
MOV A, R0
SUBB A, #008h
MOV R0, A

MOV A, @R0
ANL A, #0F0h
CJNE A, #0F0h, NotTailMoveUp
JMP Exception

NotTailMoveUp:
CJNE @R0, #0C3h, NotFruitMoveUp
CALL PutRandomFruit
JMP Moved

NotFruitMoveUp:
MOV @R0, #0FFh
JMP MoveTail


MoveDown:
MOV @R0, #0FCh
MOV A, R0
ADD A, #008h
MOV R0, A

MOV A, @R0
ANL A, #0F0h
CJNE A, #0F0h, NotTailMoveDown
JMP Exception

NotTailMoveDown:
CJNE @R0, #0C3h, NotFruitMoveDown
CALL PutRandomFruit
JMP Moved

NotFruitMoveDown:
MOV @R0, #0FFh
JMP MoveTail


MoveLeft:
MOV @R0, #0FDh
MOV A, R0
SUBB A, #001h
MOV R0, A

MOV A, @R0
ANL A, #0F0h
CJNE A, #0F0h, NotTailMoveLeft
JMP Exception

NotTailMoveLeft:
CJNE @R0, #0C3h, NotFruitMoveLeft
CALL PutRandomFruit
JMP Moved

NotFruitMoveLeft:
MOV @R0, #0FFh
JMP MoveTail


MoveRight:
MOV @R0, #0FEh
MOV A, R0
ADD A, #001h
MOV R0, A

MOV A, @R0
ANL A, #0F0h
CJNE A, #0F0h, NotTailMoveRight
JMP Exception

NotTailMoveRight:
CJNE @R0, #0C3h, NotFruitMoveRight
CALL PutRandomFruit
JMP Moved

NotFruitMoveRight:
MOV @R0, #0FFh
JMP MoveTail


MoveTail:
MOV A, @R1

CJNE A, #0FBh, NotTailUp
JMP TailUp

NotTailUp:
CJNE A, #0FCh, NotTailDown
JMP TailDown

NotTailDown:
CJNE A, #0FDh, NotTailLeft
JMP TailLeft

NotTailLeft:
CJNE A, #0FEh, Exception
JMP TailRight

TailUp:
MOV @R1, #000h
MOV A, R1
SUBB A, #008h
MOV R1, A
JMP Moved

TailDown:
MOV @R1, #000h
MOV A, R1
ADD A, #008h
MOV R1, A
JMP Moved

TailLeft:
MOV @R1, #000h
MOV A, R1
SUBB A, #001h
MOV R1, A
JMP Moved

TailRight:
MOV @R1, #000h
MOV A, R1
ADD A, #001h
MOV R1, A
JMP Moved

GameLoop:
JMP Move
Moved:
JMP GameLoop

PutRandomFruit:

; Save R1
PUSH 0x01
InvalidGenerated:
MOV A, ZUF8R
JNZ ZUB
CPL A
MOV ZUF8R, A
ZUB:
ANL A, #10111000b
MOV C, P
MOV A, ZUF8R
RLC A
MOV ZUF8R, A

ANL A, #00111111b
ADD A, #020h

MOV R1,A
CJNE @R1, #00h, InvalidGenerated
MOV @R1, #0C3h
; Put R1 back
POP 0x01
RET

Exception:
end
