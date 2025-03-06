// use this file to import templates or functions from other packages. This file is then the only one to be imported into the local files
// Alays have qoutes as blocks
#set quote(block: true) 


#import "@iai-templates/ubcd:0.0.0": ubdefs

#import "@iai-templates/iai-thesis:0.0.2": blockquote, sectext, pnum, iai-diss, iai-titlepage, dissts, dissfonts, disscolors, numbername, chapterformat, subfigure, imgwrapper, quote, appendices, figure_, lorem, s_usedkeys, usedkeys, parse-bib, cite, preprocess_listings


// import local packages
#import "@mareikep/algorithms:0.0.2": algo, i, d
#import "@mareikep/boxes:0.0.3": checkicon, colorbox, qm, em, frame, iconbox, titledbox, definition, admonition, info, memo, concl, quest, todo, custombox, qrbox
#import "@mareikep/hint:0.0.2": hint, warning-hint, default-hint, sticky-hint
#import "@mareikep/listings:0.1.2": load-entries, create-entry, show-entry, print-listing, gls, glspl, print-volatile-listings
// #import "@mareikep/glossarium:0.5.1": gls, glspl, create-entry

// import public packages
#import "@preview/tablex:0.0.9": tablex, rowspanx, colspanx, cellx, hlinex, vlinex
#import "@preview/cetz:0.3.2": canvas, draw, tree
#import "@preview/fletcher:0.5.5" as fletcher: diagram, node, edge
#import "@preview/ctheorems:1.1.3": *
#let acro = "Acronyms"
#let symbl = "Symbols"
#let gloss = "Glossary"
#let lk = "Links"


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

#let proof = thmproof("proof", "Proof")
