.thumb

@called from 18C80
@r0=#0x202BD50  character struct
@r1=#0x000000A  vulnerary heal amount (might be other items as well)
@r2=#0x8B92EBO  character data ROM
@r3=#0x0000000
@r4=#0x000000A
@r5=#0x202BD50  character struct
@r6=#0x202511C  
@r7=#0x3007DD8
@r8=#0x0000000
@r9=#0x0000000
@r10=#0x0000000
@r11=#0x3007DFC
@r12=#0x0000001
@r13=#0x3007D70
@r14=#0x802C985
@r15=#0x8018C80




End:
ldr     r2,=#0x8018C8A|1    @hardcode the link register back to its original value as it's needed in GetStatIncrease and it's been overwritten with this hack
mov     r14,r2