from f2 import div_by_x4_plus_x
from f4 import div_by_x4_plus_x2
import random
import time

def make_sparse(length, weight):
    if weight > length:
        raise ValueError("weight can't exceed length")
    arr = [0] * length
    ones_idx = random.sample(range(length), weight)
    for i in ones_idx:
        arr[i] = 1
    return arr


def xor(a, b):
    n = max(len(a), len(b))
    r = [(a[i] if i < len(a) else 0) ^ (b[i] if i < len(b) else 0) for i in range(n)]
    return r

def mul(a, b):  # schoolbook multiplication
    if a == [0] or b == [0]:
        return [0]
    res = [0]*(len(a)+len(b)-1)
    for i in range(len(a)):
        if a[i] == 0: continue
        for j in range(len(b)):
            if b[j] == 0: continue
            res[i+j] ^= 1
    return res

def shift(a, k):
    if a == [0]:
        return [0]
    return [0]*k + a


def sparse_mul(U, V):
    res = [0]
    for i in V:
        res = xor(res, shift(U, i))
    return res



def toom4_recursive_mul(U, V, chunk=None, threshold=16):
    # base case
    if len(U) <= threshold or len(V) <= threshold:
        return mul(U, V)  # schoolbook multiplication when less than threshold

    # decide chunk size
    if chunk is None:
        chunk = (max(len(U), len(V)) + 3) // 4

    # print(chunk)

    # paddding to divide into 4 chunks
    n = 4 * chunk
    if len(U) < n: U = U + [0]*(n - len(U))
    if len(V) < n: V = V + [0]*(n - len(V))

    # split
    U0 = U[0:chunk]; U1 = U[chunk:2*chunk]; U2 = U[2*chunk:3*chunk]; U3 = U[3*chunk:4*chunk]
    V0 = V[0:chunk]; V1 = V[chunk:2*chunk]; V2 = V[2*chunk:3*chunk]; V3 = V[3*chunk:4*chunk]

    # ---------- evaluation ----------
    W1 = xor(U3, xor(U2, xor(U1, U0)))
    W2 = xor(V3, xor(V2, xor(V1, V0)))
    W3 = toom4_recursive_mul(W1, W2, threshold=threshold)   # recursive

    W0 = xor(U1, shift(xor(U2, shift(U3,1)), 1))
    W6 = xor(V1, shift(xor(V2, shift(V3,1)), 1))

    W4 = xor(shift(xor(W0, xor(U3, shift(U3, 1))), 1), W1)
    W5 = xor(shift(xor(W6, xor(V3, shift(V3, 1))), 1), W2)

    W0 = xor(shift(W0,1), U0)
    W6 = xor(shift(W6,1), V0)

    W5 = toom4_recursive_mul(W5, W4, threshold=threshold)   # recursive
    W4 = toom4_recursive_mul(W0, W6, threshold=threshold)   # recursive

    W0 = xor(xor(shift(U0, 3), shift(U1, 2)), shift(U2, 1))
    W6 = xor(xor(shift(V0, 3), shift(V1, 2)), shift(V2, 1))

    W1 = xor(xor(W1, W0), xor(shift(U0, 1), shift(U0, 2)))
    W2 = xor(xor(W2, W6), xor(shift(V0, 1), shift(V0, 2)))

    W0 = xor(W0, U3)
    W6 = xor(W6, V3)

    W1 = toom4_recursive_mul(W1, W2, threshold=threshold)
    W2 = toom4_recursive_mul(W0, W6, threshold=threshold)

    W6 = toom4_recursive_mul(U3, V3, threshold=threshold)
    W0 = toom4_recursive_mul(U0, V0, threshold=threshold)

    # ---------- interpolation ----------
    W1 = xor(xor(W1, W2),  xor(W0, xor(shift(W0, 2), shift(W0, 4))))

    W5 = div_by_x4_plus_x(xor(xor(xor(W5, W4), xor(W6, xor(shift(W6, 2), shift(W6, 4)))), W1))

    W2 = xor(xor(W2, W6), shift(W0, 6))
    W4 = xor(xor(xor(W4, W2), shift(W6, 6)), W0)
    W4 = div_by_x4_plus_x2(xor(W4, xor(shift(W5, 1), shift(W5, 5))))

    W3 = xor(xor(W3, W0), W6)
    W1 = xor(W1, W3)
    W2 = xor(xor(W2, shift(W1,1)), shift(W3,2))
    W3 = xor(xor(W3, W4), W5)
    W1 = div_by_x4_plus_x(xor(W1, xor(shift(W3, 1), shift(W3, 2))))
    W5 = xor(W5, W1)
    W2 = div_by_x4_plus_x2(xor(W2, xor(shift(W5, 1), shift(W5, 2))))
    W4 = xor(W4, W2)

    # ---------- recomposition ----------
    Ws = [W0, W1, W2, W3, W4, W5, W6]
    res = []
    for idx, i in enumerate(Ws):
        print(len(i))
        res = xor(res, shift(i, idx * chunk))

    return res


n = 17669
w = 66

results = []

# for _ in range(100):
    # print(_)
U = [random.randint(0,1) for _ in range(n)]
# V = [random.randint(0,1) for _ in range(17769)]
V = make_sparse(n, w) 

V_indices = [i for i, x in enumerate(V) if x == 1]



t1 = time.time()
RSP = sparse_mul(U, V_indices)  # sparse multiplication
t2 = time.time()
print(f"Time taken for sparse multiplication: {t2 - t1:.6f} seconds")


t1 = time.time()
R = toom4_recursive_mul(U, V, threshold=512)  # recursion with base case schoolbook multiplication
t2 = time.time()
print(f"Time taken for Toom-Cook multiplication: {t2 - t1:.6f} seconds")
t1 - time.time()
RSB = mul(U, V)
t2 = time.time()
print(f"Time taken for schoolbook multiplication: {t2 - t1:.6f} seconds")
hnz = any(x != 0 for x in xor(R, RSP))
print(hnz)


# print(mul([1,1,0,0,1,1],[1,0,1,1,0,1]))  # example multiplicationpr

# results.append(hnz)
# print(hnz)

# for i in results:
#     if i:
#         print("Mismatch found in at least one multiplication.")
#         break
# else:
#     print("All multiplications matched the schoolbook result.")

