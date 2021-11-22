type
    Stats = object
        hp: int
        damage: int
        armor: int
    
    Item = object
        cost: int
        damage: int
        armor: int

let boss = Stats(hp: 104, damage: 8, armor: 1)

proc weapon(cost: int, damage: int): Item = Item(armor: 0, cost: cost, damage: damage)
proc armor(cost: int, armor: int): Item = Item(armor: armor, cost: cost, damage: 0)

let weapons = @[
    weapon(8, 4), weapon(10, 5), weapon(25, 6), weapon(40, 7), weapon(74, 8)
]

let armors = @[
    armor(13, 1), armor(31, 2), armor(53, 3), armor(75, 4), armor(102, 5)
]

let rings = @[
    # damage rings == weapons
    weapon(25, 1), weapon(50, 2), weapon(100, 3),
    # def rings == armor
    armor(20, 1), armor(40, 2), armor(80, 3)
]

proc battle(player: Stats, boss: Stats): bool =
    var playerHealth = player.hp
    var bossHealth = boss.hp

    let playerDmg = max(player.damage - boss.armor, 1)
    let bossDmg = max(boss.damage - player.armor, 1)
    while true:
        bossHealth -= playerDmg
        if bossHealth <= 0:
            return true

        playerHealth -= bossDmg
        if playerHealth <= 0:
            return false

proc itemCombinations(): seq[seq[int]] =
    for weapon in 0 ..< weapons.len:
        # Using -1 as sentinel value for "didn't pick"
        for armor in (-1) ..< armors.len:
            for ring1 in (-1) ..< rings.len:
                for ring2 in (-1) ..< rings.len:
                    # Can't buy two of the same ring
                    if ring1 == ring2:
                        continue

                    result.add(
                        @[weapon, armor, ring1, ring2]
                    )
    
    return result

proc testCombinations(combinations: seq[seq[int]], canWin = true): int =
    var finalCost = (if canWin: high(int) else: low(int))

    for comb in combinations[0 .. ^1]:
        var player: Stats

        player.hp = 100
        player.damage += weapons[comb[0]].damage
        var cost = weapons[comb[0]].cost

        if comb[1] != -1:
            player.armor += armors[comb[1]].armor
            cost += armors[comb[1]].cost
        
        for i in [2, 3]:
            if comb[i] != -1:
                player.armor += rings[comb[i]].armor
                player.damage += rings[comb[i]].damage
                cost += rings[comb[i]].cost
        
        
        var battleResult = player.battle(boss)
        if not canWin:
            battleResult = not battleResult
        
        if battleResult:
            if canWin:
                finalCost = min(finalCost, cost)
            else:
                finalCost = max(finalCost, cost)
    
    return finalCost

let combinations = itemCombinations()

echo "Part 1: ", combinations.testCombinations()
echo "Part 2: ", combinations.testCombinations(false)

