.thumb

@called from 21648
@r0=#0x0000001
@r1=#0x203A85C action struct
@r2=#0x8021645
@r3=#0x2025260
@r4=#0x20252CC
@r5=#0x2025260
@r6=#0x00000FF
@r7=#0x8B96BC
@r8=#0x0000000
@r9=#0x0000000
@r10=#0x0000000
@r11=#0x3007DFC
@r12=#0x0000001
@r13=#0x3007D94
@r14=#0x804A889
@r15=#0x802164A

ldr		r1,=#0x203A85C		    @load the action struct
strb	r0,[r1,#0x11]		    @set the byte action taken to wait (#0x1)
push	{r0-r3}				    @preserve the original values of these registers on the stack
b 		CheckCharacter		    @branch to CheckCharacter

CheckCharacter:
    ldr		r0,=#0x202BD50		@load the character struct
    ldr		r1,[r0]				@load the pointer to character data	
    ldrB	r1,[r1,#0x4]		@load the character ID byte
    ldr     r3,AlertStanceSetBitID @load the value we defined in the event file
    cmp     r3,r2               @compare it against our chosen unit ID
    beq		SetFlag				@branch to SetFlag if true
    b 		End					@else branch to the end

SetFlag:
    mov		r1,#0xFF			@bitflag value to indicate alertstance is active
    mov		r2,#0x3A			@unused byte?
    strb	r1,[r0,r2]			@store the bitflag for character (Lyn in this instance)
    b		End					@branch to the end

End:
    pop		{r0-r3}				@restore the original values of registers 0-3 we pushed at the start
    ldr		r3,=#0x2025260  	@load r3's original value
    mov		r0,#0x17			@vanilla instruction
    ldr		r5,=#0x804A888|1	@vanilla instruction
    bx		r5					@branch back to the vanilla function

.ltorg
.align
AlertStanceSetBitID:            @refer to the value defined in the event file