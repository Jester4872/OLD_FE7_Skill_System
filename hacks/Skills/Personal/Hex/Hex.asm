.thumb

@called from 17328
@r0=#0x0002601
@r1=#0x203A452
@r2=#0x0000000
@r3=#0x202BBF8
@r4=#0x203A3F0  attacker struct
@r5=#0x203A470  defender struct
@r6=#0x0000000
@r7=#0x202BD50  character struct
@r8=#0x202CC60
@r9=#0x0000000
@r10=#0x0000000
@r11=#0x3007DFC
@r12=#0x203A470 defender struct 
@r13=#0x3007CF4
@r14=#0x8028D0D
@r15=#0x8017328

push  {r0-r7}
ldr   r5,=#0x203A3F0                @load the attacker struct
ldr   r0,[r5,#0x0]                  @load the pointer to the unit's data
ldrb  r0,[r0,#0x4]                  @load the unit's character ID
cmp   r0,#0x03                      @compare against a chosen character ID
beq   StoreCoordinates              @store the unit's coordinates if a match is found, as they are the skill holder
ldr   r5,=#0x203A470                @load the defender struct
ldr   r0,[r5,#0x0]                  @load the pointer to the unit's data
ldrb  r0,[r0,#0x4]                  @load the unit's character ID
cmp   r0,#0x03                      @compare against a chosen character's ID
beq   StoreCoordinates              @store the unit's coordinates if a match is found, as they are the skill holder
b     LookForSkillHolder            @if all else fails, loop through every character to look for her

StoreCoordinates:
    ldrb  r0,[r5,#0x10]             @load the x coordinate of the unit
    ldrb  r1,[r5,#0x11]             @load the y coordinate of the unit
    b     LookForAffectedUnits      @branch to check the range of surronding enemy units that are affected by the skill

LookForSkillHolder:
    mov r2, #0x03					@character to look for (0x03 for Lyn)
    ldr r3, Unit_Pointers           @load the list of unit pointers inside the ROM (defined at the end of this file)
    mov r6, #0x00                   @r6 will be our counter for unit pointers we've checked
    look_for_unit_skill_user:		@name mangling for copy-pasta-bility
        lsl r4, r6, #0x2            @take the counter value and quadruple it (2^2) as pointers are 4 bytes long
        ldr r5, [r3, r4]            @load the value stored in the pointer
        cmp r5, #0x0 				@is the slot valid?
        beq loop_skill_user 		@if there's no valid value at this poisitoon, we branch and increment the counter
        ldr r4, [r5] 				@load the value stored at the pointer's value (hopefully a character ID)
        cmp r4, #0x0                @is there a character here?
        beq loop_skill_user         @if it's equal to zero, there is no character and we branch to increment the counter
        ldrb r7, [r4, #0x4] 		@character allegiance
        mov  r1, r4                 @prepare r1 with the character struct
        cmp  r7, r2 				@is this the character we're looking for?
        beq  StoreCoordinates       @branch to store the unit's coordinates

loop_skill_user:
	add r6, #0x1                    @increment the unit pointer counter
	cmp r6, #0x3F 				    @have we checked 0x3F units?
	bgt End			                @we've now run out of units to check
	b look_for_unit_skill_user      @else loop back and continue

LookForAffectedUnits:
    ldr   r5,=#0x203A3F0            @load the attacker struct
    ldrb  r2,[r5,#0xB]              @load the unit's allegiance byte
    cmp   r2,#0x80                  @are they an enemy?
    bge   CheckCoordinates          @check coordinates of unit if a match is found
    ldr   r5,=#0x203A470            @load the defender struct
    ldrb  r2,[r5,#0xB]              @load the unit's allegiance byte
    cmp   r2,#0x80                  @are they an enemy?
    bge   CheckCoordinates          @check coordinates of unit if a match is found
    b     End                       @if all else fails we go to the end

CheckCoordinates:
    ldrb    r7,[r5,#0x10]           @load the x coordinate of unit
    ldrb    r6,[r5,#0x11]           @load the y coordinate of unit
    sub     r7,r0                   @subtract the skill holder's x coordinate to get the distance between them
    sub     r6,r1                   @subtract the skill holder's y coordinate to get the distance between them
    @get the absolute value of r7
    asr     r2, r7, #31
    add     r7, r7, r2
    eor     r7, r2
    @get the absolute value of r6
    asr     r2, r6, #31
    add     r6, r6, r2
    eor     r6, r2
    @continue
    cmp     r7,#0x3                 @compare the distance of the x coordinate against our chosen x range
    bgt     End                     @if the distance is greater, the enemy unit is outside the range of effect, so we branch to the end
    cmp     r6,#0x3                 @compare the distance of the y coordinat against our chosen y range
    bgt     End                     @if the distance is greater, the enemy unit is outside the range of effect, so we branch to the end
    b       Hex                     @if the enemy unit is inside the range of effect, we branch to apply the hex skill to them

Hex:
    mov     r2,#0x62                @copy the avoid location byte into a register
    ldrh    r7,[r5,r2]              @load the unit's avoid value
    sub     r7,#0xF                 @subtract 15 (#0xF) from their avoid value
    cmp     r7,#0x0                 @compare the new avoid value against 0
    blt     SetAvoidToZero          @if it's less, branch to prevent a negative final value
    strh    r7,[r5,r2]              @otherwise store the new avoid value
    b       End                     @now branch to the end

SetAvoidToZero:
    mov     r7,#0x0                 @move the new value (0) for the unit's avoid into a register
    strh    r7,[r5,r2]              @store this value as an alternative to a negative avoid value
    b       End                     @now branch to the end

End:
    pop   {r0-r7}                   @restore the values of all the registers we used in this hack
    mov   r1,#0xFF                  @vanilla instruction
    and   r0,r1                     @vanilla instruction
    lsl   r1,r0,#0x3                @vanilla instruction
    and   r1,r1,r0                  @vanilla instruction
    ldr   r3,=#0x8017330|1          @harcode return address
    bx    r3                        @return to the vanilla function

.align
Unit_Pointers:                      @list of unit pointers in the ROM
	.long 0x08B92EB0

.align
Unit_Enemy_Pointers:                @list of unit pointers in the RAM (starting from the first enemy on the map)
    .long 0x0202CEC0
