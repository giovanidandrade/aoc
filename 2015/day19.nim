import std/re
import std/strutils
import std/sequtils
import std/sugar
from ../utils/sequence import flatten

type
    Rule = seq[string]
    Rules = seq[Rule]

proc makeRules(descriptions: seq[string]): Rules =
    var rules: Rules

    for rule in descriptions[0 .. ^1]:
        rules.add(
            rule.strip().split(" => ")
        )
    
    return rules

proc processRule(input: string, rule: Rule): seq[string] =
    var index = 0
    while index < input.len and index >= 0:
        let matchIndex = input.find(rule[0].escapeRe(), index)

        if matchIndex != -1:
            let prefix = input[0 .. matchIndex - 1]
            let suffix = input[matchIndex .. ^1]
                .replace(
                    re("^" & rule[0]),
                    rule[1]
                )
            
            result.add(prefix & suffix)
            index = max(matchIndex, index + 1)
        else:
            index = -1
    
    return result.deduplicate()

proc getAtoms(molecule: string): seq[string] =
    molecule.findAll(re"[A-Z][a-z]?")
        
proc fabricate(rules: Rules, molecule: string): int =
    # As it turns out, we need to look at the input to figure this
    # out properly and elegantly

    # Basically, we have these types of productions:
    # A => BC
    # A => B Rn C Ar
    # A => B Rn C Y D Ar
    # A => B Rn C Y D Y E Ar

    # Since Rn and Ar are always paired, and Y only shows up between them
    # we can generalize the last three productions as
    #
    # A => B(C)
    # A => B(C, D)
    # A => B(C, D, E)

    # The inverse of the first production rule (A => BC) on a string str
    # without parens implies in `str.len - 1`
    let dedupSteps = molecule.getAtoms().len - 1

    # The same logic applies to A => B(C), except we're getting rid of
    # more characters for free also
    let numParens = molecule.findAll(re"Rn|Ar").len

    # And since every comma means we have two substrings of equal size
    # to remove, we can remove them as well
    let commaSteps = 2 * molecule.findAll(re"Y").len

    # Credit to u/askalski for the analysis
    return dedupSteps - numParens - commaSteps

let input = readFile("input.txt").split("\n")

let molecule = input[^1]
let rules = input[0 .. ^3].toSeq().makeRules()

echo "Part 1: ", rules
    .map(rule => molecule.processRule(rule))
    .flatten()
    .deduplicate()
    .len

echo "Part 2: ", rules.fabricate(molecule)