
#import "../thesis-imports.typ": *


= Probability Theory
<sec:probability_theory>

This section on probability theory establishes a strong foundation for this thesis by highlighting its significance in enabling cognitive robots to reason, make decisions, and operate effectively in the real world. Convincing arguments for the study of probability theory in robotics are:

- *Core Principle for Reasoning Under Uncertainty* A fundamental principle of cognitive robotics is the ability for robots to reason and act effectively even in situations with uncertainty. The real world is inherently stochastic, meaning outcomes are not always guaranteed and can vary depending on various factors. Probability theory provides a robust mathematical framework for reasoning about these uncertainties.

- *Enabling Informed Decisions in Complex Environments* By incorporating probability distributions, cognitive robots can quantify the likelihood of different outcomes arising from their actions or belief state, enabling them to make informed decisions in complex and unpredictable environments. For instance, a robot picking up an object can leverage probability distributions to account for uncertainties and in inaccuracies or potential variations in the environment itself. By reasoning about these probabilities, the robot can choose the safest and most efficient way of picking the object.

- *Strong Foundation for Further Advancements* Probability theory serves as a cornerstone for many advanced techniques employed in cognitive robotics and artificial intelligence, including planning under uncertainty, Bayesian filtering for sensor fusion, and reinforcement learning algorithms. 

In probability theory, a sigma algebra (as described in @sec:sigma_algebra) allows the specification of probabilities for all possible events. If the probability of every elementary event (an event that cannot be further decomposed) within the sigma algebra is known, the probability of any conceivable event constructed from these elementary events can be determined.

In #ref(<sec:product-sigma-algebra>), the concept of a product sigma algebra was introduced. This construction allows to define a sigma algebra on the product space of multiple measurable spaces. 
//Throughout the rest of this thesis, whenever a sigma-algebra is referred to, I will be specifically referring to this product sigma algebra unless states otherwise.

== Probability Measure
<sec:probability_measure>

#definition([Probability Measure @resnick2013probability])[

Let $(E, Im)$ be a measurable space (see #ref(<def:sigma_algebra>)).
A non-negative, real function $P: Im -> RR_(0,+)$ is called a measure if it satisfies the following properties.

+ $P(emptyset) = 0$
+ For any countable sequence ${A_i in Im }_(i=1,...,)$ of pairwise disjoint sets $A_i inter A_j = emptyset$ if $i!=j, P$ satisfies countable additivity ($sigma$-additivity):
  $
  P(union.big^infinity_(i=1) A_i) = sum^infinity_(i=1) P(A_i)
  $
+ $P(A union B) = P(A) + P(B) - P(A,B)$
+ $P(E) = 1$
The triple $(E, Im, P)$ is called a probability space.
] <def:probability_measure>

A probability measure assigns a numerical value between 0 and 1 to each event within a sigma algebra. This framework also proves useful when considering unions of events. For disjoint events, sigma additivity guarantees that the probability of the union is equivalent to the sum of the individual probabilities of each event. This property stems from the fact that disjoint events contribute non-overlapping elements to the union.
Furthermore, sigma additivity is one of the reason for the focus of @sec:sigma_algebra on representing composite sets as disjoint unions of simple sets. 

However, for events that intersect (have some overlap), a straightforward summation of their probabilities leads to overcounting. The elements constituting the intersection are included in the probability calculations for both individual events. Sigma-additivity addresses this by ensuring that the probability of the intersection is subtracted from the sum of the individual probabilities, effectively compensating for the double counting.

This characteristic of sigma-additivity necessitates the construction of probability measures on sigma algebras. Sigma algebras, by definition, include all possible unions and intersections of measurable sets (events), allowing for the proper application of sigma-additivity when calculating probabilities of complex events.

Intuitively, probabilities can be conceptualized as the "size" of sets within sigma algebra. This analogy draws parallels between probability theory and geometric measure theory, where the size of a shape corresponds to its area or volume. However, a key distinction exists: probabilities are inherently bounded by unity (Axiom 4). Unlike geometric measures, probabilities never exceed this limit.

Stemming from the definition of a probability measure, a critical theorem can be established.

#theorem([Sum Rule @kolmogoroff1933grundbegriffe])[

From $A + not A = E$ it follows
$
P(E) &= 1 \
P(A) + P(not A) &= 1 \
P(A) &= 1 - P(not A).
$
From $A = A inter (B union not B)$, using the notation $P(A, B) = P(A sect B)$ for the *joint probability* of $A$ and $B$ the sum rule is derived as 
$
P(A) = P(A, B) + P(A, not B).
$]

The sum rule applies when we want to determine the probability of event A occurring, but we only have information about the combined probability of event A happening along with another event B. In such scenarios, we might also have information about the probability of event B occurring by itself (denoted B).

Marginalization refers to the process of summing probabilities across different states of another event.

== Conditional Probability

#definition([Conditional Probability and Product Rule @kolmogoroff1933grundbegriffe])[

If $P(A) > 0$, the quotient
$
P(B | A ) = P(A,B) / P(A)
$
is called the *conditional probability* of an event $B$ given an event $A$.  It immediately gives the *product rule*
$
P(A,B) = P(A | B) dot P(B) = P(B | A) dot P(A).
$
Note that for a fixed $B,$ the triple $(E, Im, P(dot | B))$ is a probability space as well.] <def:conditional_probability>

Todd Kemp wonderfully explained the concept of conditional probability in his lecture about probability theory. @kemp2021youtube
// Instead of explaining this concept in my own words, I refer to Todd Kemps phrasing since there is nothing I could explain any better about it.

#quote([#cite(<kemp2021youtube>, form: "prose")],[
	We often think of conditional probability intuitively in terms of a two-stage experiment. In the first stage of the experiment, we see whether one particular event $A$ has occurred or not. If it has it may influence whether a second event $B$, which we’re going to measure in a second stage, will occur or not. Therefore, we may want to update our information on probabilities of the later events given information about whether the earlier event has occurred or not. In this language we’ll refer to the original probability measure $P(B)$ as the prior probability of an event $B$ and after we observe that event $A$ has occurred we refer to the new updated conditional probability as the posterior probability of that same event $B$. In more practical applications $A$ is referenced as the evidence since it is an event that evidently happened and $B$ is the query, since it is the event of interest. There are two very elementary but extraordinarily important results that come from that line of thinking the so-called law of total probability and most critically, Bayes theorem.]
)<qoute:conditional_probability_kemp>

#theorem([Law of Total Probability @kolmogoroff1933grundbegriffe])[

Let $A_1 + A_2 + ... + A_n = E$ and $A_i inter A_j = emptyset $ if $i != j$ , i. e. be a partioning of the elementary events. Then for any $X in Im$,
$
P(X) = sum_(i=1)^n P(X | A_i) P(A_i).
$
]<theo:law_of_total_probability>

#proof([of @theo:law_of_total_probability])[
Since 
$
X = E inter X = union.big_(i=1)^n (A_i inter X),
$
it is obtained that
$
P(X) =  sum_(i=1)^n  P(A_i, X) = sum_(i=1)^n P(X | A_i) P(A_i).
$
]

