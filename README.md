
:execute '%g/\v(' . join(map(readfile("signals.txt"), 'escape(v:val, ''[]\/.^$*~'')'), '|') . ')/s/\<0\.3\>/6/g'
