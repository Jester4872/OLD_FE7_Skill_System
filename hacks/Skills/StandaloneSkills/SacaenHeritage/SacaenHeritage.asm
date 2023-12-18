.thumb

@called from 28CE0
@r0=#0x0000001
@r1=#0x203A452 attacker avoid address
@r2=#0x0000001
@r3=#0x202BBF8 chapter data struct
@r4=#0x203A3F0 attacker struct
@r5=#0x000002D
@r6=#0x203A452 attacker avoid address
@r7=#0x202BD50 character struct
@r8=#0x000000B
@r9=#0x0000000
@r10=#0x0000000
@r11=#0x3007DFC
@r12=#0x203A470 defender struct
@r13=#0x3007CE8
@r14=#0x80289D5
@r15=#0x8028CE0

push	{r14}                   @preserve the return address on the stack
mov		r2,#0                   @move #0x0 into r2
ldsh	r0,[r1,r2]			    @load avoid value for attacker
push	{r0-r3}                 @preserve the values of these registers on the stack
ldr 	r1,=#0x203A3F0		    @load the attacker struct
ldr		r2,=#0x203A470		    @load the defender struct
ldrb 	r1, [r1, #0xB]		    @load deployment byte from attacker struct (player or enemy)
ldrb 	r2, [r2, #0xB]		    @load deployment byte from defender struct (player or enemy)
mov 	r3, #0x80			    @load enemy allegiance bit
and 	r1, r3				    @trim the trailing bits of the allegiance value
and 	r2, r3				    @trim the trailing bits of the allegiance value
cmp 	r1, #0x80			    @is the attacker an enemy?
bne 	CheckCharacterAtk	    @branch if false
cmp 	r2, #0x80			    @is the defender an enemy?
bne 	CheckCharacterDef	    @branch if false
b 		End                     @otherwise branch to the end

CheckCharacterAtk:
    ldr		r0,=#0x203A3F0		@load the character struct
    ldr		r2,[r0,#0x0]		@load pointer to character data
    ldrb	r2,[r2,#0x4]		@load character ID byte
    ldr     r3,SacaenHeritageID @load the value we defined in the event file
    cmp     r3,r2               @compare it against our chosen unit ID
    beq		CheckTileAtk		@if the current ID matches Lyn's ID, then branch to SacaenHeritage
    b 		End                 @otherwise branch to the end

CheckCharacterDef:
    ldr		r0,=#0x203A470		@load the character struct
    ldr		r2,[r0,#0x0]		@load pointer to character data
    ldrb	r2,[r2,#0x4]		@load character ID byte
    ldr     r3,SacaenHeritageID @load the value we defined in the event file
    cmp     r3,r2               @compare it against our chosen unit ID
    beq		CheckTileDef		@if the current ID matches Lyn's ID, then branch to SacaenHeritage
    b 		End                 @otherwise branch to the end

CheckTileAtk:
    mov		r3,r0               @copy the attacker struct we have chosen into r3
    mov		r2,#0x55            @get the terrain tile ID byte
    ldrb	r3,[r3,r2]          @load this value
    cmp		r3,#1               @check to see if the the ID of the tile is a plain (#0x1)
    beq		SacaenHeritage      @if so, apply the SacaenHeritage
    b 		End                 @otherwise, branch to the end

CheckTileDef:
    mov		r3,r0               @copy the defender struct we have chosen into r3
    mov		r2,#0x55            @get the terrain tile ID byte
    ldrb	r3,[r3,r2]          @load this value
    cmp		r3,#1               @check to see if the the ID of the tile is a plain (#0x1)
    beq		SacaenHeritage      @if so, apply the SacaenHeritage
    b 		End                 @otherwise, branch to the end

SacaenHeritage:
    mov		r3,r0               @copy over the chosen battle struct into r3 again
    mov		r2,#0x62            @get the avoid byte
    ldsh	r0,[r3,r2]          @load its value
    add		r0,#0x14			@add 20 to the avoid
    strh	r0,[r3,r2]          @store the new value
    b		End                 @now branch to the end

End:
    pop		{r0-r3}             @restore the values we pushed to the stack into their respective registers
    ldr		r3,=#0x202BBF8 		@load the chapter struct
    pop		{r2}				@pop the return address
    bx		r2					@return to before the hook point
 
 .ltorg
.align
SacaenHeritageID:               @refer to the value defined in the event file
