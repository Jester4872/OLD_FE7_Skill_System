# FE7 Skill System 

The aim is to provide a working skill system for fans that prefer FE7 over FE8 (we are a dying breed).

With the exception of one or two, all skills have been created from scratch.

Currently, skills must be assigned by defining either a weapon ID or class/character ID that the skill will activate on. As you can imagine, this involves going into each skill and manually setting the required ASM (though I have made an effort to document what every line does).

### Target features

- ✓ Document each skill so their workings can be easily understood
- Outline a graphical space in the stat screen for skills to be shown per unit
- Investigate an alternative to skills that hook at the same address space

### How to Use

- Locate the ASM file of the skill you want to apply
- Change the ID of the unit you want to apply it to (most are set to #0x3 which is Lyn)
- Drag that ASM file onto the AssembleARM.bat file to recompile a new DMP file
- Uncomment one of the `#include` lines within Buildfile.event (BanditBreaker and the effectiveness table must be paired)
- Put your base rom in the same folder as the build file and rename it to FE7_clean.gba
- Drag that GBA file onto the 'MAKE HACK' file which will produce a new GBA file called `FE_Hack.gba` with the skill applied
- Now when you load that GBA file the skill should work.

### Things to consider

- While a skill can technically be applied to multiple units, right now you'll have to add those additional checks yourself
- This project uses the freespace range `#0x8D00000 - #0x8E00000` so make sure it's not conflicting with any other hacks you're using
- Some skills (like the breakers) hook into the same space, so will conflict with each other if you use multiple (currently looking into solution)

### Skill list

| Name    | Effect
| ------- | ------
| Death Blow | +6 attack to the attacking unit
| Frenzy  | Add the unit's lost HP / 4 to their attack
| Acrobat | All terrain traversal costs are 1
| Alert Stance | +20 avoid when selecting the wait command
| Aptitude | +20% additional growth rates
| Armsthift | Luck * 2 % chance of conserving a weapon use
| Axebreaker | +20 hit and avoid when facing axe users
| Banditbreaker | Effective damage against brigands, pirates and berserkers
| Bowbreaker | +20 hit and avoid when facing bow users
| Close Counter | The unit can counterattack at 1-1 range
| Covert | Double the avoid bonus of the tile the unit is standing on
| Double Lion | All weapons are treated as if they have the 'brave' effect
| Dragon Skin | Half all damage to the unit
| Flare | All the defense of the unit you're attacking (also applies to resistence)
| Focus | Applies +10 crit to the unit if there are no allies within 3 spaces
| Fortune | Negate critical attacks on this unit
| Galeforce | The unit can move again after defeating an enemy (currently limitless)
| Gold Digger | +100 gold added after every battle
| Grisley Wound | Deal 20% of the enemy's health as damage after battle (it cannot kill them)
| Hex | -15 avoid to all enemy units within 3 spaces of this unit
| HP + 5 |
| Killing Machine | Doubles critical hit rate (bonuses included)
| Lancebreaker | +20 hit and avoid against lance users
| Life and Death | +10 to damage taken and received
| Lifetaker | Nosferatu effect to all this unit's attacks
| Lucky Seven | Boost one random stat by 7 every turn
| Mercy | Always leave the enemy with 1 HP
| Momentum | +1 damage for every square moved by this unit this turn
| Move + 2 |
| No Guard | Both this unit and the enemy have 100% hit rates
| Paragon | Double experience gain
| Power + 3 |
| Quick Burn | +15 hit and avoid at the start of the map, -1 each turn
| Renewal | This units regains 30% of their HP at the start of their turn
| Sacaen Heritage | +20 avoid when fighting on plains tiles
| Savior | Ignore rescue penalties
| Slow Burn | +1 hit and avoid each turn up to a maximum of 15
| Sword Breaker | +20 hit and avoid when fighting sword users
| Triangle Adapt | Doubles the effects of any triangle effects this unit gives and receives
| Vantage | If attacked, this unit will attack first

### Additional Stuff

On top of this, I've almost added some extra stuff to expand the functionality of the game

| Name    | Effect
| ------- | ------
| Alternative Weapon Modifiers | Allows stats other than strength be used for certain weapons when calculating damage
| Negative Stat Boosts | Allows negative stat boosts in the stat screen source: https://github.com/masterofcontroversy/ASM/tree/main/FE7/NegativeStatBoosts
| TripleEffectiveness | Adds back in the x3 effectiveness present in the original Japanese release
