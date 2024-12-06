#import "@preview/ctheorems:1.1.2": *
#show: thmrules

#set text(font: "Linux Libertine", lang: "en")
#set heading(numbering: "1.1.")

#let definition = thmbox(
 "definition", // identifier
 "Definition", // head
 fill: rgb("#e8e8f8")
)

#let theorem = thmbox(
 "theorem", // identifier
 "Theorem", // head
 fill: rgb("#e8e8f8")
)

