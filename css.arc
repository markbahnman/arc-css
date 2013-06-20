(= cssmeths* (table))

(mac cssmeth args
  `(cssmeths* (list ,@args)))

(mac cssproperty (prop type)
  `(= (cssmeths* (list ',prop)) ,type))

(def csscolor (key val)
  (w/uniq gv
    `(whenlet ,gv ,val
      (pr ,(string " " key ":#" (hexrep ,gv))))))

(def cssstring (key val)
  `(if ,val (pr ,(+ " " key ":\"") ,val "\";")))

(def cssnum (key val)
  `(if ,val (pr ,(string key ":") ,val ";")))
()
(def csssym (key val)
  `(pr ,(+ " " key ":") ,val ";"))

(cssproperty color csscolor)
(cssproperty z-index cssnum)
(cssproperty id cssnum)

(mac css (sel props . nest)
  `(do ,(pr (string sel "{"))
    ,(gen-css-properties props)
    ,(each g nest
      (gen-nested-css g sel props)))
  )


(def gen-nested-css (rest sel prev)
  `(css ,(string (if sel sel) " " (car rest))
          ,(join prev (cadr rest))
          ,(if (cddr rest) (cddr rest))))

(def gen-css-properties (plist)
  (print-properties
    (parse-properties plist)))

(def print-properties (props)
  (if (all [isa _ 'string] props)
    `(pr ,(apply string props))
    (no props)
    `(pr "}")
    `(do ,@(map (fn (prop)
                  (if (isa prop 'string)
                        `(pr ,prop)
                        prop))
                props))))

(def parse-properties (plist)
  (if (no plist)
    '("}")
    (with (prop (car plist) val (cadr plist) rest (cddr plist))
      (let meth (cssmeth prop)
        (if meth
          (if val
            (cons (meth prop val)
              (parse-properties rest)
            ))
        (do
          (pr "/* ignoring " prop  ": " val " */")
          (parse-properties rest)))))))