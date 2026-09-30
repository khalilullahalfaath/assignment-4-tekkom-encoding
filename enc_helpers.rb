# enc_helpers.rb

UNDEFINED = :undefined # penanda "tidak terdefinisi" == WHILE program infloop

# pi(a,b) = 1/2 (a+b)(a+b+1) + b
def pi(a, b)
  s = a + b
  (s * (s + 1)) / 2 + b
end

# unpair(z) mengembalikan (a,b) sehingga pi(a,b) = z.
def unpair(z)
  w = (Integer.sqrt(8 * z + 1) - 1) / 2
  w += 1 while (w + 1) * (w + 2) / 2 <= z
  w -= 1 while w * (w + 1) / 2 > z
  t = w * (w + 1) / 2
  b = z - t
  a = w - b
  [a, b]
end

def fst(z)
  unpair(z)[0]
end

def snd(z)
  unpair(z)[1]
end

# isList(e) -> 1 / 0. TOTAL (selalu berhenti).
def is_list(e)
  cur = e
  while cur != 0
    a = fst(cur)
    return 0 if a == 0
    cur = snd(cur)
  end
  1
end

# len(e) -> panjang list, atau UNDEFINED. PARSIAL.
def len(e)
  return UNDEFINED if is_list(e).zero?

  n = 0
  cur = e
  while cur != 0
    n += 1
    cur = snd(cur)
  end
  n
end

# elem(e,i) -> elemen ke-i (1-indexed), atau UNDEFINED. PARSIAL.
def elem(e, i)
  n = len(e)
  return UNDEFINED if n == UNDEFINED
  return UNDEFINED if i < 1 || i > n

  cur = e
  (i - 1).times { cur = snd(cur) }
  fst(cur) - 1
end

# --- utilitas non-WHILE, murni untuk mempermudah pembuatan kasus uji & cetak hasil ---

def enc_list(arr)
  arr.reverse.reduce(0) { |acc, v| pi(v + 1, acc) }
end

def decode_list(e)
  return UNDEFINED if is_list(e).zero?

  result = []
  cur = e
  while cur != 0
    result << (fst(cur) - 1)
    cur = snd(cur)
  end
  result
end