Bayes' theorem provides a framework for updating prior probabilities in light of new evidence. It operates by reversing the conditioning process, allowing for the calculation of the posterior probability of an event (the probability of the event given new evidence) based on the prior probability of the event (the probability of the event before considering new evidence) and the likelihood of the evidence given the event. Notably, Bayes' theorem can be derived entirely from the axioms of probability theory, solidifying its foundation within the established theoretical framework.
#theorem([Bayes Theorem @kolmogoroff1933grundbegriffe])[
Let $A_1 + A_2 + ... + A_n = E$ and $A_i inter A_j = emptyset $ if $i != j$ , i. e. be a partioning of the elementary events. Then for any $X in Im$,
$
P(A_i | X) = (P(X | A_i) P(A_i)) / (sum_(j=1)^n P(X | A_j) P(A_j)).
$]

== Independence

Independence plays a critical role in understanding the relationships between events.  Two events are considered independent if the occurrence of one event does not influence the probability of the other occurring.

The concept of independence simplifies calculations involving multiple events.  If events are independent, we can directly multiply their individual probabilities to determine the probability of their combined occurrence.  This concept finds numerous applications in various fields, including statistics, machine learning, and engineering and is one of the key tools to enable efficient, probabilistic reasoning.

#definition([Independence @kolmogoroff1933grundbegriffe])[
The event $A$ is independent of the event $B$ if 
$
P(A | B) = P(A)
$
or equivalently
$
P(A, B) = P(A) P(B).
$
Notation: $A tack.t.double B$. Information about $B$ does not give information about $A$ and vice versa.
]<def:independence>

One goal of probabilistic machine learning is efficiently representing probability distributions. It's often assumed that distributions over single (univariate) random variables can be represented more effectively compared to complex relationships between multiple variables. Therefore, the independence operator in this context is primarily applied to entire variables. By assuming independence between certain variables, machine learning algorithms can make simplifying assumptions that allow for more efficient calculations and model training.

The definition of independence can be expanded to conditional independence.

#definition([Conditional Independence @kolmogoroff1933grundbegriffe])[
Two variables (events) $A$ and $B$ are conditionally independent given a variable (event) $C$ if and only if their conditional distribution factorizes,
$
P(A, B | C) = P(A | C) dot P(B | C).
$
In that case we have $P(A | B, C) = P(A | C)$, i. e. in the light of information $C$, $B$ provides no further information about $A$.
Notation: $A tack.t.double B | C$.
]<def:conditional_independence>

Conditional independence is the key tool for tractable probabilistic modelling. In //@sec:probabilistic_models
this thesis discusses different approaches to represent complex probability distributions. In the entire chapter the thesis explains that every model has some form of conditional independence in it. 

== From Probability Measures to Representation

Thus far, we have explored the concept of probability measures, equipping us with a framework to assign numerical values between 0 and 1 to events within sigma algebra. This powerful tool allows us to reason about the likelihood of various outcomes in a random experiment. However, the question arises: how can we effectively represent and analyze these probabilities, especially when dealing with complex experiments that may have countless potential outcomes?

// TODO REWRITE

This section presents important univariate probability distributions. These distributions serve as a formal language for describing the probabilities associated with all possible outcomes of a random experiment with one variable. 


This shift from probability measures to probability distributions offers a more granular understanding of the probabilistic landscape and introduces the first building blocks for expressing the belief of an agent in a probabilistic meaningful way. 

//Here, we'll specifically focus on discrete probability distributions, applicable to scenarios where the possible outcomes are distinct and countable.
// By employing various representations, such as the probability mass function (PMF) and probability tables, we can visualize and analyze the likelihood of each individual outcome within the experiment.

In #ref(<def:probability_measure>) the function $P$ was defined to map from the set of random events to real, non-negative numbers. However, it is sufficient to only map the elementary events to said numbers. The definitions and theorems discussed in #ref(<sec:probability_measure>) consequently yield the probabilities for the remaining random events due to sigma additivity.

=== Discrete Distributions

As described in #ref(<sec:variables>) variables divide in two major categories, the continuous and the discrete. The following section starts by introducing the most common representation of a discrete variable, the probability table.

Consider a robotic experiment that has either a successful or unsuccessful outcome. The space of elementary event is hence described as $"Status"  in \{"Failure", "Success" \}$. We can now describe $P$ using the top left table in #ref(<tab:combinatoric_explosion>). 
Furthermore, consider the variables $ "Object Type" in \{ "Bowl", "Cup", "Knife", "Spoon" \}$ and $"Robot Type" in \{ "HSR", "PR2" "Tiago" \}$. We can describe the distribution of all events from the Cartesian product $"Object Type" times "Status"$, in short 
$P("Object Type", "Status")$ in the lower left table and $P( "Object Type", "Robot Type", "Status")$ in the right table in @tab:combinatoric_explosion.
Note that this construction follows the construction of the product algebra (@def:product_sigma_algebra).
//TODO and the other variables?

#figure(caption: [Example of a joint probability table over three variables, namely object type, robot type and task status, in a pick up task. This table demonstrates the exponential growth in the number of parameters that is needed to represent a full joint probability table. In the left table only two variables are involved and $4 dot 2 = 8$ probabilities are needed. In the right table a third variable is involved and the number of parameters increased to $4 dot 3 dot 2 = 24$ probabilities.])[
  #columns(2, gutter: 2mm)[
    #table(
      columns: (auto, auto),
      inset: 10pt,
      align: horizon, 
      table.header([Status], [P]), 
      [Failure], [$0.1$],
      [Success], [$0.9$])
      #table(
        columns: (auto, auto, auto),
        inset: 5pt,
        align: horizon, 
        table.header([Object Type], [Status], [P]), 
        [Bowl], [Failure], [$0.23$],
        [Bowl], [Success], [$0.26$],
        [Cup], [Failure], [$0.0$],
        [Cup], [Success], [$0.08$],
        [Knife], [Failure], [$0.07$],
        [Knife], [Success], [$0.09$],
        [Spoon], [Failure], [$0.06$],
        [Spoon], [Success], [$0.2$],)
        #colbreak()
        #table(
            columns: (auto, auto, auto, auto),
            inset: 5pt,
            align: horizon, 
            table.header([Object Type], [Robot Type], [Status], [P]), 
        [Bowl], [HSR], [Failure], [$0.05$],
        [Bowl], [HSR], [Success], [$0.03$],
        [Bowl], [PR2], [Failure], [$0.07$],
        [Bowl], [PR2], [Success], [$0.03$],
        [Bowl], [Tiago], [Failure], [$0.06$],
        [Bowl], [Tiago], [Success], [$0.01$],
        [Cup], [HSR], [Failure], [$0.07$],
        [Cup], [HSR], [Success], [$0.02$],
        [Cup], [PR2], [Failure], [$0.02$],
        [Cup], [PR2], [Success], [$0.05$],
        [Cup], [Tiago], [Failure], [$0.03$],
        [Cup], [Tiago], [Success], [$0.01$],
        [Knife], [HSR], [Failure], [$0.02$],
        [Knife], [HSR], [Success], [$0.06$],
        [Knife], [PR2], [Failure], [$0.03$],
        [Knife], [PR2], [Success], [$0.05$],
        [Knife], [Tiago], [Failure], [$0.04$],
        [Knife], [Tiago], [Success], [$0.05$],
        [Spoon], [HSR], [Failure], [$0.08$],
        [Spoon], [HSR], [Success], [$0.02$],
        [Spoon], [PR2], [Failure], [$0.04$],
        [Spoon], [PR2], [Success], [$0.07$],
        [Spoon], [Tiago], [Failure], [$0.07$],
        [Spoon], [Tiago], [Success], [$0.01$],)]
      ]<tab:combinatoric_explosion>
      
