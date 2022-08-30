# Base Functions
fn = lambda{|n| lambda{|f| lambda{|x| n == 0 ? x : f.(fn.(n-1).(f).(x))}}}

cn = lambda{|n| lambda{|f| lambda{|x| fn.(n).(f).(x)}}}
ctt = lambda{|x| lambda{|y| x}}
cff = lambda{|x| lambda{|y| y}}
cp = lambda{|h| lambda{|t| lambda{|f| f.(h).(t)}}}
cpt = lambda{|cp| cp.(cff)}
cph = lambda{|cp| cp.(ctt)}
cor = lambda{|x| lambda{|y| x.(ctt).(y)}}
cnot = lambda{|x| x.(cff).(ctt)}
cplus = lambda{|n| lambda{|f| lambda{|x| f.(n.(f).(x))}}}
cadd = lambda{|n| lambda{|m| n.(cplus).(m)}}
csub = lambda{|x| cpt.(x.(lambda{|p| cp.(cplus.(cph.(p))).(cph.(p))}).(cp.(cn.(0)).(cn.(0))))}
cpositive = lambda{|x| x.(cor.(ctt)).(cff)}
cminus = lambda{|x| lambda{|y| y.(csub).(x)}}
cless = lambda{|x| lambda{|y| cpositive.(cminus.(y).(x))}}
ceql = lambda{|x| lambda{|y| cnot.(cor.(cless.(x).(y)).(cless.(y).(x)))}}
cid = lambda{|x| x}

# New Functions
cl = lambda{|a| lambda{|b| lambda{|f| lambda{|x| f.(a).(b.(f).(x))}}}}
cnil = cff
clen = lambda{|l| l.(lambda{|x| lambda{|y| cplus.(y)}}).(cn.(0))}
capp = lambda{|l| lambda{|n| cl.(n).(l)}}
cmem = lambda{|l| lambda{|n| l.(lambda{|x| lambda{|y| cor.(ceql.(n).(x)).(y)}}).(cff)}}
cmap = lambda{|l| lambda{|f| l.(lambda{|x| lambda{|y| cl.(f.(x)).(y)}}).(cnil)}}
cfoldr = lambda{|l| lambda{|f| lambda{|s| l.(lambda{|x| lambda{|y| f.(x).(y)}}).(s)}}}
cfilter = lambda{|l| lambda{|f| l.(lambda{|x| lambda{|y| f.(x).(cl.(x).(y)).(y)}}).(cnil)}}

# Debugging
pcn = lambda{|cn| puts cn.(lambda{|x| x+1}).(0)}
pcl = lambda{|cl| cl.(lambda{|x| lambda{|y| pcn.(x)}}).(cnil)}
pb = lambda{|cb| puts cb.(true).(false)}

# Examples
cl012 = cl.(cn.(2)).(cl.(cn.(1)).(cl.(cn.(0)).(cnil)))
pcl.(cl012) # 0 1 2
pcn.(clen.(cl012)) # 3
pcl.(capp.(cl012).(cn.(3))) # 0 1 2 3
pcn.(clen.(capp.(cl012).(cn.(3)))) # 4
pb.(cmem.(cl012).(cn.(0))) # true
pb.(cmem.(cl012).(cn.(3))) # false
pcl.(cmap.(cl012).(cplus)) # 1 2 3
pcn.(cfoldr.(cl012).(cadd).(cn.(0))) # 3
pcn.(cfoldr.(capp.(cl012).(cn.(125))).(cadd).(cn.(4))) # 132
pcl.(cfilter.(cl012).(cpositive)) # 1 2
pcl.(cfilter.(cl012).(ceql.(cn.(0)))) # 0
