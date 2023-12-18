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

push	{r4,r14}
add		r1,#0x5A		@total might bit
ldr     r5,[r5,#0x0]    @load the location of their characer data in the ROM
ldrb	r0,[r5,#0x4]	@load equipped item and uses before battle for the attacker
mov		r3,r0           @move this value from r0 to r3 for later comparison
ldrh    r2,[r1]       	@load weapon might
mov		r0,#0x14		@get the strength bit
ldsb 	r0,[r5,r0] 		@load the strength value
add 	r0,r2 			@add weapon might (stored in r2) to value used to calculate strength (stored in r0)
mov     r4,r1           @copy over the battle struct so we don't have to overwrite it when we load the DeathBlowWeaponID below
ldr     r4,DeathBlowID  @load the ID value we have defined
cmp     r3,r4           @check if equipped item is what we want	
beq 	DeathBlow       @apply Death Blow if it is
b 		End             @otherwise we branch to the end

DeathBlow:
    add		r0,#6		@add +6 to the final damage total
    b		End

End:
    strh	r0,[r1] 	@transfer and store the total might from r0 to r1
    pop     {r4}
    pop 	{r0}		@pop the return address stored in r14 into r0
    bx		r0			@exit the subroutine and return to the address in r0

.ltorg
.align
DeathBlowID:            @refer to the value defined in the event file