As discussed in #ref(<sec:product-sigma-algebra>) the size of the set of elementary events increases exponential with the number of variables involved. Hence, for small sets of variables, probability tables are useful and very accurate. 

Real world scenarios however often involve interactions between tens to hundreds of variables.
Representing $P$ as a full joint probability table is therefore infeasible.
#ref(<tab:combinatoric_explosion>) illustrates the combinatorial explosion that is the source this problem.

=== Continuous Distributions

Having explored discrete probability tables, where outcomes are distinct and countable, this thesis now shifts the focus to continuous distributions. These distributions model scenarios where the possible outcomes can take on any value within a specific continuous interval. Consider measuring the angle of a robotic joint. Unlike _Status_ which has a finite and countable set of outcomes, angles can theoretically fall anywhere on a continuous spectrum.
Generally speaking, unlike discrete distributions where probabilities are assigned to individual outcomes, continuous distributions deal with probabilities associated with ranges of values, i. e. elements of the Borel sigma algebra (recall @def:interval). 
A probability density function (PDF) solves this problem by mapping every value from the continuous domain to a likelihood of said value. Note, that the PDF doesn't directly provide the probability of a specific outcome, since there are infinitely many possibilities in a continuous range. 
The PDF is a non-negative function that takes higher values in regions where the corresponding outcome is considered more likely. Conversely, it takes lower values in regions where the outcome is deemed less probable.

//Instead, it describes the relative likelihood of an outcome falling within a certain interval.

#definition([Probability Density Function (PDF) @kolmogoroff1933grundbegriffe])[

Let $Beta$ be the Borel $sigma$ algebra on $RR^d$. A probability measure $P$ on $(RR^d, Beta)$ has a density $p$ if $p$ is a non-negative (Borel) measurable function on $RR^d$ satisfying for all $B in Beta$
$
P(B) = integral_B p(x) d x =: integral_B p(x_1, ..., x_d) d x_1... d x_d .
$]<def:pdf>

The integral of the PDF over a specific interval corresponds to the cumulative distribution function (CDF). The CDF serves as the primary tool for calculating the probability of an event occurring within that designated interval.

#definition([Cumulative Distribution Function (CDF) @kolmogoroff1933grundbegriffe])[

For probability measures $P$ on $(RR^d, Beta)$, the cumulative distribution function is the function
$
F(x) = P(product_(i=1)^d (X_i < x_i)).
$
If $F$ is sufficient differentiable, then $P$ has the density given by
$
p(x) = (partial^d F) / (partial x_1,..., partial x_d).
$
] <def:cdf>

The CDF allows to determine the probability that multiple random variables, denoted by the vector $bold(x) = (x_1, ..., x_d)$ will simultaneously satisfy a set of conditions. Specifically, the CDF, denoted by $F(bold(x))$, calculates the probability that each variable $x_i$ within the vector $bold(x)$ is less than its corresponding threshold value.
For instance, evaluating $F(1,3)$ corresponds to calculating the probability that $x_1 < 1 and x_2 < 3$.

From @def:cdf it is already visible that integration is the most important tool for probabilistic inference. 

Having established the fundamental concepts of continuous probability distributions, this chapter now goes into specific examples that hold significant importance for this thesis. Three such prominent distributions are the uniform distribution, the normal distribution (also known as the Gaussian distribution) and the Dirac delta distribution.
These distributions offer versatile tools for modeling a wide range of real-world phenomena.

=== Uniform Distribution

The uniform distribution is the simplest distribution. It models scenarios where all outcomes within a specified range are equally probable. This simple characteristic enables extremely fast reasoning for this type of distribution. @sec:queries discusses this further.

Furthermore, The uniform distribution can serve as a valuable baseline model when analyzing continuous data.  By comparing the actual data distribution to a uniform distribution, one can identify deviations and assess the presence of non-uniform patterns. This comparison can provide valuable insights into the underlying characteristics of the data. //@sec:nyga_distribution_learning
Section TODO delves deeper into the intricacies of this benefit.

The uniform distribution is defined in @def:continuous-uniform-distribution. A graphical illustration of the uniform distribution is provided in @fig:uniform_pdf.

#definition([Continuous Uniform Distribution])[
Let $I$ be a simple interval from $a$ to $b$. The PDF $f$ of the continuous uniform distribution over $I$ is given by
$
f(x) = cases(
  1 / (b-a) "if" x in I,
  0 "else").
$

The CDF $F$ is given by 
$
F(x) = min(max((x-a)/(b-a), 0), 1).
$

Notation: The uniform distribution is denoted as $U(I)$.

The term standard continuous uniform distribution refers to $U([0,1])$.]
<def:continuous-uniform-distribution>

On a site note, the uniform distribution also exists for a discrete domain. In that context, it refers a probability table where all probabilities are equal. Generally speaking, uniform measures can be defined over finite sets.

#definition([Uniform Measure on a Set])[
Let $S$ be finite a set. The uniform measure on $S$ assigns a probability for every $s in S$ by 
$
U(s) = 1 / (|S|).
$

]<def:set-uniform-distribution>

// TODO update figure with CDF
#figure(
  image("../images/standard_uniform_pdf.svg"),
  caption: [Probability density function of the standard uniform distribution.])
  <fig:uniform_pdf>

// TODO uniform distribution on funnier set

=== Gaussian Distribution

The Gaussian distribution (also known as the normal distribution) is the most prominent distribution used in all of machine learning.
One of the reasons for that is that the Gaussian distribution appears often in natural phenomena. 
From heights and weights in a population to variations in temperature and measurement errors, the bell-shaped curve of the normal distribution, as depicted in @fig:gaussian_pdf, frequently emerges when modeling continuous variables. 
The central limit theorem, which connects this observation to math, proves that any sum of independent continuous random variables converges to a normal distribution. @fischer2011history
As natural processes include many unknown (hidden) variables and one typically measures some variation of the mean of a process, these measurements tend to be normally distributed.

Furthermore, the Gaussian distribution has nice mathematical properties. First off, the sum of two independent normal distributed random variables is again a normal distributed random variable. Second, the product of two gaussian PDFs is again a Gaussian PDF.

