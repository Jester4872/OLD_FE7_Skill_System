.thumb

@called from 19CE8
@r0=#0x8BE3888
@r1=#0x0000800
@r2=#0x0000000
@r3=#0x8BE3888
@r4=#0x30043F0
@r5=#0x202BD50  character struct
@r6=#0x202BD50  character struct
@r7=#0x3007DD8
@r8=#0x0000000
@r9=#0x0000000
@r10=#0x0000000
@r11=#0x3007DFC
@r12=#0x0000001
@r13=#0x3007D74
@r14=#0x8019BF1
@r15=#0x8019CE8

@Note r0 currently holds the movement costs for 
@lords, swordmasters, heroes and snipers
@for other units you will need to grab the movement cost hex location
@in FEBuilder's class menu and find a new breakpoint on that to hook into

b       LoadMovementCost

LoadMovementCost:
ldr     r3,=#0x8BE3888
add     r0,r2,r4
add     r1,r3,r2
ldrb    r1,[r1]
mov     r1,#0x1                 @change movement cost to 1?
strb    r1,[r0]
add     r2,#0x1
b       EndOrContinue

EndOrContinue:
cmp     r2,#0x40
ble     LoadMovementCost
ldr     r4,=#0x8019CF6|1
bx      r4
