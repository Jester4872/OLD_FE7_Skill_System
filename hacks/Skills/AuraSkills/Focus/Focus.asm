.thumb

@called from 28D18
@r0=#0x0000000
@r1=#0x0000000
@r2=#0x0000000
@r3=#0x202BBF8  character struct - ally?
@r4=#0x203A3F0  attacker struct
@r5=#0x203A470  defender struct
@r6=#0x202BD50  character struct
@r7=#0x203A470  defender struct
@r8=#0x202CF50  character struct - enemy?
@r9=#0x202BD50  character struct - ally unit in fight
@r10=#0x3004690 pointer to currently selected unit
@r11=#0x3007DFC
@r12=#0x30041E0
@r13=#0x3007BF8
@r14=#0x8028D0D
@r15=#0x8028D18

mov  r3,r4                       @vanilla instruction - move the crit rate short from r4 to r3
add  r3,#0x66                    @vanilla instruction - add the crit rate short to the battle struct
strh r2,[r3]                     @vanilla instruction - store the crit rate short's value
ldr  r0,[r4]                     @vanilla instruction
push {r0-r7}                     @preserve the values of registers 0-7
ldr  r3,=#0x203A3F0              @load the attacker struct
ldr  r0,[r3,#0x0]                @load the RAM unit data from the attacker struct
ldrb r0,[r0,#0x4]                @load the unit ID
mov  r2,r0                       @copy over the battle struct to prevent overwriting it
ldr  r2,FocusID                  @load the ID value we have defined
cmp  r0,r2                       @compare against our chosen unit ID
beq  StoreCoordinates            @if it's a match, we store this unit's coordinates
ldr  r3,=#0x203A470              @load the defender struct
ldr  r0,[r3,#0x0]                @load the RAM unit data from the defender struct
ldrb r0,[r0,#0x4]                @load the unit ID
mov  r2,r0                       @copy over the battle struct to prevent overwriting it
ldr  r2,FocusID                  @load the ID value we have defined
cmp  r0,r2                       @compare against our chosen unit ID
beq  StoreCoordinates            @if it's a match, we store this unit's coordinates
b    End_Extra_Pop               @if the unit is in neither struct, we branch to the end

StoreCoordinates:
    push {r3}                    @save this character struct for later retrieval when applying the skill
    ldrb r0,[r3,#0x10]           @load the x coordinate of the unit
    ldrb r1,[r3,#0x11]           @load the y coordinate of the unit
    b    LookForAlliedUnits      @branch to check the range of surrounding enemy units that are affected by the skill

LookForAlliedUnits:
    mov r2,#0x40                 @#0x40 (64) is the upper unit limit for a faction, we'll be comparing the allegiance byte of each unit to this
    ldr r3,Unit_Pointers         @load the list of unit pointers inside the ROM (defined at the end of this file)
    mov r6,#0x00                 @r6 will be our counter for unit pointers we've checked
    loop_through_allied_units:	 @name mangling for copy-pasta-bility
        lsl  r4,r6,#0x2          @take the counter value and quadruple it (2^2) as pointers are 4 bytes long (and then store that in r4)
        ldr  r5,[r3,r4]          @load the value stored in the pointer
        cmp  r5,#0x0 			 @is the slot valid?
        beq  LoopAddCounter 	 @if there's no valid value at this poisiton, we branch and increment the counter
        ldr  r4,[r5] 			 @load the value stored at the pointer's value (hopefully a character ID)
        cmp  r4,#0x0             @is there a character here?
        beq  LoopAddCounter      @if it's equal to zero, there is no character and we branch to increment the counter
        ldrb r7,[r4,#0x4] 		 @character allegiance
        cmp  r7,r2 			     @is this character within the range of the defined faction?
        ble  CheckCoordinates    @if so, branch to check the unit's coordinates

LoopAddCounter:
	add  r6,#0x1                 @increment the unit pointer counter
	cmp  r6,#0x3F 				 @have we checked 0x3F units?
	bgt  CheckBitFlag			 @we've now run out of units to check, and since they're all outside the range, we can perform additional checks
	b    loop_through_allied_units @else loop back and continue

CheckCoordinates:
    ldrb r7,[r4,#0x10]           @load the x coordinate of unit
    ldrb r6,[r4,#0x11]           @load the y coordinate of unit
    sub  r7,r0                   @subtract the skill holder's x coordinate to get the distance between them
    sub  r6,r1                   @subtract the skill holder's y coordinate to get the distance between them
    @get the absolute value of r7
    asr  r2, r7, #31
    add  r7, r7, r2
    eor  r7, r2
    @get the absolute value of r6
    asr  r2, r6, #31
    add  r6, r6, r2
    eor  r6, r2
    @continue
    cmp  r7,#0x3                 @compare the distance of the x coordinate against our chosen x range
    ble  End                     @if the distance is less or equal, the ally unit is too close, so we branch to the end
    cmp  r6,#0x3                 @compare the distance of the y coordinat against our chosen y range
    ble  End                     @if the distance is less or equal, the ally unit is too close, so we branch to the end
    b    LoopAddCounter          @this ally unit is outside the range so we move onto the next one

CheckBitFlag:
    pop  {r3}                    @retrieve the character struct of the unit who has the skill
    mov  r1,#0x47                @undocumented in the teq doq, we'll store the bitflag here
    ldrb r0,[r3,r1]              @get the value of this byte
    cmp  r0,#0xFF                @check if the bitflag has been set
    beq  End_Extra_Pop           @if it has, branch to the end
    b    Focus                   @otherwise, we're free to apply the skill

Focus:
    mov  r0,#0x66                @get the crit rate short 
    ldrh r2,[r3,r0]              @load the crit rate value
    add  r2,#0xA                 @add 10 to it
    strh r2,[r3,r0]              @store the new value
    b    CheckPhase              @set the bit flag so it can't be applied twice on in one round

CheckPhase:
    ldr		r0,=#0x202BBF8	     @load chapter struct
    mov		r2,#0xF			     @get turn phase byte
    ldrb	r0,[r0,r2]		     @load turn phase
    cmp		r0,#0x0			     @player phase byte for comparison
    beq		SetBitFlag	         @if player phase, navigate to SetBitFlag (as the critical boost would otherwise apply twice on the turn of this unit's affiliation).
    cmp		r0,#0x80		     @enemy phase byte for comparison
    beq		End_Extra_Pop	     @if enemy phase, branch to the end

SetBitFlag:
    ldrb r0,[r3,r1]              @undocumented in the teq doq, we'll store the bitflag here
    mov  r0,#0xFF                @set the bitflag value to check to #0xFF
    strb r0,[r3,r1]              @store the new value
    b    End_Extra_Pop           @we've done everything we wanted to do, so branch to the end

End:
    pop  {r3}                    @we didn't end up using the saved character struct
    pop  {r0-r7}                 @restore the values of all the registers we used in this hack
    ldr  r3,=#0x8028D20|1        @harcode return address
    bx   r3                      @return to the vanilla function

End_Extra_Pop:
    pop  {r0-r7}                 @restore the values of all the registers we used in this hack
    ldr  r3,=#0x8028D20|1        @harcode return address
    bx   r3                      @return to the vanilla function

.align
Unit_Pointers:                   @list of unit pointers in the ROM
	.long 0x08B92EB0

.ltorg
.align
FocusID:                        @refer to the value defined in the event file

