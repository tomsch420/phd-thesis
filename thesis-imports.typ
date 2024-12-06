// use this file to import templates or functions from other packages. This file is then the only one to be imported into the local files
// Alays have qoutes as blocks
#set quote(block: true) 

// import diss-template and functions
#import "@iai-templates/iai-thesis:0.0.1": iai-diss, iai-titlepage, dissts, dissfonts, disscolors, numbername, stickybox_, chapterformat, subfigure, imgwrapper, appendices, figure_, s_usedkeys, usedkeys, parse-bib, preprocess_listings

#import "@iai-templates/ubcd:0.0.0": ubdefs

// import other local packages
#import "@mareikep/glossarium:0.5.1": make-glossary, register-glossary, print-glossary, gls, glspl, tabular-print-gloss, tabular-print-reference, tabular-print-title, tabular-print-glossary, create-entry

// import public packages
#import "@preview/tablex:0.0.5": tablex, rowspanx, cellx

// location: ~/.local/share/typst/packages/{namespace}/{name}-{version}
// with {namespace} == mareikep
#let acro = "Acronyms"
#let symbl = "Symbols"
#let gloss = "Glossary"
#let lk = "Links"

#import "@preview/ctheorems:1.1.2": *



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
#import "@mareikep/algorithms:0.0.1": *

