.thumb

@called from 161B0
@r0=#0x202BD50  character struct
@r1=#0x000280A  weapon uses and id
@r2=#0x0000007
@r3=#0x3007D5D
@r4=#0x202BD50  character struct
@r5=#0x000280A  weapon uses and id
@r6=#0x202BD50
@r7=#0x3007DFC
@r8=#0x202BD89  support partner bitfield?
@r9=#0x0000000
@r10=#0x0000000
@r11=#0x3007DFC
@r12=#0x2025149
@r13=#0x3007D1C
@r14=#0x801677B
@r15=#0x80161B0

push    {r14}
mov     r1,#0xFF
push    {r5}
ldr     r5,[r0,#0x0]		@load pointer to character data
ldrb	r5,[r5,#0x4]		@load character ID byte
mov     r2,r5               @copy over the battle struct to prevent overwriting it
ldr     r2,HPPlus5ID        @load the ID value we have defined    
cmp		r5,r2 			    @compare the loaded character ID byte to our chosen character ID
beq     CheckUnitHP         @if we find a match, branch to check the unit's HP
b       End                 @otherwise we brancg to the end

CheckUnitHP:
    ldrb    r5,[r0,#0x12]   @load the units max HP
    cmp     r5,#0x0         @run a comparison check on the value
    bne     CheckBitFlag    @check the bitflag of the unit's hp is loaded (it isn't 0)
    b       End             @otherwise branch to the end

CheckBitFlag:
    ldrb    r5,[r0,#0x1C]   @we'll use the ballista data byte to store the bit flag and load its value
    mov     r2,#0xFF        @move the `set` value into r2
    cmp     r5,r2           @compare the values in both registers
    bne     ApplyHPPlus5    @if they're not equal (i.e the bit is not `set`) we can apply the boost
    b       End             @otherwise we branch to the end

ApplyHPPlus5:
    ldrb    r5,[r0,#0x12]   @load current hp
    add     r5,#5           @add 5 to current hp
    strb    r5,[r0,#0x12]   @store new current hp value
    mov     r3,#0xFF        @get 'HP applied' bit
    strb    r3,[r0,#0x1C]   @store it in the ballista data, anyone who isn't an archer isn't using it
    b       End

End:
    pop     {r5}
    ldr     r3,=#0x3007D5D
    and     r1,r5           @vanilla instruction
    lsl     r0,r1,#0x3      @vanilla instruction
    add     r0,r0,r1        @vanilla instruction
    lsl     r0,r0,#0x2      @vanilla instruction
    ldr     r1,=#0x8BE222C  @vanilla instruction
    pop     {r2}
    bx      r2
    
.ltorg
.align
HPPlus5ID:                  @refer to the value defined in the event file
