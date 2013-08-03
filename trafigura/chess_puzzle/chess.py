import itertools

# N = M = 3
# pieces = 2 * ['K'] + ['R']

# N = M = 4
# pieces = 2 * ['R'] + 4 * ['N']

# N = 6
# M = 9
# pieces = 2 * ['K'] + ['Q', 'B', 'R', 'N']

N = 5
M = 5
pieces = 2 * ['K'] + ['Q', 'R', 'B', 'N']


def influenced_by(pos, piece):

    def valid(cell):
        x, y = cell
        return 0 <= x <= N and 0 <= y <= M

    def trim(grid):
        return {cell for cell in grid if valid(cell)}

    x, y = pos
    if piece == 'K':
        return trim([
            (x - 1, y - 1), (x, y - 1), (x + 1, y - 1),
            (x - 1, y    ),             (x + 1, y    ),
            (x - 1, y + 1), (x, y + 1), (x + 1, y + 1),
        ])

    elif piece == 'R':
        cross = {(x + i, y) for i in range(-N, N)}.union(
                {(x, y + j) for j in range(-M, M)}) - {pos}
        return trim(cross)

    elif piece == 'B':
        cross = {(x + i, y + i) for i in range(-N - M, N + M)}.union(
                {(x + i, y - i) for i in range(-N - M, N + M)}) - {pos}
        return trim(cross)

    elif piece == 'Q':
        cross = {(x + i, y) for i in range(-N, N)}.union(
                {(x, y + j) for j in range(-M, M)}).union(
                {(x + i, y + i) for i in range(-N - M, N + M)}).union(
                {(x + i, y - i) for i in range(-N - M, N + M)}) - {pos}
        return trim(cross)

    elif piece == 'N':
        return trim([
            (x - 2, y - 1), (x - 2, y + 1),
            (x + 2, y - 1), (x + 2, y + 1),
            (x - 1, y - 2), (x - 1, y + 2),
            (x + 1, y - 2), (x + 1, y + 2),
        ])

    else:
        raise Exception('Piece!')


def is_valid(cells):
    occupied_positions = {c[0] for c in cells}
    for position, piece in cells:
        influenced_cells = influenced_by(position, piece)
        if occupied_positions.intersection(influenced_cells):
            return False
    return True


def print_cells(cells):
    c = dict(cells)
    for i in range(N):
        for j in range(M):
            print c.get((i, j), '.'),
        print
    print


def main():
    valid_cells = set()
    done_cells = set()
    i = 0
    for positions in itertools.permutations(
        itertools.product(range(N), range(M)), len(pieces)):
        i += 1
        cells = tuple(sorted(zip(positions, pieces)))
        if cells in done_cells:
            continue
        else:
            done_cells.add(cells)
        if is_valid(cells):
            valid_cells.add(cells)

    print 'Analyzed %d positions' % i
    print 'Found %d valid ones' % len(valid_cells)
    print
    for cell in valid_cells:
        print_cells(cell)


def main2():

    def generate_boards(initial_board, piece, other_pieces, done_cells):

        available_cells = set(itertools.product(range(N), range(M))) - {
            pos for pos, _ in initial_board}

        for cell in available_cells:
            board = tuple(sorted(initial_board + ((cell, piece), )))

            if board in done_cells:
                continue
            done_cells.add(board)

            if not is_valid(board):
                continue

            if other_pieces:
                for b in generate_boards(board, other_pieces[0],
                                         other_pieces[1:], done_cells):
                    yield b
            else:
                yield board

    done_cells = set()
    i = 0
    for board in generate_boards((), pieces[0], pieces[1:], done_cells):
        i += 1
        # print_cells(board)
    print 'Found %d valid cells' % i


if __name__ == '__main__':
    # main()
    main2()
