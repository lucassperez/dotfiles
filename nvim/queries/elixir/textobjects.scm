;; extends

; The upstream patterns all require _+ children inside do_block, so they miss
; empty function bodies. This adds @function.outer for the empty case.
; "do" . "end" anchors require do and end to be immediately adjacent siblings
; (no named nodes between them), which is exactly what an empty body looks like.
(call
  target: ((identifier) @_identifier
    (#any-of? @_identifier "def" "defmacro" "defmacrop" "defn" "defnp" "defp"))
  (do_block
    "do"
    .
    "end")) @function.outer
