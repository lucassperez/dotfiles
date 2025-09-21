vim.cmd([[
let g:lexima_enable_basic_rules   = 0
let g:lexima_enable_newline_rules = 1
let g:lexima_enable_endwise_rules = 1

" call lexima#add_rule({'char': '>', 'at': '>\%#<', 'input': "<CR>\t", 'input_after': '<CR>', 'mode': 'i'})
"call lexima#add_rule({'char': '<CR>', 'at': '>\%#<', 'input': "<CR>\t", 'input_after': '<CR>', 'mode': 'i'})
]])
