.thumb

@called from 28D20
@r0=#0x8BDCEB4  attacker struct character data
@r1=#0x0000004
@r2=#0x0000018
@r3=#0x203A456
@r4=#0x203A3F0  attacker struct
@r5=#0x203A470  defender struct
@r6=#0x202CEC0  
@r7=#0x203A470  defender struct
@r8=#0x202BD50  character struct
@r9=#0x202CEC0
@r10=#0x0000000
@r11=#0x3007DFC
@r12=#0x203DFF8
@r13=#0x3007DFC
@r14=#0x8028D0D
@r15=#0x8028D20

push    {r14}
push    {r0-r3}
ldr		r0,=#0x202BBF8	          @load chapter struct
mov		r1,#0xF			          @get turn phase byte
ldrb	r0,[r0,r1]		          @load turn phase
cmp		r0,#0x0			          @player phase byte for comparison
beq		CheckBitFlag    	      @if player phase, navigate to CheckBitFlag
cmp		r0,#0x80		          @enemy phase byte for comparison
beq		ResetBitFlag              @if enemy phase, load ResetBitFlag

CheckCharacterAtk:
    ldr		r3,=#0x203A3F0	      @load the attacker struct
    ldr		r2,[r3,#0x0]	      @load pointer to character data
    ldrb	r2,[r2,#0x4]	      @load character ID byte
    cmp		r2,#0x03 		      @compare the loaded character ID byte to Lyn's ID
    beq		CheckEnemyWeaponDef   @if the current ID matches Lyn's ID, then branch to CheckEnemyWeaponAtk
    b 		End

CheckCharacterDef:
    ldr		r3,=#0x203A470	      @load the attacker struct
    ldr		r2,[r3,#0x0]	      @load pointer to character data
    ldrb	r2,[r2,#0x4]	      @load character ID byte
    cmp		r2,#0x03 		      @compare the loaded character ID byte to Lyn's ID
    beq		CheckEnemyWeaponAtk   @if the current ID matches Lyn's ID, then branch to CheckEnemyWeaponDef
    b 		End

CheckEnemyWeaponAtk:
    ldr     r3,=#0x203A3F0        @the enemy's stats are within the attacker struct
    mov     r2,#0x50
    ldrb	r2,[r3,r2]	          @load the weapon type
    cmp     r2,#0x0               @is the enemy weapon type a sword?
    beq     ApplySwordbreakerDef  @apply Swordbreaker if so
    b       End                   @otherwise branch to the end

CheckEnemyWeaponDef:
    ldr     r3,=#0x203A470        @the enemy's stats are within the defender struct
    mov     r2,#0x50
    ldrb	r2,[r3,r2]	          @load the weapon type
    cmp     r2,#0x0               @is the enemy weapon type an sword?
    beq     ApplySwordbreakerAtk  @apply Swordbreaker if so
    b       End                   @otherwise branch to the end

ApplySwordbreakerAtk:
    ldr     r3,=#0x203A3F0        @the player's stats are within the attacker struct
    mov     r1,#0x60
    ldrb	r2,[r3,r1]	          @load the weapon type
    add     r2,#0x14              @add 20 to hit rate
    strb    r2,[r3,r1]            @store the new hit rate
    mov     r1,#0x62
    ldrh    r2,[r3,r1]            @load avoid rate
    add     r2,#0x14              @add 20 to avoid rate
    strb    r2,[r3,r1]            @store the new avoid rate
    mov     r1,#0x1C              @get the byte for the ballista data
    mov     r2,#0xFF              @get the bitflag value to set that byte to
    strb    r2,[r3,r1]            @store the bitflag (so we know not to apply the skill twice in succession)
    b       SetBitFlag

ApplySwordbreakerDef:
    ldr     r3,=#0x203A470        @the player's stats are within the defender struct
    mov     r1,#0x60
    ldrh    r2,[r3,r1]            @load hit rate
    add     r2,#0x14              @add 20 to hit rate
    strb    r2,[r3,r1]            @store the new hit rate
    mov     r1,#0x62
    ldrh    r2,[r3,r1]            @load avoid rate
    add     r2,#0x14              @add 20 to avoid rate
    strb    r2,[r3,r1]            @store the new avoid rate
    b       End

SetBitFlag:
    ldr     r3,=#0x203A3F0
    mov     r1,#0x1C              @get the ballista data byte
    mov     r2,#0xFF              @get the value to set the bitflag too (when Swordbreaker is applied)
    strb    r2,[r3,r1]
    b       End

CheckBitFlag:
    ldr     r3,=#0x203A3F0
    mov     r1,#0x1C              @get the ballista data byte
    ldrb    r2,[r3,r1]            @load the value of the bitflag
    cmp     r2,#0xFF              @check the value of the bitflag
    bne     CheckCharacterAtk     @check the character id now
    b       End                   @otherwise branch to the end

ResetBitFlag:
    ldr     r3,=#0x203A470
    mov     r1,#0x1C              @get the ballista data byte
    mov     r2,#0x00              @get the value to set the bitflag too (when Swordbreaker is applied)
    strb    r2,[r3,r1]
    b       CheckCharacterDef     @check the identity of the defending character

End:
    pop     {r0-r3}             
    ldr     r1,[r4,#0x4]
    ldr     r0,[r0,#0x28]
    ldr     r1,[r1,#0x28]
    orr     r0,r1
    mov     r1,#0x40
    and     r0,r1
    pop     {r4}
    bx      r4
