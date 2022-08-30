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
csub = lambda{|x| cpt.(x.(lambda{|p| cp.(cplus.(cph.(p))).(cph.(p))}).(cp.(cn.(0)).(cn.(0))))}

# New Functions
cpositive = lambda{|x| x.(cor.(ctt)).(cff)}
cminus = lambda{|x| lambda{|y| y.(csub).(x)}}
cless = lambda{|x| lambda{|y| cpositive.(cminus.(y).(x))}}
ceql = lambda{|x| lambda{|y| cnot.(cor.(cless.(x).(y)).(cless.(y).(x)))}}

# Debugging
pcn = lambda{|cn| puts cn.(lambda{|x| x+1}).(0)}
pb = lambda{|cb| puts cb.(true).(false)}

# Examples
pcn.(cn.(5)) # 5
pb.(cff) # false
pb.(cpositive.(cn.(0))) # false
pb.(cpositive.(cn.(1))) # true
pcn.(cminus.(cn.(1)).(cn.(2))) # 0
pcn.(cminus.(cn.(5)).(cn.(2))) # 3
pb.(cless.(cn.(0)).(cn.(1))) # true
pb.(ceql.(cn.(45)).(cn.(45))) # true
