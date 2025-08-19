from f2 import div_by_x4_plus_x
from f4 import div_by_x4_plus_x2

import random
import time


# def trim(p):
#     while len(p) > 1 and p[-1] == 0:
#         p.pop()
#     return p

def xor(a, b):
    n = max(len(a), len(b))
    r = [(a[i] if i < len(a) else 0) ^ (b[i] if i < len(b) else 0) for i in range(n)]
    return r

def mul(a, b):
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


# --------------- the Toom-4 pipeline (step-by-step) ---------------
def toom4_mul(U, V, chunk=3, debug=False):
    # pad to multiple of 4*chunk
    # need = 4*chunk
    # if len(U) < need: U = U + [0]*(need-len(U))
    # if len(V) < need: V = V + [0]*(need-len(V))

    # split into 4 chunks of size chunk
    U0 = U[0:chunk]; U1 = U[chunk:2*chunk]; U2 = U[2*chunk:3*chunk]; U3 = U[3*chunk:4*chunk]
    V0 = V[0:chunk]; V1 = V[chunk:2*chunk]; V2 = V[2*chunk:3*chunk]; V3 = V[3*chunk:4*chunk]

    # if debug:
    #     print("U chunks:", U0, U1, U2, U3)
    #     print("V chunks:", V0, V1, V2, V3)

    # -------- evaluation stage (follow screenshot lines) --------
    # W1 = U3 + U2 + U1 + U0
    W1 = xor(U3, xor(U2, xor(U1, U0)))
    W2 = xor(V3, xor(V2, xor(V1, V0)))

    # W3 = W1 * W2  (pointwise)
    W3 = mul(W1, W2)

    # W0 = U1 + x*(U2 + x*U3)
    W0 = xor(U1, shift(xor(U2, shift(U3,1)), 1))
    # W6 = V1 + x*(V2 + x*V3)
    W6 = xor(V1, shift(xor(V2, shift(V3,1)), 1))

    # Save pre versions (important: sheet uses some pre-values later)
    W4= xor( shift( xor(W0, mul(U3, [1,1]) ), 1 ), W1 )
    W5 = xor( shift( xor(W6, mul(V3, [1,1]) ), 1 ), W2 )

    # W0 = W0*x + U0  ;  W6 = W6*x + V0
    W0 = xor(shift(W0,1), U0)
    W6 = xor(shift(W6,1), V0)

    # W5 = W5 * W4    ;   W4 = W0 * W6
    # The sheet computes W5 = mul(W5_pre, W4_pre) and W4 = mul(W0, W6)
    W5 = mul(W5, W4)
    W4 = mul(W0, W6)

    # After that sheet recalculates W0 and W6 as:
    W0 = xor(xor(shift(U0, 3), shift(U1, 2)), shift(U2, 1))
    W6 = xor(xor(shift(V0, 3), shift(V1, 2)), shift(V2, 1))

    # W1 = W1 + W0 + U0*(x^2 + x)
    W1 = xor(xor(W1, W0), mul(U0, [0,1,1]))
    # W2 = W2 + W6 + V0*(x^2 + x)
    W2 = xor(xor(W2, W6), mul(V0, [0,1,1]))

    # W0 = W0 + U3 ; W6 = W6 + V3
    W0 = xor(W0, U3)
    W6 = xor(W6, V3)

    # W1 = W1 * W2 ; W2 = W0 * W6
    W1 = mul(W1, W2)
    W2 = mul(W0, W6)

    # W6 = U3 * V3 ; W0 = U0 * V0
    W6 = mul(U3, V3)
    W0 = mul(U0, V0)

    # ------- interpolation (sheet lines, using pre/post appropriately) -------
    # W1 = W1 + W2 + W0*(x^4 + x^2 + 1)
    W1 = xor(xor(W1, W2), mul(W0, [1,0,1,0,1]))

    # W5 = (W5_pre + W4_pre + W6*(x^4+x^2+1) + W1) / (x^4 + x)
    W5 = div_by_x4_plus_x(xor(xor(xor(W5, W4), mul(W6, [1,0,1,0,1])), W1))


    # W2 = W2 + W6 + W0*x^6
    W2 = xor(xor(W2, W6), shift(W0, 6))

    # W4 = W4_pre + W2 + W6*x^6 + W0  (use pre W4 in expression)
    W4 = xor(xor(xor(W4, W2), shift(W6, 6)), W0)


    # then W4 = (W4_dividend + W5*(x^5 + x)) / (x^4 + x^2)
    W4 = div_by_x4_plus_x2(xor(W4, mul(W5, [0,1,0,0,0,1])))

    # W3 = W3 + W4 + W5
    W3 = xor(xor(W3, W0), W6)

    # W1 = W1 + W3
    W1 = xor(W1, W3)

    # W2 = W2 + W1*x + W3*x^2
    W2 = xor(xor(W2, shift(W1,1)), shift(W3,2))

    # W3 = W3 + W4 + W5  (sheet repeats)
    W3 = xor(xor(W3, W4), W5)

    # W1 = (W1 + W3*(x^2 + x)) / (x^4 + x)
    W1 = div_by_x4_plus_x(xor(W1, mul(W3, [0,1,1])))

    # W5 = W5 + W1
    W5 = xor(W5, W1)

    # W2 = (W2 + W5*(x^2 + x)) / (x^4 + x^2)
    W2 = div_by_x4_plus_x2(xor(W2, mul(W5, [0,1,1])))

    # W4 = W4 + W2
    W4 = xor(W4, W2)

    # ------- recomposition -------
    Ws = [W0, W1, W2, W3, W4, W5, W6]
    res = []
    for idx, i in enumerate(Ws):
        res = xor(res, shift(i, idx * chunk))

    return res

