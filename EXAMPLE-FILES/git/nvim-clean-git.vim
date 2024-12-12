set notermguicolors
"hi ColorColumn ctermbg=125 ctermfg=white
hi ColorColumn ctermfg=DarkRed ctermbg=125 guibg=DarkRed
set colorcolumn=51
set textwidth=0
map <C-q> :wq<CR>
nmap H ^
nmap L $
nmap } }k
nmap <Space><Space> }ddggpcwf<Esc>

" Colorscheme do nvim 0.9.5
"hi ColorColumn    ctermfg=15 ctermbg=125 guibg=DarkRed
hi Comment        ctermfg=14 guifg=#80a0ff
hi Conceal        ctermfg=7 ctermbg=242 guifg=LightGrey guibg=DarkGrey
hi Constant       ctermfg=13 guifg=#ffa0a0
hi Cursor         guifg=bg guibg=fg
hi CursorColumn   ctermbg=242 guibg=Grey40
hi CursorLine     cterm=underline guibg=Grey40
hi CursorLineNr   cterm=underline ctermfg=11 gui=bold guifg=Yellow
hi DiagnosticDeprecated cterm=strikethrough gui=strikethrough guisp=Red
hi DiagnosticError ctermfg=1 guifg=Red
hi DiagnosticHint ctermfg=7 guifg=LightGrey
hi DiagnosticInfo ctermfg=4 guifg=LightBlue
hi DiagnosticOk   ctermfg=10 guifg=LightGreen
hi DiagnosticUnderlineError cterm=underline gui=underline guisp=Red
hi DiagnosticUnderlineHint cterm=underline gui=underline guisp=LightGrey
hi DiagnosticUnderlineInfo cterm=underline gui=underline guisp=LightBlue
hi DiagnosticUnderlineOk cterm=underline gui=underline guisp=LightGreen
hi DiagnosticUnderlineWarn cterm=underline gui=underline guisp=Orange
hi DiagnosticWarn ctermfg=3 guifg=Orange
hi DiffAdd        ctermbg=4 guibg=DarkBlue
hi DiffChange     ctermbg=5 guibg=DarkMagenta
hi DiffDelete     ctermfg=12 ctermbg=6 gui=bold guifg=Blue guibg=DarkCyan
hi DiffText       cterm=bold ctermbg=9 gui=bold guibg=Red
hi Directory      ctermfg=159 guifg=Cyan
hi Error          ctermfg=15 ctermbg=9 guifg=White guibg=Red
hi ErrorMsg       ctermfg=15 ctermbg=1 guifg=White guibg=Red
hi FloatShadow    guibg=Black blend=80
hi FloatShadowThrough guibg=Black blend=100
hi FoldColumn     ctermfg=14 ctermbg=242 guifg=Cyan guibg=Grey
hi Folded         ctermfg=14 ctermbg=242 guifg=Cyan guibg=DarkGrey
hi Identifier     cterm=bold ctermfg=14 guifg=#40ffff
hi Ignore         ctermfg=0 guifg=bg
hi IncSearch      cterm=reverse gui=reverse
hi LineNr         ctermfg=11 guifg=Yellow
hi MatchParen     ctermbg=6 guibg=DarkCyan
hi ModeMsg        cterm=bold gui=bold
hi MoreMsg        ctermfg=121 gui=bold guifg=SeaGreen
hi NonText        ctermfg=12 gui=bold guifg=Blue
hi NvimInternalError ctermfg=9 ctermbg=9 guifg=Red guibg=Red
hi Pmenu          ctermfg=0 ctermbg=13 guibg=Magenta
hi PmenuSbar      ctermbg=248 guibg=Grey
hi PmenuSel       ctermfg=242 ctermbg=0 guibg=DarkGrey
hi PmenuThumb     ctermbg=15 guibg=White
hi PreProc        ctermfg=81 guifg=#ff80ff
hi Question       ctermfg=121 gui=bold guifg=Green
hi RedrawDebugClear ctermbg=11 guibg=Yellow
hi RedrawDebugComposed ctermbg=10 guibg=Green
hi RedrawDebugNormal cterm=reverse gui=reverse
hi RedrawDebugRecompose ctermbg=9 guibg=Red
hi Search         ctermfg=0 ctermbg=11 guifg=Black guibg=Yellow
hi SignColumn     ctermfg=14 ctermbg=242 guifg=Cyan guibg=Grey
hi Special        ctermfg=224 guifg=Orange
hi SpecialKey     ctermfg=81 guifg=Cyan
hi SpellBad       ctermbg=9 gui=undercurl guisp=Red
hi SpellCap       ctermbg=12 gui=undercurl guisp=Blue
hi SpellLocal     ctermbg=14 gui=undercurl guisp=Cyan
hi SpellRare      ctermbg=13 gui=undercurl guisp=Magenta
hi Statement      ctermfg=11 gui=bold guifg=#ffff60
hi StatusLine     cterm=bold,reverse gui=bold,reverse
hi StatusLineNC   cterm=reverse gui=reverse
hi TabLine        cterm=underline ctermfg=15 ctermbg=242 gui=underline guibg=DarkGrey
hi TabLineFill    cterm=reverse gui=reverse
hi TabLineSel     cterm=bold gui=bold
hi TermCursor     cterm=reverse gui=reverse
hi Title          ctermfg=225 gui=bold guifg=Magenta
hi Todo           ctermfg=0 ctermbg=11 guifg=Blue guibg=Yellow
hi Type           ctermfg=121 gui=bold guifg=#60ff60
hi Underlined     cterm=underline ctermfg=81 gui=underline guifg=#80a0ff
hi Visual         ctermbg=242 guibg=DarkGrey
hi WarningMsg     ctermfg=224 guifg=Red
hi WildMenu       ctermfg=0 ctermbg=11 guifg=Black guibg=Yellow
hi WinBar         cterm=bold gui=bold

