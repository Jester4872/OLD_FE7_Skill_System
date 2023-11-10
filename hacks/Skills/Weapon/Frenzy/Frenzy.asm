.thumb

@called from 28B54
@r0=#0x0000000
@r1=#0x203A3F0 attacker struct
@r2=#0x8C97EAC
@r3=#0x0000004
@r4=#0x203A470 defender struct
@r5=#0x203A3F0 attacker struct
@r6=#0x203A438 attacker struct weapon and uses
@r7=#0x202BD50 character struct
@r8=#0x000000B
@r9=#0x0000000
@r10=#0x0000000
@r11=#0x3007DFC
@r12=#0x203A470 defender struct
@r13=#0x3007CE8
@r14=#0x8028B3B
@r15=#0x8028B54

@Todo - Right now it only applies on each side's attacking phase
@it must apply to both sides, perhaps to a turn phase check to set everything up?

push	{r14}
b     CheckEquippedWeaponAtk

CheckEquippedWeaponAtk:
    add		r1,#0x5A		@total might bit
    mov 	r0,#0x4A		@equipped item and uses before battle
    ldrb	r0,[r5, r0]		@load equipped item and uses before battle for the attacker
    mov		r3,r0
    ldrh    r2,[r1]       	@store weapon might?
    mov		r0,#0x14		@strength bit
    ldsb 	r0,[r5,r0] 		@strength
    add 	r0,r2 			@add weapon might (stored in r2) to value used to calculate strength (stored in r0)
    cmp 	r3,#0x01		@equipped item is Iron Sword
    beq 	FrenzyAtk
    strh	r0,[r1] 		@transfer and store the total might from r0 to r1
    b       CheckEquippedWeaponDef

CheckEquippedWeaponDef:
    add		r1,#0x5A		@total might bit
    mov 	r0,#0x4A		@equipped item and uses before battle
    ldrb	r0,[r4, r0]		@load equipped item and uses before battle for the attacker
    mov		r3,r0
    ldrh    r2,[r1]       	@store weapon might?
    mov		r0,#0x14		@strength bit
    ldsb 	r0,[r4,r0] 		@strength
    add 	r0,r2 			@add weapon might (stored in r2) to value used to calculate strength (stored in r0)
    cmp 	r3,#0x01		@equipped item is Iron Sword
    beq 	FrenzyDef
    strh	r0,[r1] 		@transfer and store the total might from r0 to r1
    b       End

FrenzyAtk:
    push    {r1,r2}
    mov     r1, #0x12       @max hp byte
    mov     r2, #0x13       @current hp byte
    ldrb    r1,[r1,r5]      @load value of max hp
    ldrb    r2,[r2,r5]      @load value of current hp
    sub     r1,r1,r2        @calculate the difference between the max hp and current hp
    asr     r1,#2           @divide the result by 4
    add     r0,r1           @add it onto the final attack value
    pop     {r1,r2}         @restore the values we pushed earlier
    strh	r0,[r1] 		@transfer and store the total might from r0 to r1
    b       CheckEquippedWeaponDef

FrenzyDef:
    push    {r1,r2}
    mov     r1, #0x12       @max hp byte
    mov     r2, #0x13       @current hp byte
    ldrb    r1,[r1,r4]      @load value of max hp
    ldrb    r2,[r2,r4]      @load value of current hp
    sub     r1,r1,r2        @calculate the difference between the max hp and current hp
    asr     r1,#2           @divide the result by 4
    add     r0,r1           @add it onto the final attack value
    pop     {r1,r2}         @restore the values we pushed earlier
    strh	r0,[r1] 		@transfer and store the total might from r0 to r1
    b		End

End:
    pop 	{r0}			@pop the return address stored in r14 into r0
    bx		r0				@exit the subroutine and return to the address in r0




