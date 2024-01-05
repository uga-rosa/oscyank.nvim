function oscyank#yank(text) abort
  call luaeval('require("oscyank.core").yank(_A.text)',
        \#{ text: a:text })
endfunction

function oscyank#callback(type) abort
  call luaeval('require("oscyank.core").yank_by("operator", _A.type)',
        \#{ type: a:type })
endfunction

function oscyank#yank_operator() abort
  set operatorfunc=oscyank#callback
  return 'g@'
endfunction

function oscyank#yank_visual() abort
  call luaeval('require("oscyank.core").yank_by("visual", _A.type)',
        \#{ type: visualmode() })
endfunction

function oscyank#yank_register(register) abort
  call luaeval('require("oscyank.core").yank(_A.text)',
        \#{ text: getreg(a:register) })
endfunction
