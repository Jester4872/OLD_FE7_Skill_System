.thumb
 
# called at 28FB8
# check that the attacker is not blue
# and check that the defender is blue
ldr r0, AttackerAddr
ldr r1, DefenderAddr
ldrb r0, [r0, #0xB]	@load deployment byte from attacker struct (player or enemy)
ldrb r1, [r1, #0xB]	@load deployment byte from defender struct (player or enemy)
mov r2, #0x80		@load enemy allegiance bit
and r0, r2			@trim the trailing bits of the allegiance value
and r1, r2			@trim the trailing bits of the allegiance value
cmp r0, #0x80		@is the attacker an enemy?
bne Abort			@if not, don't apply Vantage
cmp r1, #0x0		@is the defender a player?
bne Abort			@if not, don't apply Vantage
 
# check that the defending blue unit is armed
# a unit not being armed is the game's signal not to counter
ldr r0, DefenderAddr
mov r1, #0x48
ldrh r0, [r0, r1]
cmp r0, #0x0
beq Abort
 
# reverse turn order here
add r4,sp,#0x4
mov r0, r13
mov r1, r4
ldr r2, DefenderAddr
str r2, [r0]
ldr r0, AttackerAddr
str r0, [r1]
b		End
 
Abort:
add r4,sp,#0x4
mov r0, r13
mov r1, r4
ldr r2, AttackerAddr
str r2, [r0]
ldr r0, DefenderAddr
str r0, [r1]
 
End:
ldr	r0,=#0x8028FC5
bx r0
 
.align 2
AttackerAddr: .word 0x0203A3F0
DefenderAddr: .word 0x0203A470
