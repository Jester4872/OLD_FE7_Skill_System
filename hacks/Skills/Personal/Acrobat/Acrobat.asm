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

push    {r5,r6}                 @push registers for character id check here, so we only do it once
ldr     r6,=#0x3004690          @load the struct for the current selected unit
ldr     r6,[r6,#0x0]            @load the pointer to character data
ldr     r6,[r6,#0x0]            @load the pointer to character data
ldrb    r5,[r6,#0x4]            @load the character ID byte
b       LoadMovementCost        @vanilla instructions to load the movement cost of a tile

LoadMovementCost:               @check the movement cost of each tile and store in unit specific map for retrieval
    ldr     r3,=#0x8BE3888
    add     r0,r2,r4
    add     r1,r3,r2
    ldrb    r1,[r1]
    b       CheckCharacter      

CheckCharacter:
    cmp		r5,#0x03 		    @compare the loaded character ID byte to Lyn's ID
    beq     CanMoveOnTile       @check if the unit can move onto the tile if so
    b       StoreBaseCost       @branch to the end otherwise

CanMoveOnTile:
    cmp     r1,#0xFF            @check to see if the unit can move on the tile (a wall for example will be 0xFF)
    bne     ApplyAcrobat        @if they can, apply Acrobat otherwise they can't move onto the tile normally and we store the ID
    b       StoreBaseCost

StoreBaseCost:
    strb    r1,[r0]             @store the movement cost on the tile
    add     r2,#0x1             @increment the tile counter by 1 (up to a maximum of 40)
    b       EndOrContinue       @branch to see if we should end the loop

ApplyAcrobat:
    mov     r1,#0x1             @change movement cost to 1?
    strb    r1,[r0]             @store the movement cost on the tile
    add     r2,#0x1             @increment the tile counter by 1 (up to a maximum of 40)
    b       EndOrContinue

EndOrContinue:
    cmp     r2,#0x40            @check to see if all movement cost tiles/spaces have been checked
    ble     LoadMovementCost    @check the next byte if not
    b       End                 @otherwise branch to the end

End:
    pop    {r5,r6}              @restore the r5 and r6 registers we pushed earlier
    ldr     r4,=#0x8019CF6|1    @the function we bx'd from is complicated to branch back to without a hard-coded address
    bx      r4                  @branch back to the vanilla function
