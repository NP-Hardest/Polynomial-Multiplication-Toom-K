from f2 import div_by_x4_plus_x
from f3 import div_by_x2_plus_x 
from f4 import div_by_x4_plus_x2


def xor(a, b):
    n = max(len(a), len(b))
    res = []
    for i in range(n):
        ai = a[i] if i < len(a) else 0
        bi = b[i] if i < len(b) else 0
        res.append(ai ^ bi)
    return res

def mul(a, b):
    res = [0] * (len(a) + len(b) - 1)
    for i in range(len(a)):
        for j in range(len(b)):
            res[i + j] ^= a[i] & b[j]
    return res

def shift(a, k):
    return [0]*k + a




U = [1,1,0,1,1,0,1,1,1,1,1,0]
V = [1,1,1,0,1,1,0,1,0,1,0,1]


U0 = U[0:3]
V0 = V[0:3]

U1 = U[3:6]
V1 = V[3:6]

U2 = U[6:9]
V2 = V[6:9]

U3 = U[9:12]
V3 = V[9:12]

W1 = xor(U3, xor(U2, xor(U1, U0)))
W2 = xor(V3, xor(V2, xor(V1, V0)))

W3 = mul(W1, W2)

W0 = xor(U1, shift(xor(U2, shift(U3, 1)), 1))
W6 = xor(V1, shift(xor(V2, shift(V3, 1)), 1))

W4 = xor(shift(xor(W0, mul(U3, [1,1])),1),W1)
W5 = xor(shift(xor(W6, mul(V3, [1,1])),1),W2)

W0 = xor(shift(W0, 1), U0)
W6 = xor(shift(W6, 1), V0)

W5 = mul(W5, W4)
W4 = mul(W0, W6)

W0 = xor(xor(shift(U0, 3), shift(U1, 2)), shift(U2, 1))
W6 = xor(xor(shift(V0, 3), shift(V1, 2)), shift(V2, 1))

W1 = xor(xor(W1, W0), mul(U0, [0,1,1]))
W2 = xor(xor(W2, W0), mul(V0, [0,1,1]))

W0 = xor(W0,U3)
W6 = xor(W6,V3)

W1 = mul(W1, W2)
W2 = mul(W0, W6)

W6 = mul(U3, V3)
W0 = mul(U0, V0)





W1 = xor(xor(W1, W2), mul(W0, [1,0,1,0,1])) 

W5 = div_by_x4_plus_x(xor(xor(xor(W5, W4), mul(W6, [1,0,1,0,1])), W1))

W2 = xor(xor(W2, W6), shift(W0, 6))

W4 = xor(xor(xor(W4, W2), shift(W6, 6)), W0)

W4 = div_by_x4_plus_x2(xor(W4, mul(W5,[0,1,0,0,0,1])))

W3 = xor(xor(W3, W4), W5)

W1 = xor(W1, W3)

W2 = xor(xor(W2, shift(W1,1)),shift(W3,2))

W3 = xor(xor(W3, W4), W5)

W1 = div_by_x4_plus_x(xor(W1, mul(W3, [0,1,1])))

W5 = xor(W5, W1)

W2 = div_by_x4_plus_x2(xor(W2, mul(W5,[0,1,1])))

W4 = xor(W4, W2)

chunk = 3
Ws = [W0, W1, W2, W3, W4, W5, W6]

def recombine(ws, chunk_size):
    # maximum possible length
    max_len = 0
    for i,w in enumerate(ws):
        if w == [0]: continue
        max_len = max(max_len, len(w) + i*chunk_size)
    if max_len == 0:
        return [0]
    res = [0]*max_len
    for i,w in enumerate(ws):
        if w == [0]:
            continue
        shifted = [0]*(i*chunk_size) + w
        # add (xor) into res
        for j,coeff in enumerate(shifted):
            res[j] ^= coeff
    return res

result_toom = recombine(Ws, chunk)
result_naive = mul(U, V)

print("result_toom  :", result_toom)
print("result_naive :", result_naive)
print("equal?        :", result_toom == result_naive)