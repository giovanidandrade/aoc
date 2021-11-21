from std/strutils import split, parseInt
from std/sequtils import repeat, foldl, map
import std/re

type
    Reindeer = ref object
        speed: int
        runTime: int
        restTime: int
        isResting: bool

proc makeReindeer(description: string): Reindeer =
    let matches = description.findAll(re"\d+")

    let speed = matches[0].parseInt
    let runTime = matches[1].parseInt
    let restTime = matches[2].parseInt

    return Reindeer(speed: speed, runTime: runTime, restTime: restTime, isResting: false)

proc raceOld(reindeers: var seq[Reindeer], duration: int): int =
    var distances = repeat(0, reindeers.len)
    var running = repeat(0, reindeers.len)
    var resting = repeat(0, reindeers.len)

    for time in 1 .. duration:
        for idx, reindeer in reindeers[0 .. ^1]:
            if reindeer.isResting:
                resting[idx] += 1

                if resting[idx] == reindeer.restTime:
                    resting[idx] = 0
                    reindeer.isResting = false
            else:
                running[idx] += 1
                distances[idx] += reindeer.speed

                if running[idx] == reindeer.runTime:
                    running[idx] = 0
                    reindeer.isResting = true
    
    return distances.foldl(max(a, b), low(int))

proc race(reindeers: var seq[Reindeer], duration: int): int =
    var distances = repeat(0, reindeers.len)
    var running = repeat(0, reindeers.len)
    var resting = repeat(0, reindeers.len)
    var points = repeat(0, reindeers.len)

    for time in 1 .. duration:
        for idx, reindeer in reindeers[0 .. ^1]:
            if reindeer.isResting:
                resting[idx] += 1

                if resting[idx] == reindeer.restTime:
                    resting[idx] = 0
                    reindeer.isResting = false
            else:
                running[idx] += 1
                distances[idx] += reindeer.speed

                if running[idx] == reindeer.runTime:
                    running[idx] = 0
                    reindeer.isResting = true
        
        let leadDistance = distances.foldl(max(a, b), low(int))

        for idx, _ in reindeers[0 .. ^1]:
            if distances[idx] == leadDistance:
                points[idx] += 1
    
    return points.foldl(max(a, b), low(int))        

var input = readFile("input.txt").split('\n').map(makeReindeer)

echo "Part 1: ", raceOld(input, 2503)

# We gotta reset the reindeers
for reindeer in input[0 .. ^1]:
    reindeer.isResting = false

echo "Part 2: ", race(input, 2503)