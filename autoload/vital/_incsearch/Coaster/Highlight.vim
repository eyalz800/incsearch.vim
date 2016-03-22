scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


function! s:_vital_loaded(V)
	let s:V = a:V
	let s:Window = a:V.import("Coaster.Window")
	let s:Gift = a:V.import("Gift")
	call s:_init()
endfunction


function! s:_vital_depends()
	return [
\		"Coaster.Window",
\		"Gift",
\	]
endfunction



let s:base = {
\	"variables" : {
\		"hl_list" : {},
\		"id_list" : {}
\	}
\}


function! s:base.add(name, group, pattern, ...)
	call self.delete(a:name)
	let priority = get(a:, 1, 10)
	let self.variables.hl_list[a:name] = {
\		"group" : a:group,
\		"pattern" : a:pattern,
\		"priority" : priority,
\		"name" : a:name,
\	}
endfunction


function! s:base.is_added(name)
	return has_key(self.variables.hl_list, a:name)
endfunction


function! s:base.hl_list()
	return keys(self.variables.hl_list)
endfunction


function! s:base.to_list()
	return values(self.variables.hl_list)
endfunction


function! s:_is_equal(__expr, __hl)
	let name     = a:__hl.name
	let group    = a:__hl.group
	let pattern  = a:__hl.pattern
	let priority = a:__hl.priority
	return eval(a:__expr)
endfunction


function! s:base.to_list_by(expr)
	return filter(values(self.variables.hl_list), "s:_is_equal(a:expr, v:val)")
endfunction


function! s:base.enable_list(...)
	let window = get(a:, 1, s:Gift.uniq_winnr())
	return keys(get(self.variables.id_list, window, {}))
endfunction


function! s:base.delete(name)
	if !self.is_added(a:name)
		return -1
	endif
	unlet! self.variables.hl_list[a:name]
endfunction


function! s:base.delete_by(expr)
	return map(self.to_list_by(a:expr), "self.delete(v:val.name)")
endfunction


function! s:base.delete_all()
	for name in self.hl_list()
		call self.delete(name)
	endfor
endfunction


function! s:base.get_hl_id(name, ...)
	let window = get(a:, 1, s:Gift.uniq_winnr())
	return get(get(self.variables.id_list, window, {}), a:name, "")
endfunction


function! s:base.is_enabled(name, ...)
	let window = get(a:, 1, s:Gift.uniq_winnr())
	return self.get_hl_id(a:name, window) != ""
endfunction


function! s:base.enable(name)
	let hl = get(self.variables.hl_list, a:name, {})
	if empty(hl)
		return -1
	endif
	if self.is_enabled(a:name)
		call self.disable(a:name)
	endif
	let winnr = s:Gift.uniq_winnr()
	if !has_key(self.variables.id_list, winnr)
		let self.variables.id_list[winnr] = {}
	endif
	let self.variables.id_list[winnr][a:name] = matchadd(hl.group, hl.pattern, hl.priority)
endfunction


function! s:base.enable_all()
	for name in self.hl_list()
		call self.enable(name)
	endfor
endfunction


function! s:base.disable(name)
	if !self.is_enabled(a:name)
		return -1
	endif
	let id = -1
	silent! let id = matchdelete(self.get_hl_id(a:name))
	if id == -1
		return -1
	endif
	let winnr = get(a:, 1, s:Gift.uniq_winnr())
	unlet! self.variables.id_list[winnr][a:name]
endfunction


function! s:base.disable_all()
	for name in self.enable_list()
		call self.disable(name)
	endfor
endfunction


function! s:base.update(name)
	call self.disable(a:name)
	call self.enable(a:name)
endfunction


function! s:base.update_all()
	call self.disable_all()
	call self.enable_all()
endfunction


function! s:base.highlight(name, group, pattern, ...)
	let priority = get(a:, 1, 10)
	call self.add(a:name, a:group, a:pattern, priority)
	call self.enable(a:name)
endfunction


function! s:base.clear(name)
	call self.disable(a:name)
	call self.delete(a:name)
endfunction


function! s:base.clear_all()
	call self.disable_all()
	call self.delete_all()
endfunction


function! s:base.as_windo()
	return self.windo
endfunction


function! s:make()
	let result = deepcopy(s:base)
	let result.windo = s:Window.as_windo(result)
	return result
endfunction


let s:global = deepcopy(s:base)
let s:funcs =  keys(filter(copy(s:global), "type(v:val) == type(function('tr'))"))

for s:name in s:funcs
	execute
\		"function! s:" . s:name . "(...) \n"
\			"return call(s:global." . s:name . ", a:000, s:global) \n"
\		"endfunction"
endfor
unlet s:name


function! s:_init()
	let s:global.windo = s:Window.as_windo(s:global)
endfunction

" function! s:matchadd(...)
" 	return {
" \		"id" : call("matchadd", a:000),
" \		"bufnr" : bufnr("%"),
" \	}
" endfunction
"
"
" function! s:matchdelete(id)
" 	if empty(a:id)
" 		return -1
" 	endif
" 	return s:Buffer.execute(a:id.bufnr, "call matchdelete(" . a:id.id . ")")
" endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
" ___Revitalizer___
" NOTE: below code is generated by :Revitalize.
" Do not mofidify the code nor append new lines
if v:version > 703 || v:version == 703 && has('patch1170')
  function! s:___revitalizer_function___(fstr) abort
    return function(a:fstr)
  endfunction
else
  function! s:___revitalizer_SID() abort
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze____revitalizer_SID$')
  endfunction
  let s:___revitalizer_sid = '<SNR>' . s:___revitalizer_SID() . '_'
  function! s:___revitalizer_function___(fstr) abort
    return function(substitute(a:fstr, 's:', s:___revitalizer_sid, 'g'))
  endfunction
endif

let s:___revitalizer_functions___ = {'_vital_depends': s:___revitalizer_function___('s:_vital_depends'),'_vital_loaded': s:___revitalizer_function___('s:_vital_loaded'),'add': s:___revitalizer_function___('s:add'),'as_windo': s:___revitalizer_function___('s:as_windo'),'clear': s:___revitalizer_function___('s:clear'),'clear_all': s:___revitalizer_function___('s:clear_all'),'delete': s:___revitalizer_function___('s:delete'),'delete_all': s:___revitalizer_function___('s:delete_all'),'delete_by': s:___revitalizer_function___('s:delete_by'),'disable': s:___revitalizer_function___('s:disable'),'disable_all': s:___revitalizer_function___('s:disable_all'),'enable': s:___revitalizer_function___('s:enable'),'enable_all': s:___revitalizer_function___('s:enable_all'),'enable_list': s:___revitalizer_function___('s:enable_list'),'get_hl_id': s:___revitalizer_function___('s:get_hl_id'),'highlight': s:___revitalizer_function___('s:highlight'),'hl_list': s:___revitalizer_function___('s:hl_list'),'is_added': s:___revitalizer_function___('s:is_added'),'is_enabled': s:___revitalizer_function___('s:is_enabled'),'make': s:___revitalizer_function___('s:make'),'to_list': s:___revitalizer_function___('s:to_list'),'to_list_by': s:___revitalizer_function___('s:to_list_by'),'update': s:___revitalizer_function___('s:update'),'update_all': s:___revitalizer_function___('s:update_all')}

unlet! s:___revitalizer_sid
delfunction s:___revitalizer_function___

function! vital#_incsearch#Coaster#Highlight#import() abort
  return s:___revitalizer_functions___
endfunction
" ___Revitalizer___
