# replace.rb -- Problem 4.2
#
# replace(x1,x2,x3): untuk list a=(a1,...,an) dengan enc(a)=x1, jika 1<=x2<=n,
# hasilnya enc(a1,...,a_{x2-1}, x3, a_{x2+1},...,an); tidak terdefinisi jika
# 1<=x2<=n tidak dipenuhi (termasuk jika x1 sendiri bukan enc(list) yang valid).
#
# DESAIN WHILE PROGRAM (dijelaskan lengkap di laporan PDF):
#   1) n := len(x1)                     -- infloop jika x1 bukan enc(list) valid
#   2) jika x2 < 1 atau x2 > n -> infloop
#   3) Kupas x1 sebanyak (x2-1) kali lewat snd. Setiap kepala yang terkupas
#      (nilai fst mentah, sudah "+1") DITUMPUK (push) ke variabel `stack`,
#      yaitu sebuah encoding list LAIN yang dibangun dengan pi yang sama --
#      berfungsi sebagai stack LIFO. Ini kunci penyelesaiannya: WHILE program
#      tidak punya array, tapi enc/pi sendiri sudah cukup untuk jadi struktur
#      data (baik untuk MEMBACA x1 maupun untuk MENYIMPAN sementara).
#   4) e sekarang = enc((a_x2,...,an)). Buang kepalanya (elemen lama di posisi
#      x2), ambil tail := snd(e) = enc((a_{x2+1},...,an)).
#   5) newList := pi(x3+1, tail)  -- yaitu enc((x3, a_{x2+1},...,an))
#   6) Pop stack satu per satu; tiap pop di-"cons"-kan (pi) ke depan newList.
#      Karena pop LIFO membalik urutan push, a1,...,a_{x2-1} terpasang lagi
#      dengan urutan asli yang benar.
#   7) x0 := newList

require_relative 'enc_helpers'

def replace(x1, x2, x3)
  n = len(x1)
  return UNDEFINED if n == UNDEFINED
  return UNDEFINED if x2 < 1 || x2 > n

  e = x1
  stack = 0
  c = x2 - 1
  c.times do
    h = fst(e) # h = a_i + 1
    stack = pi(h, stack) # push
    e = snd(e)
  end

  tail = snd(e)
  new_list = pi(x3 + 1, tail)

  while stack != 0
    h = fst(stack) # pop
    new_list = pi(h, new_list)
    stack = snd(stack)
  end

  new_list
end

puts '=== Problem 4.2 : replace(x1, x2, x3) ==='
puts

kasus = [
  [[3, 0, 2], 2, 9],
  [[5, 5, 5], 1, 0],
  [[7], 1, 100],
  [[1, 2, 3, 4], 4, 99],
  [[3, 0, 2], 0, 9], # x2 di luar batas (< 1)
  [[3, 0, 2], 4, 9], # x2 di luar batas (> n)
  [:invalid, pi(0, 5), 1, 1] # x1 bukan enc(list) valid: fst(x1)=0 padahal x1!=0
]

kasus.each do |row|
  if row[0] == :invalid
    _, x1, x2, x3 = row
    list_desc = '(x1 bukan encoding list yang valid)'
  else
    a, x2, x3 = row
    x1 = enc_list(a)
    list_desc = a.inspect
  end

  hasil = replace(x1, x2, x3)
  if hasil == UNDEFINED
    puts "a=#{list_desc}, x1=enc(a)=#{x1}, x2=#{x2}, x3=#{x3}"
    puts '  -> replace tidak terdefinisi (WHILE program infloop)'
  else
    puts "a=#{list_desc}, x1=enc(a)=#{x1}, x2=#{x2}, x3=#{x3}"
    puts "  -> replace(x1,x2,x3) = #{hasil}   [dekode: #{decode_list(hasil).inspect}]"
  end
  puts
end
