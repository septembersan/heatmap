let s:hi_groups = []


fun! heatmap#get_visual_selection() abort
    " Why is this not a built-in Vim script function?!
    let [lnum1, col1] = getpos("'<")[1:2]
    let [lnum2, col2] = getpos("'>")[1:2]
    let lines = getline(lnum1, lnum2)
    if lnum1 == 0 && lnum2 == 0 && col1 == 0 && col2 == 0
        return ''
    endif
    let lines[-1] = lines[-1][:col2 - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][col1 - 1:]
    return join(lines, "\n")
endf



fun! heatmap#display()
    let str = heatmap#get_visual_selection()
    call heatmap#run(str)
endf


fun! heatmap#run(str)
    " let str = "[[0.037922 0.065503 0.00001 0.027493 0.013345]\n[0.008397 0.016938 0.031424 0.03608 0.048998]]"
    let str = a:str
    for pat in ["[", "]", ","]
        let str = substitute(str, pat, "", "g")
    endfor
    let str = substitute(str, "\n", " ", "g")
    let nums = sort(split(str, " "))

    let hi_value = 16
    let nhi_dict = {}
    for n in nums
        let hi_value += 1
        if empty(n)
            continue
        endif
        let nhi_dict[n] = hi_value
    endfor

    let l_start = line("'<")
    let l_end = line("'>") + 1
    for k in keys(nhi_dict)
        exec printf('syn match %s /%s/', k, k)
        " exec 'syntax region '.k.' start=/\%'.l_start.'l/ end=/\%'.l_end.'l/'
        exec printf('hi %s ctermfg=%d ctermbg=NONE guifg=NONE guibg=NONE', k, nhi_dict[k])
        let s:hi_groups = add(s:hi_groups, k)
        " syn match OkadaOkada /0.037922/
        " hi OkadaOkada ctermfg=Blue
    endfor
    " return nhi_dict
endf


fun! heatmap#disable()
    for group_name in s:hi_groups
        exec 'hi clear '.group_name
    endfor
    let s:hi_groups = []
endf