# ---------------- Example / test ----------------
if __name__ == "__main__":
    # example used earlier
    U = [1,1,0,1,1,0,1,0,1,1,1,0]
    V = [1,1,1,0,0,1,1,1,0,1,0,1]

    print("Running Toom-4 style multiplication (chunk=3) ...")
    R = toom4_mul(U, V, chunk=3, debug=True)
    naive = mul(U, V)
    print("\nToom result : ", R)
    print("Naive result: ", naive)
    print("Equal? ", R == naive)




# # ---------- naive multiply (for verification) ----------
# def naive_mul(a, b):
#     # GF(2) polynomial multiply (same as before)
#     if a == [0] or b == [0]:
#         return [0]
#     res = [0] * (len(a) + len(b) - 1)
#     for i in range(len(a)):
#         if a[i] == 0: continue
#         for j in range(len(b)):
#             if b[j] == 0: continue
#             res[i + j] ^= 1
#     # trim trailing zeros
#     while len(res) > 1 and res[-1] == 0:
#         res.pop()
#     return res

# ---------- test harness ----------
def test_random_pairs(num_pairs=100, poly_len=100, seed=12345):
    random.seed(seed)
    failures = 0
    total_time_toom = 0.0
    total_time_naive = 0.0

    for t in range(1, num_pairs+1):
        U = [random.randint(0,1) for _ in range(poly_len)]
        V = [random.randint(0,1) for _ in range(poly_len)]

        # choose chunk automatically (ceiling of length/4)
        chunk = (max(len(U), len(V)) + 3) // 4

        # time Toom
        start = time.time()
        R_toom = toom4_mul(U, V, chunk=chunk, debug=False)
        total_time_toom += (time.time() - start)

        # time naive
        start = time.time()
        R_naive = mul(U, V)
        total_time_naive += (time.time() - start)

        test = xor(R_toom, R_naive)
        nz =  any(x != 0 for x in test)

        if nz:
            print(f"Mismatch on pair #{t}")
            print("U:", U)
            print("V:", V)
            print("Toom:", R_toom)
            print("Naive:", R_naive)
            failures += 1
            break  # stop on first failure, remove if you want to continue

        if t % 10 == 0:
            print(f"Checked {t} pairs...")

    print("---- SUMMARY ----")
    print("Pairs tested:", t)
    print("Failures:", failures)
    print(f"Total time Toom:  {total_time_toom:.4f} s")
    print(f"Total time Naive: {total_time_naive:.4f} s")
    if failures == 0:
        avg_ratio = (total_time_naive / total_time_toom) if total_time_toom>0 else float('inf')
        print(f"Avg speedup (naive / toom): {avg_ratio:.2f}x")

# run the test: 100 random pairs, each polynomial length 100
test_random_pairs(num_pairs=100, poly_len=100, seed=2025)

