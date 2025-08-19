def div_by_x2_plus_x(p, trim=True):
    n = len(p)
    if n == 0:
        return []

    def p_at(j):
        return p[j] if 0 <= j < n else 0

    q = [0] * n
    # base
    q[0] = p_at(1)  # q0 = p1
    # recurrence
    for i in range(1, n):
        q[i] = p_at(i+1) ^ q[i-1]

    return q


# Let's build Q = 1 + x + x^3  (q = [1,1,0,1])
Q = [1,1,0,1]
# compute P = x*Q + x^2*Q
P = [0] * 10
for i, bit in enumerate(Q):
    if bit:
        P[i+1] ^= 1
        P[i+2] ^= 1

print("P:", P)           # polynomial that is exactly divisible
q_out = div_by_x2_plus_x(P)
print("Recovered Q:", q_out)  # should equal [1,1,0,1]
