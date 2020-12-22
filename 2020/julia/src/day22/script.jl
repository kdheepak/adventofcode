readInput() = strip(read(joinpath(@__DIR__, "./input.txt"), String))

part1(data = readInput()) = f(data)

part2(data = readInput()) = g(data)


function f(data)
    player1, player2 = split.(split(data, "\n\n"), '\n')
    player1, player2 = parse.(Int, player1[2:end]), parse.(Int, player2[2:end])
    player1, player2

    while length(player1) != 0 && length(player2) != 0
        round!(player1, player2)
    end
    score1 = sum([s * i for (i, s) in enumerate(reverse(player1))])
    score2 = sum([s * i for (i, s) in enumerate(reverse(player2))])
    score1, score2
end


function round!(p1, p2)
    if p1[begin] > p2[begin]
        push!(p1, popfirst!(p1))
        push!(p1, popfirst!(p2))
    elseif p2[begin] > p1[begin]
        push!(p2, popfirst!(p2))
        push!(p2, popfirst!(p1))
    else
        error("what")
    end
end

function g(data)
    player1, player2 = split.(split(data, "\n\n"), '\n')
    player1, player2 = parse.(Int, player1[2:end]), parse.(Int, player2[2:end])
    player1, player2

    game!(player1, player2)

    score1 = sum([s * i for (i, s) in enumerate(reverse(player1))])
    score2 = sum([s * i for (i, s) in enumerate(reverse(player2))])
    score1, score2
end

function game!(p1, p2, stack = 1)
    if stack > 1
        # println("Playing a sub-game to determine the winner...\n")
    end
    # println("=== Game $stack ===\n")
    winner = 0
    i = 0

    PAST_GAMES_P1 = Set()
    PAST_GAMES_P2 = Set()

    while true
        i += 1
        # println("-- Round $i (Game $stack) --")
        # println("Player 1's deck: $p1")
        # println("Player 2's deck: $p2")
        if p1 ∈ PAST_GAMES_P1 && p2 ∈ PAST_GAMES_P2
            winner = 1
            break
        else
            push!(PAST_GAMES_P1, copy(p1))
            push!(PAST_GAMES_P2, copy(p2))
        end
        if p1[begin] < length(p1) && p2[begin] < length(p2)
            l1 = popfirst!(p1)
            l2 = popfirst!(p2)
            w = game!(copy(p1[begin:l1]), copy(p2[begin:l2]), stack + 1)
            # println("... anyway, back to game $stack")
            if w == 1
                # println("Player 1 wins round $i of game $stack\n")
                push!(p1, l1)
                push!(p1, l2)
            elseif w == 2
                # println("Player 2 wins round $i of game $stack\n")
                push!(p2, l2)
                push!(p2, l1)
            end
        else
            # println("Player 1 plays: $(p1[begin])")
            # println("Player 2 plays: $(p2[begin])")
            p1[begin] > p2[begin] && ( winner = 1 )
            p2[begin] > p1[begin] && ( winner = 2 )
            if winner == 1
                # println("Player 1 wins round $i of game $stack\n")
                push!(p1, popfirst!(p1))
                push!(p1, popfirst!(p2))
            elseif winner == 2
                # println("Player 2 wins round $i of game $stack\n")
                push!(p2, popfirst!(p2))
                push!(p2, popfirst!(p1))
            end
            if length(p1) == 0 || length(p2) == 0
                # println("The winner of game $stack is player $(winner)\n")
                break
            end
        end
    end
    return winner
end
