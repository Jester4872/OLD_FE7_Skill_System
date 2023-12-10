.thumb

@called from 28B48
@r0=#0x0000099
@r1=#0x0002899  attacker struct - weapon uses and weapon
@r2=#0x203A498  attacker struct - sword rank (rank of equipped weapon)
@r3=#0x0000000  class of defender
@r4=#0x203A470  defender struct
@r5=#0x203A3F0  attacker struct
@r6=#0x203A438  attacker struct - equipped item and uses
@r7=#0x203A470  defender struct
@r8=#0x202BDEO  character struct of this ally
@r9=#0x202CEC0  character struct of this enemy
@r10=#0x0000000
@r11=#0x3007DFC
@r12=#0x203DFF8
@r13=#0x3007D14
@r14=#0x8028B49
@r15=#0x8028B48

mov     r1,r5               @move attacker/defender struct to r1
add     r1,#0x5A            @attack byte of attacker/defender struct
ldrh    r2,[r1]             @attack of weapon plus the weapon triangle bonus
lsl     r0,r2,#0x1          @double its value
add     r0,r2               @add the original value again to make it x3 
ldr     r4,=#0x8028B50|1    @hardcode return address as we're using jumpToHack instead of callHack
bx      r4                  @return to the vanilla routine

