import std/sequtils

type
    Boss = tuple[hp: int, damage: int]
    Player = tuple[hp: int, mana: int]
    Spell = enum missile, drain, shield, poison, recharge
    Effect = enum shieldFx, poisonFx, rechargeFx
    Battle = enum ongoing, win, loss
    Difficulty = enum easy, hard

    Timers = array[shieldFx..rechargeFx, int]
    TurnResult = object
        boss: Boss
        player: Player
        timers: Timers
        battle: Battle

let boss = (hp: 58, damage: 9)
let player = (hp: 50, mana: 500)
var manaCost: array[missile..recharge, int]

manaCost[missile] = 53
manaCost[drain] = 73
manaCost[shield] = 113
manaCost[poison] = 173
manaCost[recharge] = 229

## Assumes the player has enough mana to perform that spell
## And that the player has checked the effect timers before making their decision
proc battleTurn(boss: Boss, player: Player, spell: Spell,
                timers: Timers, difficulty: Difficulty): TurnResult =
    result.boss = boss
    result.player = player
    result.timers = timers

    result.player.mana -= manaCost[spell]

    if difficulty == hard:
        result.player.hp -= 1
        if result.player.hp <= 0:
            result.battle = loss
            return result
    
    if result.timers[poisonFx] > 0:
        result.boss.hp -= 3
    
    if result.timers[rechargeFx] > 0:
        result.player.mana += 101
    
    case spell
    of missile:
        result.boss.hp -= 4
    of drain:
        result.boss.hp -= 2
        result.player.hp += 2
    of shield:
        # Adding one more so I can uniformly lower the timers
        result.timers[shieldFx] = 7
    of poison:
        # Adding one more so I can uniformly lower the timers
        result.timers[poisonFx] = 7
    of recharge:
        # Adding one more so I can uniformly lower the timers
        result.timers[rechargeFx] = 6
    
    # It's okay to just lower them because
    # 1) we won't do |low(int)| turns
    # 2) we always directly set their values with the spell
    for fx in shieldFx .. rechargeFx:
        result.timers[fx] -= 1

    if result.timers[poisonFx] > 0:
        result.boss.hp -= 3
    
    if result.boss.hp <= 0:
        result.battle = win
        return result
    
    if result.timers[rechargeFx] > 0:
        result.player.mana += 101
 
    if result.timers[shieldFx] > 0:
        result.player.hp -= max(1, boss.damage - 7)
    else:
        result.player.hp -= boss.damage
    
    for fx in shieldFx .. rechargeFx:
        result.timers[fx] -= 1
    
    if result.player.hp <= 0:
        result.battle = loss
        return result

    return result

proc tryBattle(turn: TurnResult, cost: int, difficulty = easy, upper = high(int)): int =
    var bound = upper

    case turn.battle
    of loss: return -1
    of win: return cost
    # The rest of the function body
    of ongoing: discard

    # We already know this isn't the optimal solution
    # Might as well count it as a loss
    if cost > bound:
        return -1

    # Get viable spells
    var viableSpells = toSeq(missile .. recharge)
        .filterIt(manaCost[it] <= turn.player.mana)
    
    if turn.timers[shieldFx] > 1:
        viableSpells = viableSpells.filterIt(it != shield)
    
    if turn.timers[poisonFx] > 1:
        viableSpells = viableSpells.filterIt(it != poison)
    
    if turn.timers[rechargeFx] > 1:
        viableSpells = viableSpells.filterIt(it != recharge)
    
    # If you can't cast a spell, you lose
    if viableSpells.len == 0:
        return -1

    result = high(int)
    for spell in viableSpells[0 .. ^1]:
        let spellCost = manaCost[spell]
        let newTurn = battleTurn(turn.boss, turn.player, spell, turn.timers, difficulty)
        let totalCost = tryBattle(newTurn, cost + spellCost, difficulty, bound)

        if totalCost != -1:
            result = min(result, totalCost)
            bound = min(bound, totalCost)
    
    return result

var turnEasy: TurnResult
turnEasy.boss = boss
turnEasy.player = player

echo "Part 1: ", tryBattle(turnEasy, 0)

var turnHard: TurnResult
turnHard.boss = boss
turnHard.player = player

echo "Part 2: ", tryBattle(turnHard, 0, hard)