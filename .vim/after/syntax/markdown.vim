syntax region TodoDone    start="^\s*-\s\[[xX]\]" end="$" display containedin=ALL
syntax region TodoNotDone start="^\s*-\s\[\s\]"   end="$" display containedin=ALL
highlight TodoDone    ctermfg=green
highlight TodoNotDone ctermfg=red
