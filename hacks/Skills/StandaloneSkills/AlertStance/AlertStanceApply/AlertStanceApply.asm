.thumb

@called from 28C6E
@r0=#0x0000012 avoid value before luck is added
@r1=#0x203A452 luck value
@r2=#0x0000000
@r3=#0x202BBF8 chapter data struct
@r4=#0x203A3F0 attacker struct
@r5=#0x0000018 avoid after luck has been added
@r6=#0x203A3F0 attacker struct
@r7=#0x202BD50 character struct
@r8=#0x2022C60
@r9=#0x0000000
@r10=#0x0000000
@r11=#0x3007DFC
@r12=#0x203A470 defender struct
@r13=#0x3007CEC
@r14=#0x80289D5
@r15=#0x8028CE0

.equ gActionData, 	0x203A85C

push	{r14}
push	{r0-r3}
ldr		r0,=#0x202BBF8	@load chapter struct
mov		r1,#0xF			@get turn phase byte
ldrb	r0,[r0,r1]		@load turn phase
cmp		r0,#0x0			@player phase byte for comparison
beq		CheckCharacter	@if player phase, navigate to CheckCharacter
cmp		r0,#0x80		@enemy phase byte for comparison
beq		CheckBitFlag	@if enemy phase, load CheckBitFlag

resetBitFlag:
ldr		r0,=#0x202BD50
mov		r2,#0x3A		@grab an unused byte from their struct
mov		r1,#0x0			@grab the value that will act as the reset
strb	r1,[r0,r2]		@store the reset value in the bitflag
b 		End

CheckCharacter:
ldr		r3,=#0x203A3F0	@load the attacker struct
ldr		r2,[r3,#0x0]	@load pointer to character data
ldrb	r2,[r2,#0x4]	@load character ID byte
cmp		r2,#0x03 		@compare the loaded character ID byte to Lyn's ID
beq		resetBitFlag	@if the current ID matches Lyn's ID, then branch to resetBigFlag
b 		End

CheckBitFlag:
ldr		r3,=#0x203A470	@load the defender struct in RAM
mov		r1,#0x3A		@use this offset to store the bitflag
ldrb	r1,[r3,r1]		@load the offset
cmp		r1,#0xFF		@compare against #0xFF (bitflag is set)
beq		AlertStance		@branch and apply AlertStance if the bitflag is set
b 		End				@otherwise proceed to end

CheckAction:
ldr		r1,=gActionData	@get the action data
ldrb	r0,[r1,#0x11] 	@load the action byte (action taken this turn)
cmp		r0,#1 		  	@if the player waited (#1) branch to AlertStance
beq		AlertStance		
b 		End

AlertStance:
mov		r2,#0x62		@get the avoid byte
ldrb	r1,[r3,r2]		@load the avoid value
add		r1,#0x14		@add 20 (14 in hex) to the avoid value
strh	r1,[r3,r2]		@store the new avoid value
b 		End

End:
pop		{r0-r3}			@restore the original values of registers 0-3 we pushed at the start
ldr		r3,=#0x202BBF8  @load the chapter struct
pop		{r2}			@pop the return address
bx		r2				@return to before the hook point
