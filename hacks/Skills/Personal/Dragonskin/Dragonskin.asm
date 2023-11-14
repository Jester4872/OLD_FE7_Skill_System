.thumb

@called from 293A0
@r0=#0x203A470  defender struct
@r1=#0x203A3F0  attacker struct
@r2=#0x0000004
@r3=#0x0000000
@r4=#0x203A470
@r5=#0x203A470
@r6=#0x203A470  
@r7=#0x0000008
@r8=#0x203A3F0
@r9=#0x202CEC0
@r10=#0x0000000
@r11=#0x3007DFC
@r12=#0x203DFF8
@r13=#0x3007CE0
@r14=#0x802950F

@works but doesn't currently display the halved damage in the forecast
@even editing the data to half the enemy's damage at the forecast damage breakpoint isn't affecting the final score

push    {r14}
push    {r1-r3}
b       CheckCharacter

CheckCharacter:                 
    ldr     r2,[r0,#0x0]        @load the ROM address of the current character
    ldrb    r2,[r2,#0x4]        @load the character ID byte
    cmp     r2,#0x3             @compare against your chosen character ID byte
    bne     CheckAllegiance     @if a match if found, branch to check their allegiance
    b       End                 @else branch to the end

CheckAllegiance:
    ldrb    r2,[r0,#0xB]
    cmp		r2,#0x40			@NPC phase byte for comparison
    ble		End    	            @if player unit, navigate to End
    cmp		r2,#0x80		    @enemy phase byte for comparison
    bge		Dragonskin          @if enemy unit, navigate to Dragonskin
    b       End                 @if it's the NPC turn  

Dragonskin:
    mov     r3,#0x5A            @get the enemy's attack byte in the battle struct
    ldrb    r2,[r0,r3]          @load the value of that byte
    asr     r2,#1               @half the value
    strb    r2,[r0,r3]          @store it
    mov     r3,#0x5C            @get the player's defense byte in the battle struct
    ldrb    r2,[r1,r3]          @load the value of that byte
    asr     r2,#1               @half the value
    strb    r2,[r1,r3]          @store it
    b       End

End:
    pop     {r1-r3}             @restore the register values from before
    pop     {r6}                @pop the return address
    mov     r7,r1               @vanilla opcode
    mov     r1,r5               @vanilla opcode
    add     r1,#0x7B            @vanilla opcode
    ldrb    r0,[r1]             @vanilla opcode
    add     r0,#0x1             @vanilla opcode
    strb    r0,[r1]             @vanilla opcode
    bx      r6
