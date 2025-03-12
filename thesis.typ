#import "thesis-imports.typ": *
#import "appendix.typ": app

#let bib = bibliography(
	("references.bib"), 
	title: none, 
	style: "chicago-author-date"
)

#let listings = preprocess_listings(
	(
    Acronyms: yaml("acronyms.yaml"),
    Glossary: yaml("glossary.yaml"),
    Links: (),
    Symbols: yaml("symbols.yaml")
	)
)

// load data from YAML file (also used for compiling cover)
#let docdata = yaml("document_data.yaml")

#let acknowledgments = ( 
	credits: [ 
		#v(6em) 
		Many thanks go to...
		#lorem(400)
	],
	funding: [
		This work has received funding from the Collaborative Research 
		Center (CRC) SFBXXXX by the German Research Foundation 
		(Deutsche Forschungsgemeinschaft (DFG)) (project number 
		123456789), from the European Union Seventh Framework Programme 
		(FP7) projects XXXXXXX (grant number 123456) and YYYYYY (grant 
		number 987654) and from Research Grants DFG Programme ZZZZ 
		(project number 987654321).
	]
)

#let abstract_en = [
#v(6em) 
This is my abstract...
#lorem(400)

]

#let abstract_ger = [
#v(6em) 
Dies ist meine Zusammenfassung...
#lorem(400)
 
]

// generate titlepage that will be passed to thesis template
#let titlepage = iai-titlepage.with(
		// the title of the thesis
		title: docdata.document.title,

		// the subtitle of the thesis
		subtitle: docdata.document.subtitle,

		// the author of the thesis.
		author: docdata.document.author,
		
		// the academic title to be acquired
		academic_title: "Doktors der Ingenieurwissenschaften (Dr.-Ing.)",

		// an array of committee members. for each member you can specify a 
		// name, affiliation and role. Everything but the name is optional.
		committee: (
			docdata.committee.supervisor1, 
			docdata.committee.supervisor2
		),

		// the submission date
		date_submission: datetime(..docdata.submission.date),
		
		// the defence date
		date_accept: none,

		date_defense: datetime(..docdata.defense.date),

		// the article's paper size. also affects the margins
		paper-size: "a4",
		
		lang: "de"
	)

// pass document info to thesis template
#show: iai-diss.with(
	// can be none or content
	titlepage: titlepage,

	title: docdata.document.title,

	subtitle: docdata.document.subtitle,

	author: docdata.document.author,

	// the committee members
	committee: (
		docdata.committee.supervisor1, 
		docdata.committee.supervisor2
	),

	// the english abstrace (optional)
	abstract_en: abstract_en,

	// the german abstract (optional)
	abstract_ger: [
		#set text(lang: "de")
		#abstract_ger
	],

	acknowledgments: acknowledgments,
  
	date_submission: datetime(..docdata.submission.date),

	listings: listings,

	bibliography: bib, // this has to be the content of a bibliography() call, as passing bib files would not work,

	appendix: app, // the content of the appendix file is passed as content in a variable because it is styled differently

	lang_title: "de",
	lang: "en",

	printversion: false 
)

// ---------------------------------------------------------------------

#include "chapters/introduction.typ"
//#include "chapters/contributions.typ"
//#include "chapters/cognitive_architectures.typ"
#include "chapters/memory.typ"
#include "chapters/random_events.typ"
#include "chapters/probability_theory.typ"
#include "chapters/probabilistic_models.typ"
// #include "chapters/probabilistic_actions.typ"
// #include "chapters/conclusion.typ"



// ---------------------------------------------------------------------
