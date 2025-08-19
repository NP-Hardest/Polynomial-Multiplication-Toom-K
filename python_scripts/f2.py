def div_by_x4_plus_x(p):
    n = len(p)
    def p_at(j):
        return p[j] if 0 <= j < n else 0

    q = [0] * n
    # q_{-3}, q_{-2}, q_{-1} 
    for i in range(n):
        q_i = p_at(i + 1) ^ (q[i-3] if i-3 >= 0 else 0)
        q[i] = q_i
    return q

