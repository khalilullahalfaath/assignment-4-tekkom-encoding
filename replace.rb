# replace.rb -- Problem 4.2

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