Lastly, the Gaussian distribution requires only few parameters (mean and standard deviation) to characterize the entire distribution. Hence, it is very efficient at describing complex behavior.

#definition([Gaussian Distribution (Normal Distribution)])[
The PDF $f$ of the Gaussian distribution with mean $mu$ and standard deviation $sigma$ is given by
$
f(x) = 1/(sigma sqrt(2 pi)) exp(-1/2 ((x- mu) / sigma )^2).
$

The CDF $F$ is given by

$
F(x) = Phi((x-mu)/ sigma) = 1/2 [1 + "erf"((x- mu) / (sigma sqrt(2)))].
$

Notation: The normal distribution is denoted as $N(mu, sigma^2)$.

The term standard normal distribution refers to $N(0, 1)$.
]
<def:gaussian_pdf>

In common machine learning applications it is often argued that the Gaussian distribution should be used due to its mathematical soundness and the central limit theorem. However, as will be explained in #ref(<sec:queries>), there are certain problems that arise when combining this distribution with logical restrictions. Also, it has to be taken into account that despite its dominance, the normal distribution is not a universal fit for all data.  


// TODO include CDF
#figure(
  image("../images/standard_gaussian_pdf.svg"),
  caption: [Probability density function of the standard Gaussian distribution.])
  <fig:gaussian_pdf>


=== Dirac Delta Distribution

Continuous probability distributions model phenomena where outcomes can theoretically fall anywhere on a specific spectrum, with varying degrees of likelihood. However, certain situations arise where an event, initially considered random, exhibits absolute certainty. In these instances, the Dirac delta function serves as mathematical representation of that belief. 

// TODO less succy definition
#definition([Dirac Delta Distribution (Delta Function)])[
The PDF of the Dirac Delta Distribution is
$
p(x) = cases(infinity "if" x = a, 0 "else")
$
Notation: The Dirac Delta Distribution is denoted as $delta (a)$ where $a$ describes the location of the impulse.] <def:dirac-pdf>

This ability to eliminate uncertainty and pinpoint specific outcomes within a continuous domain makes the Dirac delta function a valuable tool in cognitive robotics. Consider a variable that represents the measurement of a sensor. When an agent reasons about the future, it may represent this measurement as random variable with a Gaussian PDF for example. As soon as this sensor gets measured, the belief about it is not random anymore, it's a fact.
The Dirac delta distribution represents such a fact while still allowing probabilistic inference.
The Dirac delta function is visualized in #ref(<fig:dirac_delta_pdf>).
In #ref(<sec:conditional-distributions>) we see the importance of the delta function for this thesis.

// TODO update plot
#figure(
  image("../images/dirac_delta_pdf.svg"),
  caption: [Probability density function of the dirac delta distribution.])
  <fig:dirac_delta_pdf>


== Maximum Likelihood Principle
<sec:maximum_likelihood_principle>

A common machine learning workflow consists of defining a model and then estimating the parameters of the model. The model is a function $f(x)$. For the evaluation of $f$ the function uses other parameters. For instance, the equation of a line $f(x) = m x + b$ uses the parameters $m$ and $b$.
The parameter estimation is usually done from data.

$
underbrace(f(x), "Model of x") = underbrace(m, "Parameter") dot  underbrace(x, "Variable") + underbrace(b, "Parameter")
$

The *maximum likelihood estimation* (MLE) refers to the mathematical process of determining the parameters of a probabilistic model. 
The goal of MLE is to select the parameters that most likely generate a set of observations (the data). In the context of probabilistic machine learning, these are the variables in the PDF of a probability distribution. For the uniform distribution (@def:continuous-uniform-distribution) these parameters are $a$ and $b$. For the Gaussian distribution, the parameters are $mu$ and $sigma$. 
Generally, the parameters are described as a vector $theta$ which holds all parameters.

#definition([Maximum Likelihood Estimate])[
$L(bold(theta))$ is called the likelihood function. The goal is to determine
$
hat(theta)_("MLE") = arg max_(theta in Theta) L(theta) =  arg max_(theta in Theta) product_(i=1)^N p(D_i | theta),
$
which is called the *Maximum Likelihood Estimate* (MLE) and $N$ being the number of observations.]<def:mle>

// TODO weighted log likelihood

In the context of maximizing the likelihood function using gradient-based optimization algorithms like gradient descent, the calculation of the gradient becomes crucial. However, directly computing the gradient of a product involving numerous terms can be computationally expensive due to the complexities associated with the chain and product rule. To address this challenge, the log-likelihood function is used, denoted by 
$
L L(theta) &= ln(L(theta)))\
&= ln(product_(i=1)^N p(D_i | theta))\
&= sum_(i=1)^N ln(p(D_i | theta)).\
$ 

This transformation holds a key property: the argument that maximizes the log-likelihood function also maximizes the original likelihood function. This is because the monotonic nature of the logarithm function preserves the order of the function's maxima.

A second advantage of the log-likelihood function arises from the product rule of logarithms. The logarithm of a product transforms into the sum of the logarithms of the individual factors. 
This transformation bypasses the need to employ the computationally expensive product rule when calculating the gradient of the likelihood function. 

The last benefit of employing the log-likelihood function lies in its enhanced numerical stability. When dealing with probability distributions in high-dimensional spaces, the likelihood function can generate extremely small values, due to the product of a lot of numbers. These values can lead to underflow errors due to limitations in the precision of floating-point arithmetic used by computers.  
Employing the log-likelihood function mitigates this issue. The logarithmic transformation maps these small values into a more manageable range, where calculations can be performed with greater precision. This characteristic of the log-likelihood function reduces the frequency of encountering numerical inaccuracies during the optimization process.

Another observation in @def:mle is that the likelihood of each datapoint is multiplied. As stated in @def:independence this is only possible if the events are independent. Furthermore, the maximization process inherently assumes that the model's parameters governing the likelihood function remain constant across all data points. This combination of assumptions, where data points are both independent and identically distributed, is commonly referred to as the *independent and identically distributed (i.i.d.) assumption.*

Lastly, @def:mle can be expanded to the weighted MLE (WMLE).
In some cases one might want to assign a certain importance weight to datapoints. For such a scenario, @def:wmle states an appropriate optimization goal.

// TODO Check definitions of MLE and WMLE
#definition([Weighted Maximum Likelihood Estimate])[
$L(bold(theta), bold(W))$ is called the weighted likelihood function. The goal is to determine
$
hat(theta)_("WMLE") = arg max_(theta in Theta) L(theta, W) =  arg max_(theta in Theta) product_(i=1)^N w_i p(D_i | theta),
$
which is called the *Weighted Maximum Likelihood Estimate* (WMLE) and $N$ being the number of observations.

The weighted log likelihood function is given by

$
ln (W L(theta, W))  = sum_(i=1)^N ln(w_i) + ln(p(D_i | theta)).
$
]<def:wmle>

== Queries
<sec:queries>

This section focuses on key quantities (queries) that are frequently employed for characterizing and analyzing probabilistic phenomena. While one may have encountered these concepts informally in various contexts, this section provides a formal introduction accompanied by illustrative examples.

