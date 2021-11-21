from std/strutils import split, parseInt
from std/sequtils import map, concat, foldl, filterIt
import std/re
import std/sugar

type
    Ingredient = object
        capacity: int
        durability: int
        flavor: int
        texture: int
        calories: int

proc makeIngredient(description: string): Ingredient =
    let matches = description.findAll(re"-?\d+")

    let capacity = matches[0].parseInt()
    let durability = matches[1].parseInt()
    let flavor = matches[2].parseInt()
    let texture = matches[3].parseInt()
    let calories = matches[4].parseInt()

    return Ingredient(capacity: capacity, durability: durability, flavor: flavor,
                      texture: texture, calories: calories)


## Returns [score, calories]
proc bakeAndEval(coeffs: seq[int], ingredients: seq[Ingredient]): array[2, int] =
    assert(coeffs.len == ingredients.len)

    var capacity = 0
    var durability = 0
    var flavor = 0
    var texture = 0
    var calories = 0

    for idx, elem in ingredients[0 .. ^1]:
        let coeff = coeffs[idx]

        capacity += coeff * elem.capacity
        durability += coeff * elem.durability
        flavor += coeff * elem.flavor
        texture += coeff * elem.texture
        calories += coeff * elem.calories
    
    if capacity < 0 or durability < 0 or flavor < 0 or texture < 0:
        return [0, 0]
    
    return [capacity * durability * flavor * texture, calories]

## Takes a few teaspoons from one ingredient to give to another
proc findAllRecipes(len: int, sum: int): seq[seq[int]] =
    if len == 1:
        return @[@[sum]]

    for val in 0 .. sum:
        result.add(
            findAllRecipes(len - 1, sum - val)
                .map(sq => @[val].concat(sq))
        )
    
    return result

var input = readFile("input.txt").split('\n').map(makeIngredient)

let recipes = findAllRecipes(input.len, 100)
let scores = recipes
    .map(coeffs => bakeAndEval(coeffs, input))

echo "Part 1: ", scores.foldl(max(a, b[0]), low(int))
echo "Part 2: ", scores
    .filterIt(it[1] == 500)
    .foldl(max(a, b[0]), low(int))