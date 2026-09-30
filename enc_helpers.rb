# enc_helpers.rb
#
# Blok bangunan yang SUDAH terbukti WHILE-computable di Lecture 4 (Encoding):
#   pi   -- fungsi pemasangan Cantor            (Slide 13)
#   fst  -- decoding komponen pertama dari pi   (Slide 14-15)
#   snd  -- decoding komponen kedua dari pi     (Slide 14-15)
#   isList -- cek apakah suatu bilangan adalah enc(list) yang valid (Slide 34-35)
#   len  -- panjang list (parsial: infloop jika bukan enc(list) valid) (Slide 36)
#   elem -- elemen ke-i dari list (parsial) (Slide 37)
#
# Fungsi-fungsi ini dipakai sebagai "subrutin" (syntax sugar pemanggilan fungsi,
# Lect02 Slide 33) oleh replace (Problem 4.2) dan isProg (Problem 4.3), sesuai
# hint pada soal ("You may first implement some other functions introduced in
# the class").
#
# Catatan implementasi fst/snd: di kelas, fst/snd dibangun lewat BRUTE-FORCE
# (dua LOOP bersarang mencoba semua pasangan (a,b) sampai ketemu yang cocok).
# Itulah bukti WHILE-computability-nya. Karena brute-force jadi sangat lambat
# untuk bilangan sebesar enc(program GOTO) (bisa puluhan digit, Lect04 Slide 32),
# implementasi Ruby di bawah memakai RUMUS TERTUTUP yang secara matematis
# MENGHITUNG FUNGSI YANG SAMA PERSIS (bukan fungsi berbeda) -- hanya lebih
# cepat untuk dijalankan sungguhan. Status WHILE-computable fst/snd sendiri
# tidak perlu dibuktikan ulang di sini karena sudah menjadi hasil kelas.
#
# Satu prinsip desain yang dipegang konsisten di seluruh file ini: TIDAK ADA
# array/hash yang dipakai sebagai struktur data utama. Satu-satunya "struktur
# data" yang tersedia untuk WHILE program adalah bilangan asli itu sendiri
# (lewat enc/pi) -- persis seperti keterbatasan WHILE program yang sesungguhnya.

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
