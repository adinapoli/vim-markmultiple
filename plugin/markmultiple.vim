" Copyright (C) 2012 Alfredo Di Napoli
" 
" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to deal
" in the Software without restriction, including without limitation the rights
" to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
" copies of the Software, and to permit persons to whom the Software is
" furnished to do so, subject to the following conditions:
" 
" The above copyright notice and this permission notice shall be included in all
" copies or substantial portions of the Software.
" 
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
" OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
" SOFTWARE.
" 
" Vim, arguably the best text-editor in the world.
" 
" Inspired from magnars' mark-multiple plugin.
"

" Main idea: The user start pressing CTRL-M to visually select the word
" under the cursor. Then when he press CTRL-M again, the editor should:
" 1) Save infos about previous selection for further reference.
" 2) Visually select the next word occurence.
" 3) Highlight the previous word occurence
" 4) When user leaves visual mode, every change should be put in place.
"

highlight MarkMultiple ctermbg=Darkgreen guibg=#8CCBEA


let b:mark_multiple_started = 0
let b:mark_multiple_in_normal_mode = 0
let b:mark_multiple_in_visual_mode = 1


nnoremap <C-m> :call MarkMultiple()<CR>
vnoremap <C-m> :call MarkMultiple()<CR>
au InsertEnter * call MarkMultipleToggle()
au InsertLeave * call MarkMultipleSubstitute()

fun! MarkMultiple()

    if b:mark_multiple_in_normal_mode
        call MarkMultipleNormal()
    endif

    if b:mark_multiple_in_visual_mode
        call MarkMultipleVisual()
    endif

endfunction


fun! MarkMultipleVisual()

    if !b:mark_multiple_started
        let b:mark_multiple_starting_curpos = getpos(".")
    endif

    let b:mark_multiple_started = 1
    let b:mark_multiple_curpos = getpos('.')
    let b:mark_multiple_word = GetWordUnderTheCursor()
    call SelectWord()
    "call HighlightRegion()
    call MarkMultipleSwapModes()
endfunction


fun! MarkMultipleSwapModes()
    let b:mark_multiple_in_normal_mode = !b:mark_multiple_in_normal_mode
    let b:mark_multiple_in_visual_mode = !b:mark_multiple_in_visual_mode
endfunction


fun! MarkMultipleNormal()
    if b:mark_multiple_started
        "Go to the next word
        \<Esc>
        call setpos('.', b:mark_multiple_curpos)
        normal *
        nohlsearch
    endif

    call MarkMultipleSwapModes()
endfunction

fun! MarkMultipleToggle()
    echo "I'm ready to substitute"
endfunction


fun! MarkMultipleSubstitute()

    if b:mark_multiple_started
        let new_word = GetWordUnderTheCursor()
        let start = b:mark_multiple_starting_curpos[1]
        let end   = b:mark_multiple_curpos[1]
        execute start .','. end .  's/\v<' . expand(b:mark_multiple_word) .  '>/' . expand(new_word) .'/g'
        let b:mark_multiple_started = 0
    endif
endfunction


fun! HighlightRegion()
  hi HColor ctermbg=DarkGreen guibg=#ff7777
  let l_start = line("'<")
  let l_end = line("'>") + 1
  execute 'syntax region HColor start=/\%'.l_start.'l/ end=/\%'.l_end.'l/'
endfunction


fun! GetWordUnderTheCursor()
    return expand("<cword>")
endfunction


fun! SelectWord()
    normal viw
endfunction
