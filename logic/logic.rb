def m(x, y, z)

  a = (x == 4)
  b = (y == 5)
  c = (z == 6)

  d = 1

  if (a and (!b or !c))
    d = 0
  end

  return d

end

x = ARGV[0].to_i
y = ARGV[1].to_i
z = ARGV[2].to_i

result = m(x, y, z)

puts result
