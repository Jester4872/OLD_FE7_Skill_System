.thumb

@called from 288AC (first instance of 5)
@r0=#0x0002D1F word for uses of first item and position of it
@r1=#0x203A4C1
@r2=#0x203A4B8
@r3=#0x8BE222C
@r4=#0x0000000
@r5=#0x203A3F0 attacker struct
@r6=#0x202BD50 character struct
@r7=#0x202CEC0
@r8=#0x203A4C1
@r9=#0x203A4C2
@r10=#0x0000000
@r11=#0x3007DFC
@r12=#0x203DFF8
@r13=#0x3007D24
@r14=#0x80163C9

@right now it's 200g on player phase and 100g on enemy phase

push	{r14}
mov		r4,r2			    @vanilla instruction 1 - move the address of the equipped item and uses after battle into r4 from r2
ldrh	r0,[r4]			    @vanilla instruction 2 - load half word value from r4 into r0
mov		r1,r5			    @vanilla instruction 3 - move the attacker struct back into r1 from r5
add		r1,#0x4A		    @vanilla instruction 4 - add the value in the attacker struct that holds the equipped item and uses before battle
push	{r2-r4,r5}		    
ldrh	r2,[r2]			    @load the before battle item uses into r2
cmp		r2,	r0			    @compare and branch if no weapon uses are expended
bne		End
b		CheckBattleStruct

CheckBattleStruct:
    ldr     r4,[r5,#0x0]
    ldrb    r4,[r4,#0x4]
    ldr     r3,GoldDiggerID
    cmp     r4,r3
    beq     CheckCharacterStructs
    b       End

CheckCharacterStructs:
    ldr     r4,[r6,#0x0]
    ldrb    r4,[r4,#0x4]
    cmp     r4,r3
    beq     GoldDigger
    ldr     r4,[r7,#0x0]
    ldrb    r4,[r4,#0x4]
    cmp     r4,r3
    beq     GoldDigger
    b       End

GoldDigger:
    push    {r0}
    mov     r5,#0x0
    sub		r2,r0			@store the difference between the before and after battle item uses into r2
    ldr     r0,=#0x202BBF8  @since the gold will be added twice on player phase, we check the phase here to see if we should halve it
    ldrb    r4,[r0,#0xF]    @load the byte phase from the chapter struct we loaded
    cmp     r4,#0x80
    bge     Enemy_Apply
    add		r5,#0x32		@add 50 in hex to the gold to add (r4 equals 0 for some reason so can't use mul for now)		
    ldr		r4,[r0,#0x8]	@load the chapter struct offset value for money into r4
    add		r4,r5			@add the money generated to the total
    str		r4,[r0, #0x8]	@store the new money value back to its original place
    pop     {r0}
    b		End

Enemy_Apply:
    add		r5,#0x64		@add 100 in hex to the gold to add (r4 equals 0 for some reason so can't use mul for now)		
    ldr		r4,[r0,#0x8]	@load the chapter struct offset value for money into r4
    add		r4,r5			@add the money generated to the total
    str		r4,[r0, #0x8]	@store the new money value back to its original place
    pop     {r0}
    b		End

End:
    pop		{r2-r4,r5}		@restore the old values of these registers from the stack
    ldr		r3,=#0x8BE222C  @restore this value into r3 that was overwritten when we branched to this hack
    strh	r0,[r1]			@vanilla instruction 5 - store the new after battle item uses into r1
    ldrh	r0,[r4]         @vanilla instruction 6
    pop		{r6}
    bx		r6

.ltorg
.align
GoldDiggerID:               @refer to the value defined in the event file
