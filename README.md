arc-css
=======

Intended to be a LESS/SASS-like Library for generating css from arc.

## Example Usage

```
(css "#foo"
    (id 5)
        (".bar"
            (z-index 2)))
```

```
#foo {id: 5;}
#foo .bar {id: 5; z-index: 2;}
```