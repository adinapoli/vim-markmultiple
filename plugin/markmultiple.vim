if exists("g:loaded_mark_multiple") || &cp
  finish
endif

let g:loaded_mark_multiple = 1
let s:keepcpo = &cpo
set cpo&vim

if !exists("g:mark_multiple_started")
    let g:mark_multiple_started = 0
endif

if !exists("g:mark_multiple_searching")
    let g:mark_multiple_searching = 0
endif


if !exists("g:mark_multiple_in_normal_mode")
    let g:mark_multiple_in_normal_mode = 0
endif


if !exists("g:mark_multiple_in_visual_mode")
    let g:mark_multiple_in_visual_mode = 1
endif


if !exists("g:mark_multiple_current_chars_on_the_line")
    let g:mark_multiple_current_chars_on_the_line = col('$')
endif



" Leave space for user customization.
if !exists("g:mark_multiple_trigger")
    let g:mark_multiple_trigger = "<C-n>"
endif


if g:mark_multiple_trigger != ''
    :execute "nnoremap ". g:mark_multiple_trigger ." :call MarkMultiple()<CR>"
    :execute "xnoremap ". g:mark_multiple_trigger ." :call MarkMultiple()<CR>"
endif
au InsertLeave * call MarkMultipleSubstitute()


fun! MarkMultiple()
    if GetWordUnderTheCursor() == ""
        let g:mark_multiple_started = 0
    else
        if g:mark_multiple_in_normal_mode
            call MarkMultipleNormal()
        endif

        if g:mark_multiple_in_visual_mode
            call MarkMultipleVisual()
        endif
    endif
endfunction


fun! MarkMultipleVisual()

    if !g:mark_multiple_started
        let g:mark_multiple_starting_curpos = getpos(".")
        let g:mark_multiple_current_chars_on_the_line = col('$')
        let g:mark_multiple_curpos = g:mark_multiple_starting_curpos
    endif

    let g:mark_multiple_started = 1
    let g:mark_multiple_current_chars_on_the_line = col('$')
    let g:mark_multiple_word = GetWordUnderTheCursor()
    call MarkMultipleSetCursor()
    call SelectWord()
    call HighlightWord()
    call MarkMultipleSwapModes()
endfunction


" This ensures the cursor is properly set.
fun! MarkMultipleSetCursor()


    " If we are iterating through words,
    " leave to Vim the matching stuff
    if !g:mark_multiple_searching

        let original_position = getpos('.')

        " New algorithm, it relies as much as possible on visual selection
        " of a word.
        normal! vw
        normal! b
        if getpos('.')[2] < original_position[2]
            :execute "normal! \e"
        endif
    endif

    let g:mark_multiple_curpos = getpos('.')
endfun


fun! HighlightWord()
    let line_to_match = g:mark_multiple_curpos[1]
    let col_start = g:mark_multiple_curpos[2] - 1
    let col_end   = g:mark_multiple_curpos[2] + len(g:mark_multiple_word)
    let pattern = '\%'.line_to_match.'l\%>'.col_start.'c\%<'.col_end.'c'
    call matchadd('Search', pattern)
endfun


fun! MarkMultipleSwapModes()
    let g:mark_multiple_in_normal_mode = !g:mark_multiple_in_normal_mode
    let g:mark_multiple_in_visual_mode = !g:mark_multiple_in_visual_mode
endfunction


fun! MarkMultipleNormal()
    if g:mark_multiple_started
        let g:mark_multiple_searching = 1
        "Go to the next word
        call setpos('.', g:mark_multiple_curpos)

        "Search for the next word, but disable search highlighting
        normal! *
        nohlsearch
    endif

    call MarkMultipleSwapModes()
endfunction


fun! MarkMultipleSubstitute()

    if g:mark_multiple_started

        "Protect against invalid subs.
        let valid_sub = MarkMultipleValidSubstitution(col('$'))
        if !valid_sub
            let new_word = ""
        else
            let new_word = GetWordUnderTheCursor()
        endif

        let start = g:mark_multiple_starting_curpos[1]
        let end   = g:mark_multiple_curpos[1]
        silent! execute start .','. end .  's/\v<' . expand(g:mark_multiple_word) .  '>/' . expand(new_word) .'/g'
        let g:mark_multiple_started = 0
        let g:mark_multiple_searching = 0

        "Restore cursor under the last matched
        call setpos('.', g:mark_multiple_curpos)

        "Clear highlighting
        call clearmatches()
    endif
endfunction


" Call this to clear all the highlightings
fun! MarkMultipleClean()
    call clearmatches()
    let g:mark_multiple_started = 0
    let g:mark_multiple_searching = 0
    let g:mark_multiple_in_normal_mode = 0
    let g:mark_multiple_in_visual_mode = 1
endfunction


fun! MarkMultipleValidSubstitution(chars_on_the_line)

    "Exploit the length of the prev line to determine if
    "something was changed
    let prev_chars = g:mark_multiple_current_chars_on_the_line
    if a:chars_on_the_line <= (prev_chars - len(g:mark_multiple_word))
        return 0
    endif

    return 1
endfunction


fun! GetWordUnderTheCursor()
    return expand("<cword>")
endfunction


fun! SelectWord()
    silent! normal! zO
    normal! viw
endfunction

let &cpo = s:keepcpo
unlet s:keepcpo

" vim: et sw=4
