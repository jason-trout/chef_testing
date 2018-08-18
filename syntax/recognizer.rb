#!/usr/bin/ruby

class PasswordGenerator

  def initialize(cmd)
    @cmd = cmd
    @special_chars = ['!', '@', '#', '$', '%', '^']
    @types = Hash.new
    parse
  end

  def parse()
    if @cmd.match(/generate password with ((\d \w+) ?){1,3}/)
      matches = @cmd.scan(/\d \w+/)
      matches.each {
        |m|
        tokens = m.split ' '
        key = tokens[1]
        val = tokens[0].to_i
        @types[key] = val
      }
    else
      raise 'Malformed command'
    end
  end

  def generate()
    @password = (0..15).map { ('a'..'z').to_a[rand(26)] }.join
    indexes = (0..15).to_a
    @types.each {
      |k,v|
      for i in 0..v-1
	r = indexes[rand(0..indexes.size-1)]
        if k == 'ucase'
	  @password[r] = @password[r].upcase
	elsif k == 'numeric'
	  @password[r] = rand(0..9).to_s
	else 
	  @password[r] = @special_chars[rand(0..@special_chars.size-1)]
        end
	indexes.delete(r)
      end
    }
    return @password
  end

  def get()
    return @password
  end
  
  def repOk()
    if @password.nil?
      return false
    end
    @types.each {
      |k,v|
      count = 0
      @password.split('').each {
        |c|
	if k == 'ucase'
	  if /[[:upper:]]/.match(c)
            count += 1
	  end
        elsif k == 'numeric'
	  if /[[:digit:]]/.match(c)
            count += 1
	  end
	else
  	  if @special_chars.include? c
	    count += 1
	  end
	end
      }
      unless count == v
        return false
      end
    }
    return true
  end

end

pg = PasswordGenerator.new('generate password with 2 ucase 1 ucase 2 special')
print 'repOk: ', pg.repOk
puts
pg.generate
password = pg.get
print 'repOk: ', pg.repOk
puts
puts password
