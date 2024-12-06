#import "@preview/glossarium:0.4.1": make-glossary, print-glossary, gls, glspl 

#show: make-glossary


#print-glossary(
    (
    (key: "orm", 
    short: "ORM",   
    long: "Object Relational Mapping",
    description: 
    [Object–relational mapping in computer science is a programming technique for converting data between a relational database and the heap of an object-oriented programming language.  #link("https://en.wikipedia.org/wiki/Object%E2%80%93relational_mapping#:~:text=Object%E2%80%93relational%20mapping%20(ORM%2C,an%20object%2Doriented%20programming%20language.")[From Wikipedia"].]),
    
    (key: "pgm",
    short: "PGM",
    long: "Probabilistic Graphical Model",
    description: 
    [A probabilistic graphical model (PGM) or structured probabilistic model is a probabilistic model for which a graph expresses the conditional dependence structure between random variables. They are commonly used in probability theory, statistics—particularly Bayesian statistics—and machine learning. #link("https://en.wikipedia.org/wiki/Graphical_model")[From Wikipedia].]
)), show-all: true, disable-back-references: true,)