hi clear @lsp
hi clear @text
hi clear MsgArea
hi clear Normal
hi clear NormalNC
hi clear TermCursorNC
hi clear VisualNC
hi lCursor        guifg=bg guibg=fg

hi link @boolean Boolean
hi link @character Character
hi link @character.special SpecialChar
hi link @comment Comment
hi link @conditional Conditional
hi link @constant Constant
hi link @constant.builtin Special
hi link @constant.macro Define
hi link @constructor Special
hi link @debug Debug
hi link @define Define
hi link @exception Exception
hi link @field Identifier
hi link @float Float
hi link @function Function
hi link @function.builtin Special
hi link @function.macro Macro
hi link @include Include
hi link @keyword Keyword
hi link @label Label
hi link @lsp.type.class Structure
hi link @lsp.type.comment Comment
hi link @lsp.type.decorator Function
hi link @lsp.type.enum Structure
hi link @lsp.type.enumMember Constant
hi link @lsp.type.function Function
hi link @lsp.type.interface Structure
hi link @lsp.type.macro Macro
hi link @lsp.type.method Function
hi link @lsp.type.namespace Structure
hi link @lsp.type.parameter Identifier
hi link @lsp.type.property Identifier
hi link @lsp.type.struct Structure
hi link @lsp.type.type Type
hi link @lsp.type.typeParameter Typedef
hi link @lsp.type.variable Identifier
hi link @macro Macro
hi link @method Function
hi link @namespace Identifier
hi link @number Number
hi link @operator Operator
hi link @parameter Identifier
hi link @preproc PreProc
hi link @property Identifier
hi link @punctuation Delimiter
hi link @repeat Repeat
hi link @storageclass StorageClass
hi link @string String
hi link @string.escape SpecialChar
hi link @string.special SpecialChar
hi link @tag Tag
hi link @text.literal Comment
hi link @text.reference Identifier
hi link @text.title Title
hi link @text.todo Todo
hi link @text.underline Underlined
hi link @text.uri Underlined
hi link @type Type
hi link @type.definition Typedef
hi link @variable Identifier
hi link Boolean Constant
hi link Character Constant
hi link Conditional Statement
hi link CurSearch Search
hi link CursorLineFold FoldColumn
hi link CursorLineSign SignColumn
hi link Debug Special
hi link Define PreProc
hi link Delimiter Special
hi link DiagnosticFloatingError DiagnosticError
hi link DiagnosticFloatingHint DiagnosticHint
hi link DiagnosticFloatingInfo DiagnosticInfo
hi link DiagnosticFloatingOk DiagnosticOk
hi link DiagnosticFloatingWarn DiagnosticWarn
hi link DiagnosticSignError DiagnosticError
hi link DiagnosticSignHint DiagnosticHint
hi link DiagnosticSignInfo DiagnosticInfo
hi link DiagnosticSignOk DiagnosticOk
hi link DiagnosticSignWarn DiagnosticWarn
hi link DiagnosticUnnecessary Comment
hi link DiagnosticVirtualTextError DiagnosticError
hi link DiagnosticVirtualTextHint DiagnosticHint
hi link DiagnosticVirtualTextInfo DiagnosticInfo
hi link DiagnosticVirtualTextOk DiagnosticOk
hi link DiagnosticVirtualTextWarn DiagnosticWarn
hi link EndOfBuffer    NonText
hi link Exception Statement
hi link Float Number
hi link FloatBorder WinSeparator
hi link FloatTitle Title
hi link Function Identifier
hi link Include PreProc
hi link Keyword Statement
hi link Label Statement
hi link LineNrAbove LineNr
hi link LineNrBelow LineNr
hi link Macro PreProc
hi link MsgSeparator StatusLine
hi link NormalFloat Pmenu
hi link Number Constant
hi link NvimAnd NvimBinaryOperator
hi link NvimArrow Delimiter
hi link NvimAssignment Operator
hi link NvimAssignmentWithAddition NvimAugmentedAssignment
hi link NvimAssignmentWithConcatenation NvimAugmentedAssignment
hi link NvimAssignmentWithSubtraction NvimAugmentedAssignment
hi link NvimAugmentedAssignment NvimAssignment
hi link NvimBinaryMinus NvimBinaryOperator
hi link NvimBinaryOperator NvimOperator
hi link NvimBinaryPlus NvimBinaryOperator
hi link NvimCallingParenthesis NvimParenthesis
hi link NvimColon Delimiter
hi link NvimComma Delimiter
hi link NvimComparison NvimBinaryOperator
hi link NvimComparisonModifier NvimComparison
hi link NvimConcat NvimBinaryOperator
hi link NvimConcatOrSubscript NvimConcat
hi link NvimContainer NvimParenthesis
hi link NvimCurly NvimSubscript
hi link NvimDict NvimContainer
hi link NvimDivision NvimBinaryOperator
hi link NvimDoubleQuote NvimStringQuote
hi link NvimDoubleQuotedBody NvimStringBody
hi link NvimDoubleQuotedEscape NvimStringSpecial
hi link NvimDoubleQuotedUnknownEscape NvimInvalidValue
hi link NvimEnvironmentName NvimIdentifier
hi link NvimEnvironmentSigil NvimOptionSigil
hi link NvimFigureBrace NvimInternalError
hi link NvimFloat NvimNumber
hi link NvimIdentifier Identifier
hi link NvimIdentifierKey NvimIdentifier
hi link NvimIdentifierName NvimIdentifier
hi link NvimIdentifierScope NvimIdentifier
hi link NvimIdentifierScopeDelimiter NvimIdentifier
hi link NvimInvalid Error
hi link NvimInvalidAnd NvimInvalidBinaryOperator
hi link NvimInvalidArrow NvimInvalidDelimiter
hi link NvimInvalidAssignment NvimInvalid
hi link NvimInvalidAssignmentWithAddition NvimInvalidAugmentedAssignment
hi link NvimInvalidAssignmentWithConcatenation NvimInvalidAugmentedAssignment
hi link NvimInvalidAssignmentWithSubtraction NvimInvalidAugmentedAssignment
hi link NvimInvalidAugmentedAssignment NvimInvalidAssignment
hi link NvimInvalidBinaryMinus NvimInvalidBinaryOperator
hi link NvimInvalidBinaryOperator NvimInvalidOperator
hi link NvimInvalidBinaryPlus NvimInvalidBinaryOperator
hi link NvimInvalidCallingParenthesis NvimInvalidParenthesis
hi link NvimInvalidColon NvimInvalidDelimiter
hi link NvimInvalidComma NvimInvalidDelimiter
hi link NvimInvalidComparison NvimInvalidBinaryOperator
hi link NvimInvalidComparisonModifier NvimInvalidComparison
hi link NvimInvalidConcat NvimInvalidBinaryOperator
hi link NvimInvalidConcatOrSubscript NvimInvalidConcat
hi link NvimInvalidContainer NvimInvalidParenthesis
hi link NvimInvalidCurly NvimInvalidSubscript
hi link NvimInvalidDelimiter NvimInvalid
hi link NvimInvalidDict NvimInvalidContainer
hi link NvimInvalidDivision NvimInvalidBinaryOperator
hi link NvimInvalidDoubleQuote NvimInvalidStringQuote
hi link NvimInvalidDoubleQuotedBody NvimInvalidStringBody
hi link NvimInvalidDoubleQuotedEscape NvimInvalidStringSpecial
hi link NvimInvalidDoubleQuotedUnknownEscape NvimInvalidValue
hi link NvimInvalidEnvironmentName NvimInvalidIdentifier
hi link NvimInvalidEnvironmentSigil NvimInvalidOptionSigil
hi link NvimInvalidFigureBrace NvimInvalidDelimiter
hi link NvimInvalidFloat NvimInvalidNumber
hi link NvimInvalidIdentifier NvimInvalidValue
hi link NvimInvalidIdentifierKey NvimInvalidIdentifier
hi link NvimInvalidIdentifierName NvimInvalidIdentifier
hi link NvimInvalidIdentifierScope NvimInvalidIdentifier
hi link NvimInvalidIdentifierScopeDelimiter NvimInvalidIdentifier
hi link NvimInvalidLambda NvimInvalidParenthesis
hi link NvimInvalidList NvimInvalidContainer
hi link NvimInvalidMod NvimInvalidBinaryOperator
hi link NvimInvalidMultiplication NvimInvalidBinaryOperator
hi link NvimInvalidNestingParenthesis NvimInvalidParenthesis
hi link NvimInvalidNot NvimInvalidUnaryOperator
hi link NvimInvalidNumber NvimInvalidValue
hi link NvimInvalidNumberPrefix NvimInvalidNumber
hi link NvimInvalidOperator NvimInvalid
hi link NvimInvalidOptionName NvimInvalidIdentifier
hi link NvimInvalidOptionScope NvimInvalidIdentifierScope
hi link NvimInvalidOptionScopeDelimiter NvimInvalidIdentifierScopeDelimiter
hi link NvimInvalidOptionSigil NvimInvalidIdentifier
hi link NvimInvalidOr NvimInvalidBinaryOperator
hi link NvimInvalidParenthesis NvimInvalidDelimiter
hi link NvimInvalidPlainAssignment NvimInvalidAssignment
hi link NvimInvalidRegister NvimInvalidValue
hi link NvimInvalidSingleQuote NvimInvalidStringQuote
hi link NvimInvalidSingleQuotedBody NvimInvalidStringBody
hi link NvimInvalidSingleQuotedQuote NvimInvalidStringSpecial
hi link NvimInvalidSingleQuotedUnknownEscape NvimInternalError
hi link NvimInvalidSpacing ErrorMsg
hi link NvimInvalidString NvimInvalidValue
hi link NvimInvalidStringBody NvimStringBody
hi link NvimInvalidStringQuote NvimInvalidString
hi link NvimInvalidStringSpecial NvimStringSpecial
hi link NvimInvalidSubscript NvimInvalidParenthesis
hi link NvimInvalidSubscriptBracket NvimInvalidSubscript
hi link NvimInvalidSubscriptColon NvimInvalidSubscript
hi link NvimInvalidTernary NvimInvalidOperator
hi link NvimInvalidTernaryColon NvimInvalidTernary
hi link NvimInvalidUnaryMinus NvimInvalidUnaryOperator
hi link NvimInvalidUnaryOperator NvimInvalidOperator
hi link NvimInvalidUnaryPlus NvimInvalidUnaryOperator
hi link NvimInvalidValue NvimInvalid
hi link NvimLambda NvimParenthesis
hi link NvimList NvimContainer
hi link NvimMod NvimBinaryOperator
hi link NvimMultiplication NvimBinaryOperator
hi link NvimNestingParenthesis NvimParenthesis
hi link NvimNot NvimUnaryOperator
hi link NvimNumber Number
hi link NvimNumberPrefix Type
hi link NvimOperator Operator
hi link NvimOptionName NvimIdentifier
hi link NvimOptionScope NvimIdentifierScope
hi link NvimOptionScopeDelimiter NvimIdentifierScopeDelimiter
hi link NvimOptionSigil Type
hi link NvimOr NvimBinaryOperator
hi link NvimParenthesis Delimiter
hi link NvimPlainAssignment NvimAssignment
hi link NvimRegister SpecialChar
hi link NvimSingleQuote NvimStringQuote
hi link NvimSingleQuotedBody NvimStringBody
hi link NvimSingleQuotedQuote NvimStringSpecial
hi link NvimSingleQuotedUnknownEscape NvimInternalError
hi link NvimSpacing Normal
hi link NvimString String
hi link NvimStringBody NvimString
hi link NvimStringQuote NvimString
hi link NvimStringSpecial SpecialChar
hi link NvimSubscript NvimParenthesis
hi link NvimSubscriptBracket NvimSubscript
hi link NvimSubscriptColon NvimSubscript
hi link NvimTernary NvimOperator
hi link NvimTernaryColon NvimTernary
hi link NvimUnaryMinus NvimUnaryOperator
hi link NvimUnaryOperator NvimOperator
hi link NvimUnaryPlus NvimUnaryOperator
hi link Operator Statement
hi link PmenuExtra Pmenu
hi link PmenuExtraSel PmenuSel
hi link PmenuKind Pmenu
hi link PmenuKindSel PmenuSel
hi link PreCondit PreProc
hi link QuickFixLine Search
hi link Repeat Statement
hi link SpecialChar Special
hi link SpecialComment Special
hi link StorageClass Type
hi link String Constant
hi link Structure Type
hi link Substitute Search
hi link Tag Special
hi link Typedef Type
hi link VertSplit Normal
hi link Whitespace NonText
hi link WinBarNC WinBar
hi link WinSeparator VertSplit
