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

push	{r14}
mov		r4,r2			@move the address of the equipped item and uses after battle into r4 from r2
ldrh	r0,[r4]			@load half word value from r4 into r0
mov		r1,r5			@move the attacker struct back into r1 from r5
add		r1,#0x4A		@add the value in the attacker struct that holds the equipped item and uses before battle

@new code
push	{r2}
push	{r5}
ldrh	r2,[r1]			@load the before battle item uses into r2
cmp		r2,	r0			@compare and branch if no weapon uses are expended
bne		End
ldr		r5,=#0x203A470  @load the defender struct into r5
ldrb	r5,[r5,#0x13]	@load the current hp byte for the defender
cmp		r5,#0			@if the current hp of the defender is 0, then branch
beq		GoldDigger
b		End

GoldDigger:
push	{r0,r4}			@preserve the after battle item uses into r0
sub		r2,r0			@store the difference between the before and after battle item uses into r2
add		r2,#0x64		@add 100 in hex to the gold to add (r4 equals 0 for some reason so can't use mul for now)		
ldr		r0,=#0x202BBF8 	@load the address for the chapter data struct into r0
ldr		r4,[r0,#0x8]	@load the offset value for money into r4
add		r4,r2			@add the money generated to the total
str		r4,[r0, #0x8]	@store the new money value back to its original place
pop		{r0,r4}			@restore the old values of r0 and r4 from the stack
b		End

End:
pop		{r5}
pop		{r2}
ldr		r3,=#0x8BE222C
strh	r0,[r1]			@store the new after battle item uses into r1
ldrh	r0,[r4]
pop		{r6}
bx		r6

