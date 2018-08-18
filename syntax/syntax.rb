#!/usr/bin/ruby

require 'set'

# BNF
bnf = [
  '<S>::=<M>',
  '<M>::=generate password with <Q>',
  '<P>::=<N> <T>',
  '<Q>::=<P>[1,2]',
  '<N>::=1|2',
  '<T>::=ucase|numeric'
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
p 'Nonterminals', nonterminals
