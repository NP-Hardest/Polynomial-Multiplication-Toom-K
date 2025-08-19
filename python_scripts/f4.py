def div_by_x4_plus_x2(p):

    n = len(p)
    # if n == 0:
    #     return []

    def p_at(j):
        return p[j] if 0 <= j < n else 0

    q = [0] * n
    # base cases
    q[0] = p_at(2)
    if n > 1:
        q[1] = p_at(3)

    # recurrence: q[i] = p[i+2] ^ q[i-2]
    for i in range(2, n):
        q[i] = p_at(i + 2) ^ q[i - 2]

    return q