This section builds upon the theoretical foundation laid out in the work of #cite(<choi2020probabilistic>), which explores probabilistic query definitions. However, this thesis goal of applying probabilistic models to enhance robotic planning motivates a more use-case-driven approach to query specification. 
Despite this shift in focus, the complexity classes identified by #cite(<choi2020probabilistic>) are the basis for characterizing the queries discussed in this section.

The abstract specification of a probabilistic model that supports these queries is implemented in @schierenbeck2024pm.

=== Running Example
<sec:running_example>

Illustrating the concepts presented in this section, this thesis considers a simplified scenario involving a robot interacting with objects in its environment.  
This scenario is modeled as a sample space defined by four random variables:
- *Object Type*: This symbolic variable takes values from a set representing different object types that the robot can interact with, such as {Bowl, Cup, Spoon, Knife}. The Object Type is abbreviated as *O*. The measurable space on *O* is (*O*, $2^bold(O)$).  
- *Robot Type:* This symbolic variable takes values from a set representing different robot types, such as {PR2, Tiago, HSR}.
  The Robot Type is abbreviated as *R*. The measurable space on *R* is (*R*, $2^bold(R)$).  
- *X Coordinate*: This continuous variable represents the robot's x-coordinate relative to the object within the two dimensional environment. Its domain is $RR$. The X Coordinate is abbreviated as *X*. Them measurable space on *X* is $(RR, Beta)$.
- *Y Coordinate*: This continuous variable represents the robot's y-coordinate relative to the object within the two dimensional environment. Its domain is $RR$. The Y Coordinate is abbreviated as *Y*. Them measurable space on *Y* is $(RR, Beta)$.

The elementary events of this scenario correspond to specific assignments of values to each of these variables.  The sigma algebra associated with this sample space is constructed using the product algebra construction over these variables, as detailed in #ref(<sec:product-sigma-algebra>). Formally, the probability space is described as $(bold(O) times bold(R) times bold(X) times bold(Y),
2^bold(O) times.circle 2^bold(R) times.circle Beta times.circle Beta, P_"Pick-Up")$.

The specific scenario this chapter focuses on involves a robot attempting to pick up an object. This scenario allows the exploration of concepts like probability distributions and events to model and reason about robotic actions within an environment.

=== Likelihoods

A likelihood query evaluates the joint probability distribution at a specific point, representing a particular "possible world" scenario. In this type of query, all variables are assigned values, and no integration over the probability space is performed.  Essentially, likelihood queries calculate the probability of a specific outcome (represented by x) occurring simultaneously.

A possible query could look like
$
p(&"Object Type" = "Bowl", "Robot Type" = "PR2", \ 
  &"X Coordinate" = 0.7, "Y Coordinate" = -0.3)
$
or as a shorter version that assumes a fix variable order
$
p("Bowl", "PR2", 0.7, -0.3).
$

Although likelihood queries might have limited direct application in specific robotics use cases, they play a crucial role in the training process of probabilistic models, as explained in #ref(<sec:maximum_likelihood_principle>). Furthermore, the likelihood function of a model is highly relevant for sampling, which is explained in @sec:sampling-query.

=== Probabilities
<sec:probability-query>

A probability query, as its name implies, computes the probability of a set within a probabilistic model. In the scope of this thesis the probability query refers to the probability estimation of an event of the product sigma algebra. 

Sigma additivity, introduced in @def:probability_measure, allows to efficiently calculate the probability of a composite events by leveraging the probabilities of the simple events.

Since, as discussed in @sec:product-sigma-algebra, composite events are always represented as disjoint union, the study of the probability query results in the study of a probability of simple event of the product algebra.

The significant challenge associated with probability queries lies in constructing models that can compute the exact probability of events in polynomial time. In other words, the goal is to design algorithms whose execution time scales proportionally to the size of the input (the complexity of the event) without encountering exponential growth. Those algorithms are called *tractable*.

An example of such query is 
$
P(bold(O) in \{"Bowl", "Cup" \}, bold(R) in \{"PR2"\}, bold(X) in [-1, 0.5], bold(Y) in RR).
$

// TODO P(E) = int_E p(x) dx

The formal definition for this type of calculation is presented in @def:probability_query. This definition builds upon the work in @choi2020probabilistic, while being tailored to the specific context and notation employed within this thesis.

#definition([Probability Queries (Adopted from #cite(<choi2020probabilistic>))])[

Let $p(X)$ be a joint distribution over random variables $bold(X)$. The class of *probability queries* is the set of functions that compute
$
P(E)
$
where $E$ is a simple event of the product sigma algebra. 
] <def:probability_query>

Probability queries not only allow for that calculation of a probability, but also for the calculation of conditional probabilities as in #ref(<def:conditional_probability>). The intersection of two events is an algebraic operation and hence not something a probabilistic model deals with.

Effectively calculating the exact probability of complex events often necessitates employing techniques from multivariate calculus, particularly the concept of integration. A discussion on this topic is provided in //#ref(<sec:probabilistic-circuits>) 
and the details are found in #cite(<choi2020probabilistic>).

// Todo probability of normal uniform and pdf
=== Moments
<sec:moment-query>

The next interesting quantity regards the calculation of moments of a distribution. 
Moments occupy a prominent role in the statistical analysis of probability distributions. These numerical summaries, specifically the mean, variance, skewness, and kurtosis, offer a characterization of a distribution's central tendency, spread, shape, and tail behavior.
The mean (first moment) captures the distribution's center of mass, while higher moments like variance (second moment) quantify the spread around the mean.
Skewness measures the asymmetry of the distribution, indicating a lean towards positive or negative values. Kurtosis describes the tailed-ness, the tilt for extreme values compared to the center.
Moments are described formally in #ref(<def:moment>).

#definition([Moment (Adopted from #cite(<choi2020probabilistic>))])[

The moment describes the function
$
MM_c^n (x) = integral (x - c)^n p(x) d x
$
where $n$ is called the order and $c$ is called the center.
In a multivariate context, both $n$ and $c$ are vectors, describing the order and center for every variable.
]<def:moment>

In most machine learning applications, the employed models predict the conditional expectation $EE [x | y]$, which may not be enough.
This point is further emphasized in #ref(<fig:truncated_gaussian_mode>) where an example demonstrates how relying solely on conditional expectation can be misleading. Conditional expectation, while valuable, represents just one facet of a distribution. When interpreted as a certainty, it leads to wrong conclusions.

Moments are not applicable to symbolic domains. This stems from the fact that symbols cannot be subtracted or potentiated, which are fundamental operations required for calculating moments.

A common scenario is determining the anticipated time required for an action to finish. Consider a random variable $t$  representing the completion time of an action. The expected waiting time can be computed using
$
MM_0^1 (t) = integral t dot p(t) d t.
$

// TODO Moments of normal, uniform and dirac
=== Conditional Distributions
<sec:conditional-distributions>

While conditional probability provides a valuable tool for understanding the likelihood of an event in the light of another event, it offers an incomplete picture. The full conditional distribution, on the other hand, is a more comprehensive and informative tool for probabilistic modeling. 

