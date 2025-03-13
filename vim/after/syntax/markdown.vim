syntax region TodoDone    start="^\s*-\s\[[xX]\]" end="$" display containedin=ALL
syntax region TodoNotDone start="^\s*-\s\[\s\]"   end="$" display containedin=ALL
highlight TodoDone    ctermfg=green guifg=#a6e22e
highlight TodoNotDone ctermfg=red guifg=#f92672

" Code block for Qiita Markdown Syntax
syntax region mkdCode start=/^\s*\z(`\{3,}\)\s*[0-9A-Za-z_+-:]*\s*$/ end=/^\s*\z1`*\s*$/
