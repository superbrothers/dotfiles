syntax match TodoDone    '-\s\[[xX]\]\s.\+$'  display containedin=ALL
syntax match TodoNotDone '-\s\[\s\]\s.\+$'    display containedin=ALL
highlight TodoDone    ctermfg=green
highlight TodoNotDone ctermfg=red