Real-world knowledge often goes beyond simple probabilities.  Facts, rules, and relationships can influence the likelihood of events. The full conditional distribution allows to integrate this symbolic knowledge seamlessly into probabilistic models. Consider a fact stating that "The HSR cannot pick up a bowl." The full conditional distribution can represent this by assigning 0 probability to that event. This ability to incorporate symbolic constraints allows to build more accurate and nuanced probabilistic models that reflect the richness of real-world knowledge.

#definition([Conditional Query])[
Let $p(X)$ be a joint distribution over random variables $X$. The class of *conditional queries* is the set of functions that compute
$
p(X | E).
$
The resulting distribution is a full distribution over $X$. 
] <def:conditional-query>

An additional advantage of employing full conditional distributions lies in their ability to facilitate dynamic belief updates within robotic agents. As robots explore their environments and collect new information, their understanding of the world constantly evolves. Full conditionals provide a powerful mechanism for incorporating these newly discovered facts into the robot's internal belief state. Through repeated application of conditional updates, the robot refines its probability distribution over various actions and outcomes. With each new condition (representing a newly discovered fact), the space of possible outcomes shrinks, effectively focusing the robot's belief state on the scenarios that are increasingly probable given the accumulated evidence. This ongoing process of conditioning allows the robot to maintain an accurate and up-to-date representation of the world, enabling it to make informed decisions and adapt its behavior accordingly.

While the power of full conditional distributions is undeniable, their application to continuous probability distributions presents unique challenges. Unlike discrete cases where conditioning is a well-established concept, conditioning continuous distributions remains a less explored research area. This is primarily due to the potential disruption of key properties associated with the PDF of the original distribution. When conditioning a continuous distribution, modifications are often required to change the support (the set of all possible values) of the distribution.  These modifications can inadvertently alter or even destroy desirable properties of the original PDF, such as its integrability or finite variance. As a result, ensuring the mathematical soundness of conditioned continuous distributions requires careful consideration. 

#definition("Support")[
  Let $(E, Im, P)$ be a probability space. The support of $P$ is the set
  $
  {x | x in E and p(x) > 0}.
  $
]

To illustrate these challenges, this section now goes into the specific case of conditioning a normal distribution.

The calculation of the first two moments of a Gaussian distribution is particular easy due to them being the parameters of the distribution. However, as soon as part of the Gaussian gets cut off by a conditioning on an interval, this property is lost. 

Consider a truncation of the normal on the general interval $["lower", "upper"]$. According to @ogasawara2021non, the numerical stable calculation of a moment on such a truncated normal is shown in @theorem:moment-truncated-normal. While a deep understanding of the theorem itself is not crucial for this thesis, it serves as a shining illustration. The theorem demonstrates the potential complexities that can arise when applying truncation to well-understood probability distributions, such as the normal distribution. This highlights the importance of careful consideration when employing truncation techniques in various contexts.

#theorem([Moment of a truncated Gaussian Distribution @ogasawara2021non])[
The function
$
MM_c^n &= sigma^n / (Phi("upper") - Phi("lower")) sum_(k=0)^n binom(n, k) I_k (-c)^(n - k), "where" \
I_k &= 2^(k/2) / sqrt(pi) Gamma ((k+1)/2) op("sgn")("upper") bb(1)_{k = 2v } + bb(1)_{k = 2v - 1} 1/2 F_Gamma ("upper"^2 / 2, (k+1) / 2) \
& -op("sgn")("lower") bb(1)_{k = 2v } + bb(1)_{k = 2v - 1} 1/2 F_Gamma ("lower"^2 / 2, (k+1) / 2)
$ calculates the moment of a truncated Gaussian distribution for $k, v = 0, 1, ...$. The term $F_Gamma (x,a)$ denotes the cdf of the gamma distribution at $x$ when the shape parameter is $a$ with the unit scale parameter. The truncation is on the interval $["lower", "upper"]$.]<theorem:moment-truncated-normal>

The uniform distribution presents a particularly easy case for truncation due to its simple PDF and already finite support. When truncating a uniform distribution, the key concept to consider is the support. The truncation process essentially modifies the support of the original distribution by restricting it to the intersection of the conditioning event and the original support.  In the case of a uniform distribution conditioned on an interval, this intersection simply defines a new interval that serves as the support for the resulting truncated distribution. As a consequence, the truncated distribution itself remains a uniform distribution, albeit with a modified support that reflects the conditioning applied.

The Dirac delta function, while not a direct representation of real-world data itself, plays a significant role in the analysis of conditional distributions within continuous domains.  
It serves as a mathematical tool for representing a point mass – a distribution that concentrates all its probability mass at a single point.

In the context of conditional distributions, the Dirac delta function arises when conditioning on a specific event that perfectly locates a continuous random variable. This essentially implies observing a "fact" within the continuous domain.  As a consequence, the original distribution's uncertainty collapses, and the resulting conditional distribution becomes a Dirac delta function centered at the observed value.

If the standard uniform distribution (see #ref(<fig:uniform_pdf>)) is conditioned on the singleton interval $[0, 0]$, the distribution in #ref(<fig:dirac_delta_pdf>) is obtained. 

=== Marginalization
<sec:marginal-query>

A marginal query seeks to obtain the probability distribution of a subset of variables within a joint distribution, effectively "marginalizing out" the influence of other variables. This can be motivated by a desire to focus on specific aspects of the system while acknowledging the presence of other, potentially irrelevant, variables. Mathematically, marginalization is achieved by integrating over (summing over in the discrete case) the unwanted variables within the joint PDF of the original distribution.

#definition([Marginal Query])[

Let $p(X)$ be a joint distribution over random variables $bold(X)$. The class of *marginal queries* is the set of functions that compute
$
p(Y) = integral p(X) d Z_1 dots d Z_k
$
$Z = X without Y$ are the remaining $k$ variables that are integrated out.] <def:marginal-query>


Consider a situation where the robot is only interested in the distribution over objects that may occur. We obtain the distribution over the object by removing all other variables from the joint distribution. The marginal query

// TODO correct syntax
$
p(bold(O)) = integral_RR integral_RR integral_R p(bold("O, R, X, Y")) d bold(R) d bold(X) d bold(Y)
$
achieves this. The resulting distribution $p(bold(O))$ describes the frequency in which objects occur in a pick up scenario.

=== Modes
<sec:mode-query>

The mode of a distribution is the value that appears most frequently. The mode holds particular significance for skewed distributions where the mean might not accurately reflect the typical outcome. 
Unlike the mean, which emphasizes central tendency through averaging all possible values, the mode focuses on the distribution's peak.

#definition([Mode Query])[

Let $(E, Im, P)$ be a probability field. The class of *mode queries* is the set of functions that compute
$
arg max_(m in Im) p(x).
$
] <def:mode-query>

