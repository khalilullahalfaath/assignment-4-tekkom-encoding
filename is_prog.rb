# is_prog.rb -- Problem 4.3

require_relative 'enc_helpers'

def is_prog(x1)
  return 0 if is_list(x1).zero?

  total = len(x1)
  return 0 if total < 3

  n = total - 2
  bad = 0

  (1..n).each do |t|
    next unless bad.zero?

    stmt = elem(x1, t + 2)
    if is_list(stmt).zero?
      bad = 1
      next
    end

    slen = len(stmt)
    op = elem(stmt, 1)

    valid =
      case op
      when 1, 2
        slen == 2
      when 3
        slen == 2 && (j = elem(stmt, 2)) && j >= 1 && j <= n
      when 4
        slen == 3 && (j = elem(stmt, 3)) && j >= 1 && j <= n
      when 5
        slen == 1
      else
        false
      end

    bad = 1 unless valid
  end

  bad.zero? ? 1 : 0
end

# --- utilitas pencetak, murni untuk memperjelas kasus uji (bukan bagian WHILE program) ---
OPNAME = {
  1 => ->(i, _j) { "x#{i} := x#{i} + 1" },
  2 => ->(i, _j) { "x#{i} := x#{i} - 1" },
  3 => ->(_i, j) { "GOTO L#{j}" },
  4 => ->(i, j) { "IF x#{i} = 0 THEN GOTO L#{j}" },
  5 => ->(_i, _j) { 'HALT' }
}.freeze

def describe_program(x1)
  return '(bukan enc(list) valid)' if is_list(x1).zero?

  total = len(x1)
  return '(list valid tapi < 3 elemen: tidak ada k,m,statement lengkap)' if total < 3

  k = elem(x1, 1)
  m = elem(x1, 2)
  n = total - 2
  lines = ["k=#{k}, m=#{m}, n=#{n} statement:"]
  (1..n).each do |t|
    stmt = elem(x1, t + 2)
    if is_list(stmt).zero?
      lines << "  L#{t}: <enc statement tidak valid>"
      next
    end
    op = elem(stmt, 1)
    i = elem(stmt, 2) if len(stmt) >= 2 && op != UNDEFINED
    j = elem(stmt, len(stmt)) if len(stmt) >= 2
    txt = OPNAME[op] ? OPNAME[op].call(i, j) : "<opcode tidak dikenal: #{op}>"
    lines << "  L#{t}: #{txt}"
  end
  lines.join("\n")
end

puts '=== Problem 4.3 : isProg(x1) ==='
puts

# Program valid #1: dua baris, k=1, m=1
#   L1: x1 := x1 - 1;
#   L2: HALT
prog_kecil = enc_list([1, 1, enc_list([2, 1]), enc_list([5])])

# Program valid #2: persis contoh "add" dari Lect03 Slide 20 / Lect04 Slide 29-32
#   L1: IF x1=0 THEN GOTO L5;   L2: x0:=x0+1;  L3: x1:=x1-1;  L4: GOTO L1;
#   L5: IF x2=0 THEN GOTO L9;   L6: x0:=x0+1;  L7: x2:=x2-1;  L8: GOTO L5;  L9: HALT
prog_add = enc_list([
              2, 2,
              enc_list([4, 1, 5]),
              enc_list([1, 0]),
              enc_list([2, 1]),
              enc_list([3, 1]),
              enc_list([4, 2, 9]),
              enc_list([1, 0]),
              enc_list([2, 2]),
              enc_list([3, 5]),
              enc_list([5])
            ])

# Tidak valid #1: opcode tidak dikenal (9)
prog_opcode_salah = enc_list([1, 1, enc_list([9, 1]), enc_list([5])])

# Tidak valid #2: GOTO ke label yang tidak ada (n=1, tapi lompat ke L99)
prog_lompat_invalid = enc_list([1, 1, enc_list([3, 99])])

# Tidak valid #3: x1 bukan enc(list) yang valid sama sekali
prog_bukan_list = pi(0, 5)

# Tidak valid #4: list valid tapi cuma berisi (k,m), tanpa statement sama sekali
prog_tanpa_statement = enc_list([1, 1])

# Valid #3: satu baris SAJA, tanpa HALT sama sekali -- tetap valid, karena
# tata bahasa GOTO tidak mensyaratkan keberadaan/urutan HALT (lihat catatan
# desain di atas)
prog_tanpa_halt = enc_list([1, 1, enc_list([2, 1])])

kasus = {
  'Program valid, 2 baris, diakhiri HALT' => prog_kecil,
  'Program "add" persis dari Lect03/Lect04 (9 baris, k=2,m=2)' => prog_add,
  'Program valid, 1 baris, TANPA HALT sama sekali' => prog_tanpa_halt,
  'Statement dengan opcode tidak dikenal (9)' => prog_opcode_salah,
  'GOTO ke label yang tidak ada (L99, padahal n=1)' => prog_lompat_invalid,
  'x1 bukan enc(list) yang valid sama sekali' => prog_bukan_list,
  'List valid tapi tidak punya statement (hanya k,m)' => prog_tanpa_statement
}

kasus.each do |desc, x1|
  hasil = is_prog(x1)
  x1_str = x1.to_s
  x1_desc = x1_str.length > 60 ? "#{x1_str[0, 30]}...#{x1_str[-10, 10]}  (#{x1_str.length} digit)" : x1_str
  puts "#{desc}"
  puts "  x1 = #{x1_desc}"
  puts "  #{describe_program(x1).gsub("\n", "\n  ")}"
  puts "  -> isProg(x1) = #{hasil}"
  puts
end
