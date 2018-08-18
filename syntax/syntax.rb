#!/usr/bin/ruby

require 'set'

# BNF
bnf = [
  '<S>::=<M>',
  '<M>::=generate password with <Q>',
  '<P>::=<N> <T>',
  '<Q>::=<P>[1,3]',
  '<N>::=1|2|3|4|5',
  '<T>::=ucase|numeric|special'
]
puts 'BNF', bnf
puts

# Simplify BNF
simplified_bnf = []
bnf.each {
  |r|
  tokens = r.split '::='
  nonterminal = tokens[0]
  expansions = tokens[1]
  expansions_tokens = expansions.split '|'
  expansions_tokens.each {
    |e|
    match = e.match(/(\<.*?\>)\[(\d+),(\d+)\]/)
    unless match.nil?   
      expansion, lower_bound, upper_bound = match.captures
      lower_bound = lower_bound.to_i
      upper_bound = upper_bound.to_i
      for i in lower_bound..upper_bound 
        simplified_bnf.push(nonterminal + '::=' + ((expansion + ' ') * i).strip)
      end
    else
      simplified_bnf.push(nonterminal + '::=' + e)
    end

  }
}

puts "Simplified BNF", simplified_bnf
puts

# Nonterminal to expansions mapping
nonterminals = Hash.new
simplified_bnf.each {
  |r|
  tokens = r.split '::='
  nonterminal = tokens[0]
  expansion = tokens[1]

  if nonterminals[nonterminal].nil? 
    nonterminals[nonterminal] = []
  end

  nonterminals[nonterminal].push(expansion)
}
puts 'Nonterminals'
nonterminals.each {
  |k, v|
  puts k, "#{v}"
}
puts

# Generate strings
start_time = Time.now
strings = Set['<S>']
prev_strings_size = strings.size
loop do
  strings_to_add = Set[]
  puts strings
  strings.each { 
    |s|
    tokens = s.split ' ' 
    tokens.each_with_index { 
      |t, i|
      expansions = nonterminals[t]
      unless expansions.nil?
        expansions.each {
          |e|
	  working_tokens = s.split ' '
	  working_str = ''
	  working_tokens.each_with_index {
	    |wt, j|
	    unless j == i
	     working_str += ' ' +working_tokens[j]
	    else
	     working_str += ' ' + e
	    end
	  }
	  working_str.strip
  	  strings_to_add.add(working_str)
        }
      end
    }
  }
  strings.merge(strings_to_add)

  unless strings.size == prev_strings_size
    prev_strings_size = strings.size
  else
    strings_to_remove = []
    strings.each {
      |s|
      if /\<.*?\>/.match(s)
        strings_to_remove.push(s)
      end
    }
    strings.subtract(strings_to_remove)
    break
  end
end
stop_time = Time.now


strings.each {
  |s| puts s
}

print 'Generated ', strings.size, ' strings in ' + (stop_time - start_time).to_s + 's'
puts
