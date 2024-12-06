// Increases indent in an algo element.
// Only place at beginning or end of lines.
#let i = { counter("_algo-indent").step() }


// Decreases indent in an algo element.
// Only place at beginning or end of lines.
#let d = {
  counter("_algo-indent").update(n => {
    assert(n - 1 >= 0, message: "dedented too much")
    n - 1
  })
}


// Displays an algorithm in a block element.
//
// Parameters:
//   body: Algorithm text.
//   title: Algorithm title.
//   Parameters: Array of parameters.
//   init: a list of dictionary containing initialization key words of
//		the form: ((key: content, val: content), (key: content, val: content), ...)
//		e.g.: 
//   line-numbers: Whether to have line numbers.
//   implicit-linebreaks: If true, line-terminating whitespaces
//     in body are assumed to be linebreaks.
//
//     Note: Using implicit-linebreaks may cause undesired behavior.
//           It doesn't play nice with special characters (+, -, ',
//           ", :, etc.) that are outside of math mode. Whitespaces
//           around these characters are treated as linebreaks. Also
//           doesn't work when mixing content mode and math mode on
//           the same line. They still work for pure content or pure
//           math mode though!
//   indent-size: Size of line indentations.
//   row-gutter: Space between lines.
//   column-gutter: Space between line numbers and text.
//   inset: Inner padding.
//   fill: Fill color.
//   stroke: Border stroke.
#let algo(
	body,
	title: none,
	parameters: (),
	init: (),
	line-numbers: true,
	implicit-linebreaks: false,
	indent-size: 20pt,
	row-gutter: 10pt,
	column-gutter: 10pt,
	inset: 10pt,
	fill: rgb(0, 104, 180).lighten(98%),
	stroke: (
		left: .5pt + rgb("A4A2A2"),
		right: 3pt + rgb("A4A2A2"),
		top: .5pt + rgb("A4A2A2"),
		bottom: 3pt + rgb("A4A2A2"),
	),
	radius: 4pt
) = {
  set par(justify: false)
  counter("_algo-indent").update(0)

  // sorts body.children such that, between portions of content,
  // indentation changes always occur before whitespace
  // makes placement of indentation commands more flexible in body
  let sorted-children = {
    let whitespaces = ()
    let indent-updates = ()
    let sorted-elems = ()

    for child in body.children {
      if (
        child == [ ]
        or child == linebreak()
        or child == parbreak()
      ) {
        whitespaces.push(child)
        sorted-elems += indent-updates
        indent-updates = ()
      } else if repr(child).starts-with(
        "update(counter: counter(\"" + "_algo-indent" + "\")"
      ) {
        indent-updates.push(child)
      } else {
        sorted-elems += indent-updates
        sorted-elems += whitespaces
        sorted-elems.push(child)
        indent-updates = ()
        whitespaces = ()
      }
    }

    sorted-elems += indent-updates
    sorted-elems += whitespaces
    sorted-elems
  }

  // concatenate consecutive non-whitespace elements
  // i.e. just combine everything that definitely aren't
  // on separate lines
  let lines-and-whitespaces = {
    let joined-children = ()
    let temp = []

    for child in sorted-children {
      if (
        child == [ ]
        or child == linebreak()
        or child == parbreak()
      ){
        if temp != [] {
          joined-children.push(temp)
          temp = []
        }

        joined-children.push(child)
      } else {
        temp += child
      }
    }

    if temp != [] {
      joined-children.push(temp)
    }

    joined-children
  }

  // filter out non-meaningful whitespace elements
  let lines-and-breaks = lines-and-whitespaces.filter(elem =>
    if implicit-linebreaks {
      elem != [ ]
    } else {
      elem != [ ] and elem != parbreak()
    }
  )

  // handling meaningful whitespace
  // make final list of empty and non-empty lines
  let display-lines = (
    if implicit-linebreaks {
      // breaks are registered as empty lines in output
      lines-and-breaks.map(elem =>
        if elem == linebreak() or elem == parbreak() {
          []
        } else {
          elem
        }
      )
    } else {
      // join consecutive lines not separated by an explicit
      // linebreak with a space
      let joined-lines = ()
      let line-parts = []
      let num-linebreaks = 0

      for (i, line) in lines-and-breaks.enumerate() {
        if line == linebreak() {
          if line-parts != [] {
            joined-lines.push(line-parts)
            line-parts = []
          }

          num-linebreaks += 1

          if num-linebreaks > 1 {
            joined-lines.push([])
          }
        } else {
          line-parts += [#line ]
          num-linebreaks = 0
        }
      }

      if line-parts != [] {
        joined-lines.push(line-parts)
      }

      joined-lines
    }
  )

  let rows = ()

  // build table input (with line numbers if specified)
  for (i, line) in display-lines.enumerate() {
    let formatted-line = {
      counter("_algo-indent").display(n =>
        pad(
          left: indent-size * n,
          line
        )
      )
    }

    if line-numbers {
      let line-number = i + 1
      rows.push([#line-number])
    }

    rows.push(formatted-line)
  }

  align(center, block(
    width: auto,
    height: auto,
    fill: fill,
    stroke: none,// stroke,
    inset: inset,
    radius: 0pt,//radius,
    outset: 0pt,
    breakable: true
  )[
    #let algo-header = {
      set align(left)

      // ALGORITHM TITLE 
      if title != none {
        set text(1.1em)

        if type(title) == str {
          underline(smallcaps(title))
        } else {
          title
        }

        if parameters.len() == 0 {
          $()$
        }
      }

      // ALGORITHM PARAMS
      if parameters != () {
        set text(1em)

        $($

        for (i, param) in parameters.enumerate() {
          if type(param) == str {
            math.italic(param)
          } else {
            param
          }

          if i < parameters.len() - 1 {
            [, ]
          }
        }

        $)$
      }

      if title != none or parameters != () {
        [:]
      }
      
      // INITIALIZATION
      if init != () {
        [\ ]
        for (i, p) in init.enumerate() {
          grid(
            columns: (auto, 1fr, 10fr),
            gutter: 1em,
            [$quad$],
            [*#p.key:*],
            grid(
              columns: 1,
              gutter: .5em,
              ..p.val
            )
          )
        }
        [\ ]
      }
    }

    #algo-header
    #v(weak: true, row-gutter)

    #align(left, table(
      columns: if line-numbers {2} else {1},
      column-gutter: column-gutter,
      row-gutter: row-gutter,
      align:
        if line-numbers {
          (x, _) => (right, left).at(x)
        } else {
          left
        }
      ,
      stroke: none,
      inset: 0pt,
      ..rows
    ))
  ])
}


// Displays code in a block element.
// Credit to @Vinaigrette#5555 on Discord.
//
// Parameters:
//   body: Raw text.
//   line-numbers. Whether to have line numbers.
//   row-gutter: Space between lines.
//   column-gutter: Space between line numbers and text.
//   inset: Inner padding.
//   fill: Fill color.
//   stroke: Border stroke.
#let code(
  body,
  line-numbers: true,
  row-gutter: 10pt,
  column-gutter: 10pt,
  inset: 10pt,
  fill: rgb("#e3eef9"),
  stroke: 1pt + rgb("#083573")
) = {
  set par(justify: false)
  let content = ()
  let i = 1

  for item in body.children {
    if item.func() == raw {
      for line in item.text.split("\n") {
        if line-numbers {
          content.push(str(i))
        }

        content.push(raw(line, lang: item.lang))
        i += 1
      }
    }
  }

	stack(
		dir: ltr,
		spacing: 1mm,
		if line-numbers {
			box(
				inset: 1mm,
				width: auto
			)[
				#align(
					right, 
					stack(
						dir: ttb,
						spacing: 1mm,
						..content.filter(x => type(x) == str).map(x => raw(x))
					)
				)
			]
		} else {
			box()[]
		},
		block(
			inset: 1mm,
			fill: fill,
			width: auto
		)[
			#align(
				left, 
				stack(
					dir: ttb,
					spacing: 1mm,
					..content.filter(x => type(x) != str)
				)
			)
		]
	)
}
