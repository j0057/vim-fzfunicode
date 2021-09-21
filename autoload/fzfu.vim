function fzfu#GetCachedNamesList()
    let unicode_version = '14.0.0'
    let xdg_cache = ($XDG_CACHE_HOME ?? ($HOME .. '/.cache')) .. '/fzf-unicode'
    let names_list = printf('%s/NamesList-%s.txt', xdg_cache, unicode_version)
    let names_url = printf('https://www.unicode.org/Public/%s/ucd/NamesList.txt', unicode_version)

    if ! isdirectory(xdg_cache)
        call mkdir(xdg_cache, 'p')
    endif

    if ! filereadable(names_list)
        echo 'Downloading ' .. names_url .. '...'
        let curl = printf('curl %s -o %s', names_url, shellescape(names_list))
        call system(curl)
    endif

    return names_list
endfunction

function! fzfu#FzfUnicode()
    let names_list = fzfu#GetCachedNamesList()
    let lines = fzf#run({'source': "awk 'BEGIN{FS=\"\\t\"}
                       \                 /^[0-9A-F]+/{chr=strtonum(\"0x\" $1); printf(\"%08x — U+%04X — %s\\n\", chr, chr, $2)}
                       \                 /^\\t=/{printf \"%08x — U+%04X — %s\\n\", chr, chr, $2}'
                       \                 " .. names_list,
                       \ 'options': ['--delimiter', ' — ',
                       \             '--with-nth', '2..',
                       \             '--preview', 'for c in {+1}; do echo -en "\U$c"; done',
                       \             '--preview-window', 'down,1',
                       \             '--multi',
                       \             '--bind', 'tab:toggle',
                       \             '--bind', 'btab:toggle']})
    let codepoints =  map(copy(lines), {i, line -> eval(printf('"\U%08X"', str2nr(split(line)[0], 16)))})
    return join(codepoints, '')
endfunction
