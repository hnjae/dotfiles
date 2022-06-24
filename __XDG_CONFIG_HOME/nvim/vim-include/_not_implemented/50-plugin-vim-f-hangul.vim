" 세벌식 최종 맞춤

            " \ && packer_plugins['vim-f-hangul'].loaded
    let han = {}
    " 0'th line
    let han['0'] = 'ㅋ'
    " 1st line
    let han['y'] = 'ㄹ'
    let han['u'] = 'ㄷ'
    let han['i'] = 'ㅁ'
    let han['o'] = 'ㅊ'
    let han['p'] = 'ㅍ'
    " 2nd line
    let han['h'] = 'ㄴ'
    let han['j'] = 'ㅇ'
    let han['k'] = 'ㄱ'
    let han['l'] = 'ㅈ'
    let han[';'] = 'ㅂ'
    let han["'"] = 'ㅌ'
    " 3rd line
    let han['n'] = 'ㅅ'
    let han['m'] = 'ㅎ'

    " 두벌식 비활성화 " 못함
    let g:vim_f_hangul_alias = han
