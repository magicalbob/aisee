#!/Users/ian/.rvm/rubies/ruby-2.2.0/bin/ruby

aPoint = Struct.new(:x,:y)

xlist = Array.new

np = aPoint.new
np.x = 1
np.y = 1

xlist.push(np)

np.x = 1
np.y = 2

xlist.push(np)

xlist.select {|xp| puts(xp) }