Unlike the definition offered by #cite(<choi2020probabilistic>), the concept of the mode in this work adopts a more general perspective. #cite(<choi2020probabilistic>) define the mode as the vector that maximizes the PDF of a distribution. However, this definition overlooks a crucial aspect: the maximum of the PDF may not always correspond to a single point, but rather a set of points. To address this limitation, the concept of the mode employed here focuses on identifying the random event that maximizes the PDF point-wise. It's important to clarify that this doesn't equate to finding the event with the highest overall probability. Instead, the goal is to identify the random event where every elementary event within that set possesses an equally and maximally high likelihood. 

#figure(
  image("../images/truncated_gaussian_mode.svg"),
  caption: [Mode of the standard Gaussian distribution after it is truncated on the interval $(-infinity, -0.3] union [0.3, -infinity)$. The mode of this truncated distribution is $[-0.3, -0.3] union [0.3, 0.3]$.])
  <fig:truncated_gaussian_mode>

The concept of the mode plays a crucial role in the decision-making processes of cognitive robots. These robots are designed to operate in dynamic environments and often require selecting actions that maximize their chance of success. This objective can be directly translated into a mode query, where the robot seeks to identify the parameterization of an action that corresponds to the peak of the probability distribution representing the likelihood of success.

Furthermore, cognitive robots can leverage conditional distributions to refine their mode queries and incorporate situational constraints. By conditioning the distribution on the robot's current knowledge, the robot can effectively focus on the most probable successful actions given the specific context. This capability allows cognitive robots to calculate the optimal course of action even in the face of uncertainty, enhancing their adaptability and robustness in dynamic environments.

Consider a scenario where the PR2 robot wants to pick up a bowl. The robot asks himself where to stand with respect to the object in order to pick it up. The function 
$
arg max_(m in Im) p(O, R, X, Y | O = "Bowl", R = "PR2")
$
calculates the set of most likely positions to successfully pick up said bowl.

=== Sampling
<sec:sampling-query>

Sampling refers to the process of selecting a subset of individuals from a larger population, aiming to represent the characteristics of the entire group. By analyzing this well-chosen subset, one can gain valuable insights into the broader population with a degree of accuracy.

An important use-case of sampling is the creation of behavior according to a probability distribution. 
The study of sampling from distributions is an entire research field itself. 
A common, fast method is the usage of the inverse CDF sampling algorithms. Computers are deterministic machines and hence are not able to generate random numbers. Random numbers can only be obtained from real physical processes. Fortunately, computers can generate pseudo random numbers using algorithms. The pseudo random numbers are distributed according to the standard uniform distribution. These samples can now be transformed to a different distribution iff a transformation between the standard uniform CDF and the target distributions CDF is possible. The limitation of an inverse CDF existing is more severe than it seems on the first glance. For example, a truncated gaussian cannot be used for inverse CDF sampling. This is another instance of the truncation of a well studied object is not as well studied.
Whenever the inverse CDF does not exist, more complex and less efficient sampling algorithms are applied. A prominent instance of that is rejection sampling. The general schema of rejection sampling is seen in #ref(<alg:rejection-sampling>).

#figure(caption: [Rejection Sampling], kind: "algorithm", supplement: [Algorithm])[
#algo(
            title: "Rejection Sampling",
            parameters: ($p, g$, ),
            init: (
                (
                    key: [Input],
                    val: (
                        [$p$, a PDF of the form $p(x) = f(x)/Z_f$, where $Z_f = integral_(-infinity)^infinity  f(x) d x$ is the unknown normalization constant of $p$.],
                        [$g$, a function where $Z_g dot g(x) >= f(x) forall x$ and where sampling from $g$ is possible],
                    )
                ),
                (
                    key: [Output],
                    val: ([A sample of $p(x)$],)
                )
            )
        )[
accept $arrow.l "False"$\
*While* not accept: #i \
  $x_g arrow.l x tilde g$\ 
  accept $arrow.l "Bernoulli"(p=f(x) / (Z_g dot g(x)))$ \
  *if* accept: #i\
    *Return* $x_g$
]
]<alg:rejection-sampling>
// TODO check if this algo is nicely noted

The marginal acceptance probability of rejection sampling is given by the ration $Z_f / Z_g$. This ratio decreases exponentially with increasing number of dimensions of the distribution and hence becomes inefficient in high dimensional spaces.
Unfortunately, all sampling algorithms besides inverse CDF sampling require some form of rejection sampling. Fortunately, any uniform distribution can be directly sampled from by using inverse CDF sampling. 

The ability to generate random numbers from a distribution is not only relevant for generating examples. Probabilistic inference often necessitates the computation of integrals, as discussed in #ref(<sec:probability-query>), #ref(<sec:moment-query>), #ref(<sec:conditional-distributions>) and #ref(<sec:marginal-query>). 
However, analytical integration, while elegant, has its limitations. When encountering complex functions or high-dimensional integrals, achieving closed-form solutions becomes challenging. The limitations of integration for probabilistic inference are discussed in //#ref(<sec:probabilistic-circuits>). 
Fortunately, sampling methods provide robust alternatives, offering reliable approximations for these integrals.

#definition([Monte Carlo Estimator])[

Consider $n$ independent samples $x_1,..., x_n$ from a multidimensional
random variable with a certain PDF $p(x)$. Then a Monte Carlo (MC) estimate would be a way of approximating multidimensional integrals by using the previously drawn samples. 
Formally, the approximation 
$
EE_p [f(x)] = integral f(x) p(x) d x approx 1/n sum_i^n f(x_i)
$
is called the Monte Carlo estimator.\
]<def:monte_carlo>

A frequently used Monte Carlo Estimate is for the expected value of a variable, i. e.
$
EE_p [x] = integral x p(x) d x approx 1/n sum_i^n x.
$
It can be shown that the MC method always results in the correct value, if infinite samples are available. This property is called unbiased. However, the quantity calculated using the MC estimator varies with varying amount of samples. Here, the second moment contains a valuable information by quantifying the variance of said function with the amount of samples. The variance is given by 
$
(EE_p [(x - EE[x])^2] ) / n,
$
meaning that with every new sample the variance decreases linearly. and the standard deviation, i. e. the square root of the variance decreases at a ration of $1 / sqrt(n)$. This renders the Monte Carlo estimator useful for rough approximations, but infeasible for exact calculations. 

=== Pairwise Queries

In the previous sections interesting quantities for one probability distributions were discussed. However, some situations require properties of pairs of distribution.
One of such situations is the quantization of a difference in behavior. Consider two probability spaces $(E, Im, P)$ and $(E, Im, Q)$ on the same measurable space. P is a distribution that describes how the PR2 robot picks up objects and Q describes how the HSR does it. This thesis now discusses some techniques that measure how much P and Q differ. 
This class of queries is called *Pairwise Queries*.
A very popular metric is the Kullback–Leibler Divergence as described in @def:kld.

#definition(title: [Kullback–Leibler Divergence @deza2009encyclopedia])[

  Let $(E, Im)$ be a measurable space and $P, Q$ be two measures with density $p$ and $q$. The Kullback–Leibler Divergence (KLD) is given by
  $
  D_(K L)(P, Q) = integral p(x) log(p(x) / q(x)) d x.
  $
]<def:kld>

