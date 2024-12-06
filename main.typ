#set heading(numbering: "1.")
#import "template.typ": *

#let partpage(pgnum) = {
  return page(align(right, text(5em, [PART #numbering("I", pgnum)])))
}
#set page(margin: (inside: 2.5cm, outside: 2cm, y: 1.75cm))
#outline(depth: 2)
#pagebreak()
#outline(
  title: [List of Figures],
  target: figure.where(kind: image),
)
#pagebreak()
#outline(
  title: [List of Tables],
  target: figure.where(kind: table),
)
#pagebreak()

#set page(numbering: "1")
#include "introduction.typ"
#pagebreak()
// TODO FLOWCHART
#include "contributions.typ"
#pagebreak()
#include "cognitive_architectures.typ"
#pagebreak()
#include "random_events.typ"
#pagebreak()
#include "probability_theory.typ"
#pagebreak()
#include "probabilistic_models.typ"
#pagebreak()
#include "memory.typ"
#pagebreak()
#include "probabilistic_actions.typ"
#pagebreak()
#include "conclusion.typ"
#pagebreak()
#include "glossary.typ"
#pagebreak()


#bibliography("references.bib")