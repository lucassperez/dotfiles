;; extends

((call
   target: (identifier) @elixirPrivateDefine
   (#any-of? @elixirPrivateDefine "defp" "defguardp" "defmacrop" "defrecordp")))