While the KLD is a popular way of expressing the difference of two distributions it comes with numerous problem attached.
For instance, it is neither symmetric, nor bounded to any maximum value and does not work well for distributions with finite support.

In the scope of this thesis, comparing distributions is desired to be symmetric and at least 0, indicating two distributions are completely equal or 1, indicating they agree nowhere.
A pairwise query that computes such a number is the $L_1$ metric between densities. The $L_1$ metric is an instance of the $L_p$ metric. As stated in @def:lp_metric, this family of metrics describes the analytical difference between densities where the difference is potentiated by $p$. An example of the $L_1$ metric is shown in @fig:l1_metric.

#definition(title: [$L_p$ Metric @deza2009encyclopedia])[

   Let $(E, Im)$ be a measurable space and $P_1, P_2$ be two measures with density $p_1$ and $p_2$.
   The $L_p$ metric is given by 
   $
   L_p (p_1, p_2) = 1/2(integral_Im |p_1(x) - p_2(x)|^p d x)^(1/p)
   $
]<def:lp_metric>

#figure(caption: [Visualization of the $L_1$ metric between to Gaussian PDFs (blue and green). The red area in between is the area calculated by the $L_1$. The $L_1$ metric between the two distributions is $approx 0.39$])[
  #image("../images/l1_metric.png")
]<fig:l1_metric>


Under my supervision a bachelor thesis investigated this metric in the context of probabilistic circuit (which are introduced later in TODO. //@sec:probabilistic-circuits). 

@theo:mc_probability shows how to calculate the probability of an arbitrary event using the Monte Carlo method.
The $L_1$ metric is then restated towards a form that works well with probabilistic semantics in @theo:alternate_l1. 



#definition([Indicator Function])[
  The indicator function of a subset $E$ of a set $Im$ is the function indicating 1 if an element if contained in $E$ and 0 otherwise.
  $
  bb(1)_E (x) = cases(1 "if" x in E, 0 "if" x in.not E)
  $
]

#theorem([Approximation of a Probability])[
  Let $(E, Im, P )$ be a measure.
  The probability of an arbitrary event $A subset.eq Im$  can be approximated using the Monte Carlo method and indicator functions as
  $
  P(A) approx 1/n sum_i^n bb(1)_A (x_i).
  $
]<theo:mc_probability>

#proof[of @theo:mc_probability][
  $
    P(A) &= integral_A p(x) d x\
  &= integral_E bb(1)_A (x) p(x) \
  &approx EE_p [bb(1)_A (x)] \ 
  &= 1/n sum_i^n bb(1)_A (x_i).
$
]

Due to the complexity of calculating the exact value of the $L_1$ metric a Monte-Carlo estimator  (@theo:mc_l1) was proven among other things. 

#theorem([Alternate form of the $L_1$ Metric. @neumann2025l1])[

  Let $(E, Im, P)$ and $(E, Im, Q)$ be two probability spaces with density $p$ and $q$.\
  Let $E_p = \{ x | p(x) > q(x)\}$ \
  Let $E_q = E_p^c$ \
  $
  L_1(p,q) = P(E_p) - Q(E_p)
  $
]<theo:alternate_l1>

#proof([of @theo:alternate_l1 @neumann2025l1])[  
  $
  L_1(p,q) &= 1/2 integral|p(x)-q(x)|d x \
  
  & = 1/2 integral  bb(1)_(E_p)(p(x)-q(x)) +  bb(1)_(E_q) (q(x)-p(x)) d x | "split into disjoint parts"\
  
  &= 1/2 (integral bb(1)_(E_p)(p(x)-q(x)) d x + integral bb(1)_(E_q)(q(x)-p(x)) d x) \
  
  &= 1/2 (integral bb(1)_(E_p)p(x)- bb(1)_(E_p)q(x) d x + integral  bb(1)_(E_q)q(x)- bb(1)_(E_q)p(x) d x)  \

  &= 1/2 (integral bb(1)_(E_p)p(x) d x - integral bb(1)_(E_p)q(x) d x\
  & + integral  bb(1)_(E_q)q(x) d x - integral bb(1)_(E_q)p(x) d x  )\
  &= 1/2 (P(E_p) - Q(E_p) + Q(E_q) - P(E_q)) \
  &= 1/2 (P(E_p) - P(E_q) + Q(E_q) - Q(E_p)) \
  &= 1/2 (P(E_p) - (1 - P(E_p)) + (1 - Q(E_p)) - Q(E_p))\
  &= 1/2 (P(E_p) - 1 + P(E_p) + 1  - Q(E_p) - Q(E_p))\
  &= 1/2 (2P(E_p) - 2Q(E_p)) \
  &= P(E_p) - Q(E_p)
  $
]

#theorem([Approximation of the $L_1$ Metric. @neumann2025l1])[
The $L_1$ metric can be approximated as 
$
L_1(p,q) approx underbrace(1/n sum_i^n bb(1)_E_p (x_i), "Samples from P") - underbrace(1/n sum_i^n bb(1)_E_p (x_i), "Samples from Q"). 
$
]<theo:mc_l1>

#proof[of @theo:mc_l1][
  $
L_1(p,q) &= P(E_p) - Q(E_p) \
&= integral_E bb(1)_E_p (x) p(x) d x - integral_E bb(1)_E_p (x) q(x) d x \
&approx 1/n sum_i^n bb(1)_E_p (x_i) - 1/n sum_i^n bb(1)_E_p (x_i). 
$
]<proof:mc_l1>

A pleasant characteristic of this estimator is its finite variance. 
The variance of an indicator function (@theo:variance_of_indicator) can be used to calculate the variance of @theo:mc_l1. @theo:variance_of_l1_mc shows that the variance of the indicator is at most $0.5$ and hence the standard deviation of the result of a Monte Carlo estimation of the $L_1$ metric is very small at manageable samples sizes. For instance, at $n = 100000$ samples the expected deviation is at most $sqrt(0.5)/sqrt(100000) approx 0.0022$. Hence, even for maximally varying results of the approximation, the estimate is fairly accurate.

#theorem([Variance of Indicator Function])[
  The variance of an indicator function is given by 
  $
    "Var"(bb(1)_E) &= P(bb(1)_E) (1-P(bb(1)_E)) \
    &<= 0.25.
  $
]<theo:variance_of_indicator>

#theorem([Variance of Monte Carlo Approximation of the $L_1$ metric. @neumann2025l1])[
  $
  "Var"(L_1(p, q)) &= "Var"(P(E_p) - Q(E_p)) \
  &= underbrace(P(E_p)(1 - P(E_p)) - Q(E_p)(1 - Q(E_p)), "Max if " P(E_p) = 0.5" and" Q(E_p) = 0) \
  &<= 0.5
  $
]<theo:variance_of_l1_mc>


For an extensive discussion of various distances the Encyclopedia of Distances serves as a valuable resource. @deza2009encyclopedia

// TODO steckbriefe von uivariaten verteilungen