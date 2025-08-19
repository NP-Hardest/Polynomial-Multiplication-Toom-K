def div_by_one_plus_x(coeffs):
    """
    coeffs: list/iterable of 0/1 integers, coeffs[i] is coefficient of x^i (lowest degree first).
    Returns: list of quotient coefficients q, same length as input.
    q[i] = XOR_{j=0..i} coeffs[j]  (prefix XOR)
    """
    q = []
    acc = 0
    for a in coeffs:
        acc ^= (a & 1)
        q.append(acc)
    return q

a = [1, 1, 0, 1, 1, 0]   # polynomial 1 + x + x^3 + ...
q = div_by_one_plus_x(a)
print("A:", a)
print("Q:", q)
# Q will be prefix XOR: [1, 0, 0, 1, 1]

if sum(a) & 1:
    raise ValueError("Input polynomial is not divisible by 1+x (odd parity).")
