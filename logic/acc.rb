rubyFileContents = File.read('logic.rb')

propositionMatches = rubyFileContents.scan(/if.*?\(.*?$/m)
propositions = propositionMatches.map { |a| a.to_s.sub('if ', '') }

clauses = propositions.map { |a| a.gsub('and', '') }
clauses = clauses.map { |a| a.gsub('or', '') }
clauses = clauses.map { |a| a.gsub(' ', '') }
clauses = clauses.map { |a| a.gsub('(', '') }
clauses = clauses.map { |a| a.gsub(')', '') }
clauses = clauses.map { |a| a.gsub('!', '') }

numClauses = clauses[0].length

puts 'Proposition(s):'
proposition = propositions[0]
puts proposition
puts

clauses = clauses[0].split('')

puts clauses

puts 'Proposition value:'
proposition = proposition.gsub('and', '&&')
proposition = proposition.gsub('or', '||')

for i in 0..2**numClauses-1
  inputs = i.to_s(2).rjust(numClauses, '0').split('')
  currProposition = proposition
  for j in 0..inputs.length-1       
    currProposition = currProposition.gsub(clauses[j], inputs[j].to_s)
  end
  currProposition = currProposition.gsub('&&', 'and')
  currProposition = currProposition.gsub('||', 'or')
  currProposition = currProposition.gsub('0', 'false')
  currProposition = currProposition.gsub('1', 'true')
  puts currProposition, eval(currProposition)
end
