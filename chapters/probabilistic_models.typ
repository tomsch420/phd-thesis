#import "../thesis-imports.typ": *
#import "@preview/fletcher:0.5.1" as fletcher: diagram, node, edge


= Probabilistic Models
<sec:probabilistic_models>

Understanding the relationships between multiple random variables lies at the heart of many scientific endeavors and especially machine learning. Joint probability distributions serve as a valuable tool for expressing these connections. 
However, efficiently representing and manipulating joint distributions, especially for high-dimensional scenarios, is a significant challenge.

While the previous section (@sec:probability_theory) focussed on the probability function as a whole, this section delves into the actual representations of joint probability distribution. 
The focus in the context of this thesis is on tractable distributions.
Tractable distributions are distributions where answering a query takes at most polynomial many time steps with respect to the size of a distribution. As @sec:probability-query discussed, there are multiple, structurally different types of queries. It follows, that tractability is a spectrum where a model can be characterized for tractability of a query type. Furthermore, it is required that a model gives an *exact* answer for a query and not an approximate answer, like the MC estimate of an integral. 

#definition(title: [Tractable Probabilistic Inference @choi2020probabilistic])[
  A class of queries *Q* is tractable on a family of probabilistic models $M$ iff any query $q in bold(Q)$ on a model $m in M$ can be computed in time $O("poly"(|m|))$. We also say that $M$ is a tractable model for *Q*.
]

For long lived agents, such as cognitive robots, exact inference is highly important. If a model of the world is correct, but answers from the model are only random, such as in the MC method, it can be concluded that there is a non-zero probability that the model produces an answer that leads to a catastrophic failure. While this probability is often very low, it is increased with the total number of times the model is queried.
Such a behavior of a random variable is quantified in the geometric distribution.

This section discusses tractability of probabilistic graphical models (PGMs) and probabilistic circuit (PCs). Intractable models, such as generative neural networks (GANs) or normalizing flows (NFs) are only touched on. 
// TODO adjust with how this chapter evovles

== Graphical Models

Probabilistic Graphical Models (PGMs) offer a graphical representation of joint probability distributions, leveraging a visual language to encode the dependencies between random variables. These models depict variables as nodes in a graph, and the relationships between them are captured by edges connecting the nodes. The specific connections and the absence of edges encode the conditional independence relationships that simplify the joint distribution.

PGMs are a valuable tool for understanding and manipulating joint probability distributions since:

- *Visualizing Dependencies:*  Unlike traditional algebraic representations of joint distributions, PGMs provide a clear and high-level visual depiction of the relationships between variables. This intuitive approach allows researchers to readily identify the variables that directly influence each other and those that are conditionally independent.

- *Efficient Representation:* For high-dimensional problems, representing a joint distribution with a complex mathematical formula is impracticable. PGMs offer a more compact and scalable representation, particularly when conditional independence relationships exist between variables. This efficiency translates to improved computational performance and easier analysis.

- *Diverse Applications:*  The versatility of PGMs extends across various scientific disciplines. From modeling gene regulatory networks in biology to analyzing relationships between financial assets, PGMs offer a powerful tool for understanding complex systems characterized by interconnected variables.

In essence, PGMs bridge the gap between complex joint probability distributions and intuitive visual representations. By leveraging the power of graphs, PGMs empower researchers to effectively analyze, reason about, and make predictions in scenarios involving multiple interacting random variables. 

However, this high level abstraction of PGMs makes it hard to analyze computations on them. 

The fundamental idea behind graphical models revolves around factorization. These models seek to represent a joint probability distribution, which can be quite intricate, as a product of more manageable conditional distributions. This factorization process not only simplifies the representation but also opens doors to efficient algorithms for reasoning about the dependencies between the involved random variables.

In @tab:combinatoric_explosion it was shown that representing a distribution as the joint probability table over all variables is exponentially hard and hence not tractable. PGMs solve this problem by computing the global distribution by small, local factors, leveraging the product rule (@def:conditional_probability) and conditional independence (@def:conditional_independence).

=== Bayesian Networks

A very prominent PGM is the Bayesian network. A Bayesian Network is a directed acyclic graph (DAG) that models variables as nodes and dependencies as directed edges.
An example of such a model is shown in @fig:bayesian_network_example.
The idea is, that a variable that has an outgoing edge to another variable influences that distribution of the child variable. 
The advantage is clearly, that instead of having to write down the entire distribution only the distributions for each node conditioned on their parent nodes are needed.
The limitations, however, are severe. First off, the model does not easily allow for continuous variables in non-leaves of the DAG. Second, in real world scenarios, it is very rare that conditional independence arises when only using the observed variables.
Third, there may not be an acyclic graph that expresses the dependencies.
Lastly, inference in Bayesian Networks is not straight forward. While the literature discusses many methods, e. g. belief propagation, the sum product algorithm and many more, they do not directly translate to the queries discussed in @sec:queries. @choi2020probabilistic @darwiche2009modeling 
It can be observed that a Bayesian Network where all variables but one are parents of that one circumvents most of the problems.
However, it requires to express $P(bold(Y) | bold(O), bold(R), bold(X)).$ The complexity of representing the distribution of a node is exponential in the number of parent nodes and hence, nothing is gained by such a factorization.

// Example distribution using the example from S4
// What if no factorization exists like that?
// Problems with continuous variables

#figure(caption: [A Bayesian Network factorizing the distribution of the scenario in @sec:running_example using the factorization 
$
P(bold(O), bold(R), bold(X), bold(Y)) = P(bold(R)) dot.c P(bold(O) | bold(R)) dot.c P(bold(X) | bold(O)) dot.c P(bold(Y) | bold(O)).$ 
])[
  #diagram(node-defocus: 0,
	spacing: (1cm, 2cm),
	edge-stroke: 1pt,
	crossing-thickness: 5,
	mark-scale: 70%,
	node-fill: luma(97%),
	node-outset: 3pt,
	node((0,0), "Robot Type"),
	node((0,1), "Object Type"),
	node((1,2), "X"),
	node((-1,2), "Y"),
  edge((0, 0), (0, 1), "->"),
   edge((0, 1), (1, 2), "->"),
   edge((0, 1), (-1, 2), "->"),
 )
]<fig:bayesian_network_example>

#figure(caption: [A Bayesian Network factorizing the distribution of the scenario in @sec:running_example using the factorization 
$
P(bold(O), bold(R), bold(X), bold(Y)) = P(bold(R)) dot.c P(bold(O)) dot.c P(bold(X)) dot.c P(bold(Y) | bold(O), bold(R), bold(X)).$ 
])[
  #diagram(node-defocus: 0,
	spacing: (1cm, 2cm),
	edge-stroke: 1pt,
	crossing-thickness: 5,
	mark-scale: 70%,
	node-fill: luma(97%),
	node-outset: 3pt,
	node((-1,0), "Robot Type"),
	node((0,0), "Object Type"),
	node((1,0), "X"),
	node((0,1), "Y"),
  edge((0, 0), (0, 1), "->"),
   edge((-1, 0), (0, 1), "->"),
   edge((1, 0), (0, 1), "->"),
 )
]<fig:stupid_bayesian_network_example>


#definition([Bayesian Network @gordon2014probabilistic])[

A Bayesian Network is a directed acyclic graph $G = <V, E>$, 
where every vertex $v in V$ is associated with a random variable $X_v$, 
and every edge $(u, v)$ in $E$ represents a direct dependence from the random variable $X_u$ to the random variable $X_v$. 

Let $"Deps"(v) = \{u | (u, v) in E \}$ denote the direct dependences of node $v in V$. 
In a Bayesian Network, each node $v in V$ of the graph is associated with a conditional probability distribution $"CPD"(v)$, 
which denotes the probability distribution of $X_v$ conditioned over the values of the random variables associated 
with the direct dependences $D(v)$.

The likelihood function of a Bayesian Network is defined as the product of the conditional probability distributions

$
P(X_1, dots, X_n) = product_(v in V) P(X_v) | "Deps"(X_(v)).
$

]<def:bayesian-network>

=== Latent Variable Trees

TODO SOURCES AND EXAMPLES

Latent variable trees are a specialized type of Bayesian Network incorporating latent variables. Latent variables, also known as hidden or unobserved variables, are not directly measured but are hypothesized to influence observed variables. They represent underlying factors, constructs, or states explaining relationships between observed data. Most important, the latent variables are not part of the training data. They are only an aid to model the data in a tractable model.

These models are characterized by a hierarchical, branching structure, where each node (except the root) has exactly one parent. Tree structures offer several advantages. They allow for efficient inference algorithms, such as message-passing algorithms like belief propagation, which can perform inference efficiently in tree-structured graphs. 
They also provide intuitive interpretation, as the hierarchical structure offers a clear and interpretable representation of relationships between variables. 
Furthermore, trees can generally be translated to a computational graph of polynomial size, making them computationally tractable, as will be discussed in @sec:probabilistic-circuits.
Compared to more general graph structures, trees are relatively simple to learn and reason about, making them a popular choice for modeling complex systems.

Latent tree models combine tree-structured models and latent variables. They are tree-structured Bayesian Networks where some or all internal nodes represent latent variables. 
Several common types of latent tree models exist. Latent Class Trees have each node in the tree representing a latent class or cluster. Observed variables are assumed conditionally independent given their assigned class.
A very prominent instance of this is the Naive Bayes classifier.

Latent tree models have found applications in a wide range of fields. These include Natural Language Processing, for tasks like topic modeling, sentiment analysis, and document classification; Computer Vision, for tasks like image segmentation, object recognition, and scene understanding; Bioinformatics, for tasks like gene expression analysis, phylogenetic tree reconstruction, and protein function prediction; Social Network Analysis, for tasks like community detection, influence modeling, and social network evolution; and Recommender Systems, for tasks like user preference modeling and personalized recommendations.

Latent variable trees are limited by the tree structure and the conditional independence assumptions that come with the structure. Furthermore, in most cases the latent variables have to be discrete. Up to some rare cases, continuous latent variables are intractable when computing integrals. 

In the context of this thesis, Latent Variable Trees are utilized as a compact representation for complex models where the set of conditional independencies between the (latent) variables is the defining characteristic.

=== Markov Random Fields
Due to the problematic extraction of conditional independencies that characterize a Bayesian Network, Markov Random Fields (MRFs) are introduced.

#definition("Markov Random Field")[
  A Markov Random Field (MRF), als known as Markov Network is a
  model of the joint probability distribution for a given set of random variables $X$.
  An MRF consists of an undirected graph $G = (V, E)$ where every variables is a node in $V$ and every edge represents a direct dependency between the variables.
  The graph is accompanied by a set of factors ${Phi_1,..., Phi_k}$, also called potential functions, for every maximal clique in $G$. The factors represent a not necessarily normalized  probability distribution.

  The joint probability distribution of the entire MRF is given by the normalized product of the factor potentials
  
  $
  p(x) = 1/Z product_k Phi_k ( x_{k})
  $
  where
  $
  Z = sum_(x in X) product_k Phi_k ( x_{k}).
  $
  Note that the sum and integral are interchangeable. $Z$ is the normalization constant of the model and exponentially hard to compute in the number of variables.
]

Bayesian Networks can be converted into MRFs by applying moralization. //TODO source 
The MRFs that represent the same distribution as the Bayesian Networks from @fig:bayesian_network_example and @fig:stupid_bayesian_network_example are shown in @fig:mrf_example and @fig:stupid_mrf_example.
It can be observed that @fig:stupid_mrf_example contains only one maximal clique and hence the factorization that was naively done by the Bayesian Network is not reducing any complexity.


#figure(caption: [An MRF factorizing the distribution of @fig:bayesian_network_example using the same conditional independences.
])[
  #diagram(node-defocus: 0,
	spacing: (1cm, 2cm),
	edge-stroke: 1pt,
	crossing-thickness: 5,
	mark-scale: 70%,
	node-fill: luma(97%),
	node-outset: 3pt,
	node((0,0), "Robot Type"),
	node((0,1), "Object Type"),
	node((1,2), "X"),
	node((-1,2), "Y"),
  edge((0, 0), (0, 1), "-"),
   edge((0, 1), (1, 2), "-"),
   edge((0, 1), (-1, 2), "-"),
 )
]<fig:mrf_example>

#figure(caption: [An MRF factorizing the distribution of @fig:stupid_bayesian_network_example using the same conditional independences.
])[
  #diagram(node-defocus: 0,
	spacing: (1cm, 2cm),
	edge-stroke: 1pt,
	crossing-thickness: 5,
	mark-scale: 70%,
	node-fill: luma(97%),
	node-outset: 3pt,
	node((-1,0), "Robot Type"),
	node((1,0), "Object Type"),
	node((-1,1), "X"),
	node((1,1), "Y"),
  edge((-1, 0), (1, 0), "-"),
   edge((-1, 0), (-1, 1), "-"),
   edge((-1,0), (1, 1), "-"),
   edge((1,0), (-1, 1), "-"),
   edge((1,0), (1, 1), "-"),
   edge((1,1), (-1, 1), "-"),
 )
]<fig:stupid_mrf_example>

When considering the dependencies that are stated in an MRF, one can easily see that an MRF that is structured like a tree contains This property is partly derived from the fact, that in a tree no node has multiple parents and hence no moralization needs to be done.
Intuitively, the bounded tree width of a graph measures the closeness to a tree. In conclusion, the complexity of inference in a PGM is exponential in the bounded tree width of the underlying MRF representing it. @bach2001thin

=== Template Models
While the previous sections highlighted the limitations of PGMs this section focusses on the task where PGMs accelerate in: Visualizing dependencies and dynamically constructing distributions.

Real world processes evolve over time. Modelling a dynamic relation, such as time, is done by applying template models.
For the scope if this thesis, it is assumed that (time) steps in template models are of discrete nature.
A template model consists of a distribution that describes the relationship between variables in one step and a transition model that describes the distribution of variables between two or more time steps.
A very prominent model of this category is a Hidden Markov Model (HMM).

#definition([Hidden Markov Model])[
  A Hidden Markov Model (HMM) is a dynamic Bayesian Network
  containing a hidden state variable $X_t$ and an evidence variables $E_t$. Formally, a HMM contains
  - The initial distribution $P(X_0)$
  - The emission distribution $P(E_t | X_t)$
  - The transition distribution $P(X_t | X_(t-1))$
]<def:hmm>

#figure(caption: [Example of an HMM. The figure depicts a three consecutive time steps within the Bayesian Network structure of an HMM.])[
  #diagram(node-defocus: 0,
	spacing: (1cm, 2cm),
	edge-stroke: 1pt,
	crossing-thickness: 5,
	mark-scale: 70%,
	node-fill: luma(97%),
	node-outset: 3pt,
 node((0,0), $X_(t-1)$),
 node((1,0), $X_t$),
 node((2, 0), $X_(t+1)$),
 node((0, 1), $E_(t-1)$),
 node((1, 1), $E_(t)$),
 node((2, 1), $E_(t+1)$),
 edge((0,0), (1,0), "->"),
 edge((1,0), (2,0), "->"),
 edge((0,0), (0,1), "->"),
 edge((1,0), (1,1), "->"),
  edge((2,0), (2,1), "->"),
  edge((2, 0), (3, 0), "->"),
  edge((-1, 0), (0, 0), "->")
 )
]<fig:hmm_example>

The concept of template models is not limited to time. For instance, a robot that executes a plan in a cognitive architecture may generate actions to execute on the fly. Consider the task sequence depicted in @fig:template_model_transporting.

#figure(caption: [An action sequence that is generated by a transporting plan.])[
  #diagram(node-defocus: 0,
	spacing: (1cm, 2cm),
	edge-stroke: 1pt,
	crossing-thickness: 5,
	mark-scale: 70%,
	node-fill: luma(97%),
	node-outset: 3pt,
 node((0,0), "Navigate"),
  node((1,0), "Pick Up"),
  node((2, 0), "Navigate"),
   edge((0,0), (1,0), "->"),
 edge((1,0), (2,0), "->"),
 )
]<fig:template_model_transporting>

A follow up action may now be to access a location to place the picked up object or to directly place it. As long as both transitions $P("Access" | "Navigate")$ and $P("Place" | "Navigate")$
are known, one can just dynamically extend the distribution by adding the variable and conditional distribution that is generated by the plan executive.
This high level dynamically extensions of distributions is a complicated probabilistic operation that is can best described by a PGM displaying this process.

== Probabilistic Circuits
<sec:probabilistic-circuits>

While PGMs focus on a high level visualization of a distribution, they are not well suited for describing analyzing inference processes. In chapter 12 of the book "Modelling and Reasoning with Bayesian Networks" it was already discussed that BNs, and in general PGMs, are unfit for an actual computation of probabilistic quantities and hence they were converted in arithmetic circuits. @darwiche2009modeling 
@choi2020probabilistic build an entire framework on this idea by taking these arithmetic circuits and interpreting them directly as probability distributions, called probabilistic circuits (PCs).
PCs are probabilistic models that are tractable for large classes of queries. @choi2020probabilistic 
PCs formalize the conditions under wich the queries from @sec:queries are tractable to compute for a model class.
Furthermore, they are the toolbox that enables this thesis to integrate cognitive architectures and probabilistic reasoning in a tractable and yet expressive way.

This section explains the building blocks that are used throughout this thesis and extends the literature by inference algorithms that are insufficiently discussed. This section is largely based on @choi2020probabilistic.

A PC recursively encodes a joint probability distribution in a directed acyclic graph. In contrast to PGMs, the computational graph of a PC is not only a statement about conditional independence, but also a detailed description of the exact calculations that make up the PDF.

The smallest computational graph consists of only one node. 
Hence, this node represents the entire distribution. This distribution unit, also refereed to as input unit, can be multivariate. However it is very common to have univariate input units. There are only very few tractable, multivariate distributions that cannot be described by the PC framework and hence offer an alternative to univariate input distributions. One notable choice here is the multivariate Gaussian (normal) distribution.
Common examples for input units are uniform (example in @fig:uniform_pdf), Gaussian (example in @fig:gaussian_pdf) or Multinomial (example in @tab:combinatoric_explosion) distributions.
// TODO introduce definition of multinomial distribution?
Input distributions are the leaves of the computational graph.
Furthermore, Input distributions are in almost every case not enough to encode a probability distribution that exhibits the desired behavior. Hence, there is a need for more building blocks in the toolbox of PCs. 
The next computational unit that is addressed is the product unit.

#definition([Factorized Models @choi2020probabilistic])[
  Consider the probabilistic model $p$ encoding a distribution over variables $bold(X) = union.big_(i=1)^k X_i$ partitioned into disjoint sets $X_A$ and $X_B$ with $X_A sect X_B = emptyset$. The model is factorized iff
  $
  p(X) = product_(k=1)^i p_i(bold(X_i)) 
  $
  where each $p_i$ is a distribution over the subset of variables  $bold(X_i)$.
  ]<def:fully_factorized>
  
Observe that this again is independence of entire variables, as described in @def:independence. Similar to PGMs, a PC has to have some (conditional) independence assumptions to become a tractable probabilistic model. The simplest class of probabilistic model is the fully factorized distribution, as described in @def:fully_factorized. This corresponds to either only a product unit with only univariate input units as children or a PGM with no edges and only nodes.

// TODO example
Due to the independence property, fully factorized models are strongly limited in their expressiveness on their own. Another unit has to be introduced to enable complex behavior in the PC framework. The next and last ingredient to represent a factorized, but not fully factorized model is the sum unit.

#definition([Mixture Models @choi2020probabilistic])[
  Let ${p_i}_(i=1)^k$ be a finite collection of probabilistic models, each defined over the same collection of variables $bold(X)$. A mixture model is the probabilistic model defined as convex combination 
  
  $
  p(bold(X)) = sum_(i=1)^k theta_i p_i (bold(X))
  $

  for a set of positive weights, called the mixture parameters, $theta_i > 0, i = 1, ... , k$ and \ $sum_(i=1)^k theta_i = 1$.
]<def:mixture>

Mixture models are shown in @def:mixture  and are a well known tool to enhance the expressiveness of probability distributions. 
While a mixture model looks is simple, it is a well established fact that sufficiently large mixtures of multivariate Gaussian distributions can approximate any continuous PDF arbitrarily well. @stergiopoulos2017advanced
This fact underlines the importance and power of weighted sums of distributions in probabilistic modelling. Furthermore, mixtures are always convex combinations of distributions to ensure that the probability of the universal event is unity (fourth axiom in @def:probability_measure)

These three unit types now build up to the definition of a PC. Note that it is important to distinguish between the structure and the parameters of a PC.


#definition([Probabilistic Circuit @choi2020probabilistic])[
A probabilistic circuit (PC) $C$ over variables $X$,
is a pair $(G, theta)$, where $G$ is a computational graph, also called the circuit structure that is parameterized by $theta$, also called the circuit parameters, as defined in @def:pc_structure. The PC $C$ computes a function that characterizes a (possibly unnormalized) distribution p(X).
]<def:pc>

#definition([Structure of a PC @choi2020probabilistic])[
Let $C = (G, theta)$ be a PC over variables $X$. 
$G$ is a computational graph in the form of rooted DAG, comprising computational units, also called nodes. 
The standard evaluation ordering of $G$, also called feedforward order, is defined as follows.
If there is an edge $n -> o$ from unit $n in G$ to unit $o in G$, we say $n$ the input of $o$ and $o$ its output. 
Let $"in"(n)$ denote the set of all input units for unit $n in G$ and equivalently, $"out"(n)$ denotes the set of its outputs. 
The input units of $C$ are all units $n in G$ for which $"in"(n) = emptyset$. 
Analogously, the output unit of $C$, also called its root, is the unit $n in G$ for which $"out"(n) = emptyset$. 
The structure $G$ comprises three kinds of computational units: input distribution units, product units and sum units, to which a scope is associated as formalized in @def:pc_scope.
]<def:pc_structure>

#definition([Scope of a PC @choi2020probabilistic])[
Let $C = (G, theta)$ be a PC over variables $X$. 
The computational graph $G$ is equipped with a scope function $Phi$ which associates to each unit $n in G$ a subset of X, i.e., $Phi(n) subset.eq X$. 
For each non-input unit $n in G, Phi(n) = union.big_(c in "in"(n)) Phi(c)$. The scope of the root of $C$ is $X$.
]<def:pc_scope>

#definition([Computational units of a PC @choi2020probabilistic])[
Let $C = (G, theta)$ be a PC over variables X. 
Each unit $n in G$ encodes a non-negative function $C_n$ over its scope: $C_n : "val"(phi(n)) → RR^+$.

An input unit $n in C$ encodes a non-negative function that has a support $"supp"(C_n)$ and is parameterized by $theta_n$.

A product unit n defines the product 
$
C_n(X) = product_(c in "in"(n)) C_c (X).
$
A sum unit n defines the weighted sum 
$
C_n(X) = sum_(c in "in"(n)) theta_(n,c) C_c(X)
$
parameterized by weights $theta_(n,c) >= 0$.
]<def:pc_computational_units>

#definition([Parameters of a PC @choi2020probabilistic])[
The set of parameters of a PC C is $theta = theta_S union theta_L$ where $theta_S$ is the set of all sum weights $theta_(n,c)$ and $theta_L$ is the set of parameters of all input units in C.
]<def:pc_parameters>

Consider the PC in figure TODO COOL EXAMPLE.

== Inference

This section describes the detailed calculation of the quantities in @sec:queries. While the theory behind the tractability of the queries is provided by @choi2020probabilistic, this section contributes detailed algorithms that apply the theory in a practical manner.

The algorithms to perform inference are similar between the different query types. Many algorithms require at some point the calculation of the layers of a circuit. The layers of a circuit are defined by all nodes that are at a certain distance from the root of the circuit. The distance is measured by the number of edges that have to be traversed to reach the root. The layers of a circuit are calculated by the bread-first search algorithm. @SciPyProceedings_11

Figure TODO illustrates the layers of a circuit.

The inference algorithms introduced in this chapter use a special field called _result_of_current_query_ that stores the result of the current query for every node of the circuit.

Every non-input unit of the circuit is equipped with the forward method which is shown in @alg:pc_forward.


#figure(
    algo(
            title: "Forward Pass of a unit.",
            parameters: ($n$, ),
            init: (
                (
                    key: [Input],
                    val: (

                        [$n$, a non-leaf unit in a PC.],
                    )
                ),
                (
                    key: [Output],
                    val: ([The likelihood of the event ($p(x)$).],)
                )
            ))[
 *If* unit.is_sum: #i \ 
 unit.result_of_current_query = $sum_(c in "in"(n)) theta_(n,c) c."result_of_current_query" $ #d  \
*If* unit.is_product: #i
    \   unit.result_of_current_query = $product_(c in "in"(n)) c."result_of_current_query" $ #d
    ],
    caption: [
        #smallcaps([Forward]): The forward pass for sum and product units in probabilistic circuits.
    ],
    kind: "algorithm",
    supplement: [Algorithm]
)<alg:pc_forward>

=== Likelihood

The calculation of the likelihood of a fully instantiated world is straight forward in PCs. At every leaf node, the distribution contained by the leaf is evaluated for it's density at the variable described by it. At the sum units, the convex sum of the input units is evaluated. At the product units the results of the children are multiplied. Since the definition of a PC omits any kind of complex transformations of probabilities, such as the change of variables, it is not required to take into account any more complex calculations. 
One only has to take care of the normalization of PCs. The theory does not forbid the creation of sum units that do not sum to unity. 
Fortunately, a circuit is always normalized if all sum units weights sum to one. @choi2020probabilistic
Hence, correct inference can be assured by extending the calculation of results in sum units to
$
C_n(X) = (sum_(c in "in"(n)) theta_(n,c) C_c(X)) / Z,
$
where
$
Z = sum_(c in "in"(n)) theta_(n,c)
$

is the local normalization constant of a sum unit. This is especially important when gradient based optimization is applied on a circuit, where the updating of the PCs parameters may destroy the unity-constraint.
While at it, a very good trick to also ensure non-negativity and numerical stability in gradient based processes is to rephrase the sum units using the logarithmic space. @liu2024scaling In this logarithmic representation the sum unit is expressed as
$
C_n(X) = (sum_(c in "in"(n)) exp(theta_(n,c)) C_c(X)) / Z,
$
where
$
Z = sum_(c in "in"(n)) exp(theta_(n,c))
$
which ensures non-negativity due to the properties of the exponential transformation. Algorithm TODO shows the pseudo-code to solve the likelihood query.

#figure(
    algo(
            title: "Likelihood Query in a PC",
            parameters: ($p, X$, ),
            init: (
                (
                    key: [Input],
                    val: (

                        [$p$, a probabilistic circuit],
                        [$X$, A full evidence state.],
                    )
                ),
                (
                    key: [Output],
                    val: ([The likelihood of the event ($p(x)$).],)
                )
            ))[
*For* layer in pc.layers: #i
    \ *For* unit in layer: #i
    \  *If* unit.is_leaf: #i 
    \ unit.likelihood(event) #d 
    \ *Else*: #i
    \  unit.forward() #d#d#d\
  *Return* p.root.result_of_current_query
    ],
    caption: [
        #smallcaps([Likelihood]): The algorithm to calculate the likelihood of a full evidence query in a PC.
    ],
    kind: "algorithm",
    supplement: [Algorithm]
)<alg:pc_likelihood>


=== Marginalization

The next query class is the class of marginal queries. In the scope of this thesis, marginal queries are all queries that require integration over a simple event of the product algebra (recall from @def:marginal-query).

Solving multivariate integrals is proven to be P-space hard, and hence it is no wonder that most probabilistic models are unable to answer such queries exactly, if even at all. @dyer1988integration
PCs are able to calculate integrals over boxes by ensuring a structural constrained called decomposability. 

#definition([Decomposability @choi2020probabilistic])[
  A product node $n$ is decomposable if the scopes of its input units do not share variables: 
  $
    phi(c_i) sect phi(c_j) = emptyset, forall c_i, c_j in "in"(n), i != j.
  $

A PC is decomposable if all of its product units are decomposable.
]

While decomposability is nice for marginal inference, it comes at the prices of expressiveness. There are relationships between variables that cannot be captured but only approximated by circuits, such as linear dependence ($X = a Y + b$). (TODO CITE?)
In this, one of the objectives is to do probabilistic reasoning over the behavior of robots. Since PyCRAM formalizes the thinking process in a computer program, the information that is available to the robot at execution is already transformed into a usable form. Hence, it is unlikely that relationships are needed that cannot be sufficiently approximated by a decently sized circuit.

The second requirement for marginal inference is smoothness of sum units.

#definition([Smoothness @choi2020probabilistic])[
A sum node $n$ is smooth if its inputs all have identical scopes: 
$
phi(c_i) = phi(c_j), forall c_i, c_j in "in"(n).
$
A circuit is smooth if all of its sum units are smooth.
]

Smoothness is not as limiting as decomposability. Every decomposable, but non-smooth circuit can be converted to a smooth circuit in polynomial time.  @choi2020probabilistic

@choi2020probabilistic introdcues the following construction to convert a decomposable non-smooth PC to a smooth and decomposable PC.
Suppose $C_2$ is a decomposable non-smooth PC over variables $X$. 
Then a smooth and decomposable PC $C_1$ can be constructed from $C_2$ as the following. 
For every non-smooth sum unit $n$, we replace each of its inputs $c$ with a product unit $c′$  that takes as input $c$ and newly introduced input distribution units $"IU"(X)$ for every variable $X in phi(n)$ that is not in the scope of $c$. @choi2020probabilistic

$
  c′ = c dot product_(X in phi(n) without phi(c)) "IU"(X)
$

@choi2020probabilistic argues that for finite domains this distribution is the uniform distribution over the domain of $X$. 
While this is correct and completely sufficient for practical uses, it does not cover the case of infinite domains which are often found in continuous variables. In such cases one would have to introduce an uninformative, improper prior which is out of scope for this thesis. However, this construction remains meaningful, especially if one takes into account the parameterization of actions with different variables in a robot's cognitive architecture.


Finally, calculating the marginal probability of an event in a smooth and decomposable PC is then very similar to algorithm TODO. The only difference is that the input units have to be able to calculate the probability of the event they are assigned to. Fortunately, most univariate distributions are tractable for integration.
Furthermore note that this discussion is only about a simple event of the product algebra. For a composite event the cost of marginal inference is linear in the number of simple events enclosed by the composite event. Recall that decomposability does not state anything for the calculation of the marginal probability of an event that is not part of the product algebra.

=== Conditioning

One part of the calculations in conditioning is the integration over sets of the product algebra. This is exactly equal to the calculation of marginal queries in general and hence also requires smoothness and decomposability. 
However, the calculation of the probability of the condition is only part of the answer. The other part is provided by the entire distribution of the evidence. In PCs, this requires changes to the nodes and structure of the circuit which is additional effort.
The algorithm to calculate the conditional probability is shown in algorithm TODO.
The restructuring of non-leaf nodes is a subject of checking the reachability from the (new) root of the circuit.
The changes to the leaf nodes are done by truncating the input distribution units to the evidence.

=== Mode

In 1994 it was already proven that the calculation of the mode in a probabilistic model is generally an NP-Hard problem. @shimony1994map
Hence, the calculation of the mode in a probabilistic circuits is also only tractable if there are some structural constraints. The constraints are consistency and determinism. @choi2020probabilistic

#definition([Determinism @choi2020probabilistic])[
A sum node is deterministic if, for any fully-instantiated
input, the output of at most one of its children is nonzero. A circuit is deterministic if all
of its sum nodes are deterministic.
]

Determinism can be considered as a partitioning of the underlying sigma algebra. Note that, in contrast to smoothness and decomposability, this constraint is concerned with the outputs of nodes instead of their scopes. It has been shown that these three properties are sufficient to ensure tractability of the mode query. @chan2012mpe

@choi2020probabilistic showed that while decomposability, smoothness and determinism are sufficient to ensure tractability of the mode query, they are not necessary. They introduced consistency and showed that a circuit that is consistent and deterministic is also tractable for the mode query.

#definition([Consistency @choi2020probabilistic])[
A product node is consistent if each variable that is shared between multiple children nodes only appears in a single leaf node, in the subcircuit rooted at the product node. A circuit is consistent if all of its product nodes are consistent.]

While this constraint is strictly weaker than decomposability and hence a valuable contribution I have yet to meet a practical example where a consistent but not decomposable circuit is used.

Algorithm TODO shows the pseudo-code to solve the mode query for deterministic circuits.

=== Sampling

Describing sampling in PCs is best done by relating them to Latent Variable Trees. This requires a key interpretation of sum units, the laten variable interpretation.
A sum unit can be interpreted as a marginalized latent variable that has as domain the index set of the children of a sum unit. This interpretation was first introduced in the context of Sum Product Networks (SPNs). @poon2012spnda 
Figure TODO visualizes this transformation.
As pointed out by @peharz2016latent this interpretation destroys the smoothness of a circuit. The problem was solved by introducing distributions over the latent variables in other sum units. 
However, for sampling it is sufficient to sample the latent variable of a sum unit without considering it in the scopes of other sum units. Algorithm TODO shows the pseudo-code to sample from a PC. Sampling also requires a smooth and decomposable circuit.

== Sum Product Networks

Sum Product Networks are an alternative representation of probabilistic circuits. They were introduced in 2012 and are a the spiritual predecessor of probabilistic circuits. @poon2012spnda 

#definition([Sum Product Network @poon2012spnda])[
Definition 1 A sum-product network (SPN) over variables
$x_1, ...,x_d$ is a rooted directed acyclic graph whose leaves are the indicators $x_1,..., x_d$ and  $!x_1.,..., !x_d$ and whose internal nodes are sums and products. Each edge $(i, j)$ emanating from a sum node $i$ has a non-negative weight $w_(i j)$.
The value of a product node is the product of the values of its children. The value of a sum node is 
$sum_(j in "Ch"(i)) w_(i j) v_j $, where $"Ch"(i)$ are the children of $i$ and $v_j$ is the value of
node $j$. 
The value of an SPN is the value of its root.
]<def:spn>

Comparing the definition of a probabilistic circuit (@def:pc) and a sum product network (@def:spn), one can see that the only difference is in the definition of input units. While PCs have input units that are distributions, SPNs have input units that are indicators. This is a very minor difference and has been relaxed to also allow distributions as input units in SPNs. @paris2020spnsurvey

Due to their similarity they also define similar properties. This thesis keeps the alphabetic soup small by sticking to the circuit vocabulary. However, the algorithms and properties used in this thesis can be directly applied to SPNs. 

== Learning

In most machine learning scenarios, the distribution of the data is unknown. Learning a distribution is then usually done by assuming a functional form (structure) and fitting the parameters of the function to the data as discussed in @sec:maximum_likelihood_principle. This is called parametric learning.
However, coming up with a parameterized equation in the first place is it's own problem. An alternative approach is the non-parametric learning, where a distribution is learned without assuming a functional form. In terms of probabilistic circuits, this is done by learning the structure of the circuit. 

There exist many approaches to learning in probabilistic circuits. This section introduces the most prominent ones before contributing a univariate learning algorithm in @sec:nyga_distribution and a multivariate learning algorithm in @sec:jpt.

Formally, parameter learning consists in finding the optimal parameters for a circuit given its structure and a dataset. This is further divided in generative and discriminative learning. Generative learning is the done use the MLE principle. Discriminative learning is done by maximizing the conditional likelihood of the target variables. This is usually denoted by applying MLE to a distribution that has the form $P(bold(Y) | bold(X))$ where $bold(Y)$ are the target variables and $bold(X)$ are the features. The features are often but not always limited to vectors, i. e. $X in RR^n$.
Parameter learning is often done by some variant of gradient descent where the partial derivative of the parameters of the circuit are calculated with respect to the MLE and then moved towards zero. @paris2020spnsurvey However, probabilistic models are often numerical instable, even in the log domain, since the likelihood of high dimensional data is often too small such that the numerical precision of computers cannot represent it without underflowing.

A prominent trick to stabilize the learning process is the application of Log-Sum-Exp trick at sum nodes. The Log-Sum-Exp trick is a numerical trick to calculate the sum of exponentials in the log domain where the logarithmic values are shifted towards a more stable numerical range before they are added. After that they are shifted back to the original range. @liu2024scaling

Parameter estimation developes largely independent of the domain of probabilistic models since it is a general optimization tool.

On a site note, the parameters of every smooth, decomposable and deterministic circuit can be obtained in closed form. They consist of the frequency of the partitions of the sum nodes children in the data and the parameters of the input units. @peharz2014learning

A notable competitor to the gradient descent based learning is the Expectation Maximization (EM) algorithm. The EM algorithm is a two step algorithm that iteratively maximizes the likelihood of the data. The first step is the expectation step where the expected value of the latent variables is calculated. The second step is the maximization step where the parameters of the circuit are updated. The EM algorithm is especially useful when the data is incomplete. @paris2020spnsurvey

Structure learning can be defined as the task of creating the structure, and possible also the parameters of a circuit, given a dataset.

A very prominent structure learning algorithm for tree structured graphical models is the Chow-Liu algorithm. The Chow-Liu algorithm is a maximum likelihood algorithm that constructs a tree structured bayesian network by finding the maximum likelihood tree that represents the data. This is done by calculating the mutual information (@def:mutual_information) between each pair of variables and then iteratively select the pair with the highest information gain that does not create a cycle to the model. @chow1968approximating

#definition([Mutual Information @chow1968approximating])[
The mutual information between two discrete variables $X$ and $Y$ is given by

$
  I(X, Y) = sum_(x in "dom"(X)) sum_(y in "dom"(Y)) p(x, y) ln (p(x, y) / (p(x) p(y))).
$

]<def:mutual_information>

The first structure learning approach in the context of SPNs, called BuildSPN, was proposed in 2012. @dennis2012buildspn BuildSPN recursively searches for subsets of strongly dependent variables and introduces sum units to resolve those dependencies. This process is repeated with taking the latent variables generated by the sum units into account.
Since BuildSPN was designed for image processing this local dependency definition is well chosen.
Limitations of this algorithm are the potential separation of highly dependent variables, the potential exponential time and space complexity of the search and the requirement to learn the parameters of the model separately. @paris2020spnsurvey

The next generation of structure learning was the LearnSPN algorithm. @gens2013learning 
In contrast to BuildSPN, LearnSPN is an algorithm template which is depicted in @alg:learnspn.
LearnSPN depends on the way a univariate distribution is estimated, how the independent subsets are generated and how the instances are clustered into similar subsets.
@gens2013learning realized the algorithm using a Hard-EM approach for clustering instances. The univariate distributions where all discrete ones since the dataset has been discretized for all experiments. Variable splits are done via the G-tes for pairwise independence as defined in @def:gtest, which is very similar to the mutual information criterion.

#definition([G-Test for Pairwise Independence @woolf1957log])[
The G-Test for pairwise independence is given by 
$
  G(X_1, X_2) = 2 sum_(x_1 in "dom"(X_1)) sum_(x_2 in "dom"(X_2)) c(x_1, x_2) 
  ln ((c(x_1, x_2) dot |T|) / (c(x_1)c(x_2))),
$
where $c(·)$ counts the occurrences of a setting
of a variable pair or singleton.
]<def:gtest>

#figure(

    algo(
            title: [LearnSPN],
            parameters: ($T, V$, ),
            init: (
                (
                    key: [Input],
                    val: (
                        [$T$, A set of instances],
                        [$V$, A set of variables],
                    )
                ),
                (
                    key: [Output],
                    val: ([A PC representing a distribution over V learned from T],)
                )
            )
        )[
*if* $|V|$ = 1: #i\ 
*return* univariate distribution estimated from the variable's values in $T$ #d \
*else*: #i \
partition $V$ into approximately independent subsets $V_j$ \
*if* success: #i \
*return* $product_j "LearnSPN"(T, V_j)$  #d \
*else* #i \
partition $T$ into subsets of similar instances $T_i$\
*return* $sum_i = (|T_i|) / (|T|) "LearnSPN"(V, T_i)$ #d #d 
    ],
    caption: [
        #smallcaps([LearnSPN]): A template algorithm to learn the structure of a probabilistic circuit. This algorithm is adopted from @gens2013learning to match the nomenclature of circuits.
    ],
    kind: "algorithm",
    supplement: [Algorithm]
)<alg:learnspn>

In 2014 @rooshenas2014idspn proposed a structure learner called ID-SPN that combines direct and indirect variables interactions. The authors argue that ID-SPN achieves better accuracy than state of the art algorithms for learning SPNs and other tractable models. ID-SPN is similar to the LearnSPN algorithm but it may chose to terminate before reaching a univariate distribution and learn a tractable (tree-shaped) Markov Network without hidden variables instead. This Markov Network is then compiled to a SPN and mounted at the parent node. @rooshenas2014idspn  

@peharz2014learning adapted LearnSPN to only produce deterministic circuits and showed that this is still competitive w. r. t. to the likelihood.
@adel2015learning developed a structure learning process that uses (Singular Value Decomposition) to find independent sub-matrices in the data.
There have been many more alternations to LearnSPN and ID-SPN but most of them add minor improvements to the algorithms. @paris2020spnsurvey

Current state of the art in machine learning developes a lot around deep learning. Deep learning is characterized by the use of massively over-parameterized models that are trained with gradient descent.
It is to no surprise that this direction was then also recently explored for probabilistic circuits. @peharz2020random proposed a method called Random and tensorized SPNs (RAT-SPN).
RAT-SPN is a deep probabilistic model that creates a random structure for a PC. This random structure is induced by a random decomposition of the variables. This random decomposition is repeated in multiple ways such that the final model is a mixture of random LV-Trees. The discrete latent variables are then parameterized by random distributions with a given arity.
The resulting PC is a DAG where every inner unit has multiple parents. 
The parameters of the model are then learned by gradient descent. The authors show that the model is competitive with state of the art deep learning models on a variety of tasks. Surprisingly, it even kept up with intractable probability distributions in terms of likelihood while still being tractable. @peharz2020random
Another important addition is the concept of tensorization of a PC. Tensorization is a way to represent a PC as a tensor network which is a more compact representation of the DAG underlying a PC. Furthermore, this tensor network is compatible with modern computer architectures and hence speeds up the inference process. Tensorization is discussed in @sec:layering.
The newest approach to learning PCs is the Probabilistic Integral Circuit (PIC). @gala2024pic learn a PC that imitates an intractable probability distribution. First, a LV-Tree is learned that uses continuous latent variables and hence is intractable for every operation but the calculation of the likelihood. This intractable model is then abstracted by a PC the represents the quadrature integral over the intractable model. This is done by again using a RAT-SPN and parameterize it with values from the intractable model. The authors claim that PICs outperform PCs trained via Expectation-Maximization or gradient descent.  

Recent literature uses high dimensional data to evaluate the performance of probabilistic models. This is due to the fact that high dimensional data is often not well represented by traditional models and the advantage of deep probabilistic models really shows.
However, the problems in this thesis are rather low dimensional and hence the performance of the models is not the main focus. The main focus is the tractability of the models and the ability to reason about the data using probability theory. 

PC & SPN RESEARCH DIAGRAM.


=== Nyga Distribution
<sec:nyga_distribution>

This section describes how to learn a model free, univariate distribution called Nyga Distribution. Formally, a Nyga Distribution is a way to learn a deterministic mixture of uniform distributions. This distribution can for instance be used in line 2 of LearnSPN (@alg:learnspn).  

Historically, the concept of a similar distribution to the Nyga distribution was first introduced in a paper by Daniel Nyga @nyga2023joint. Daniels’ creation was the so-called quantile distribution. Back in the day, it was not connected to circuits or a maximum likelihood estimation. The idea was to create a distribution that is able to approximate any continuous distribution without any assumptions about its structure. Daniel used the mean squared error between the learned quantile function and the empirical CDF. However, this sometimes leads to undesired results, especially with containing jumps in the distribution or completely missing parts of the distribution. 

A further contribution of this thesis is the exact maximum likelihood estimation of the process. The solution is detailed in @sec:nyga_distribution_learning.

==== Learning
<sec:nyga_distribution_learning>

Nyga distributions are learned by greedily maximizing the weighted log-likelihood (see #ref(<def:mle>)).

When the uniform distribution is assumed for the data, the weighted log likelihood is given by

$
ln (W L(theta, W))  &= sum_(i=1)^N ln(w_i) + ln(p(D_i | theta)) \
&=  sum_(i=1)^N ln(w_i) + ln(1/(b-a)) \
&=  sum_(i=1)^N ln(w_i) -  sum_(i=1)^N  ln(b-a).
$

Since the density of the uniform distribution is constant, the weighted log likelihood can be restated as

$
ln (W L(theta, W)) = (sum_(i=1)^N ln(w_i)) -  N ln(b-a).
$
which is particularly easy to calculate.
In case of a mixture of two uniform distributions, the likelihood is given by

$
p(x_i) = w_"left" dot U_"left" + w_"right" dot U_"right"
$

where the _left_ and _right_ subscripts are indicators for a mixture component that describes the respective part of the distribution. The Nyga distribution solves the MLE by using a recursive partitioning scheme.
For this recursive scheme, the induction has to be applied to a sorted and unique datasets.


Let $D$ be a sorted and unique dataset of $N$ samples $x_1, ..., x_N$ where $x_i in RR$.

The data is in each induction step partitioned into two disjoint sets
$
D_"left" &= d_1, ..., d_k\
D_"right" &= d_(k+1), ..., d_N.
$

The data is split along the distance maximizing point 
$
d_"split" = (d_k + d_(k+1)) / 2.
$ 

The likelihood of such a split is given by assuming a uniform distribution on the left and right side of the split.
This constructs a deterministic mixture of uniform distributions where the weights are given by the relative sum of weights on the left and right side of the split.

$
w_"total" &= sum_(i=1)^N w_i \
w_"left" &= (sum_(i=1)^k w_i) / w_"total" \
w_"right" &= (sum_(i=k+1)^N w_i) / w_"total"
$

The density of the mixture is hence given by
// TODO this equation misses an indicator
$
p(x) &= w_"left" dot U_"left" + w_"right" dot U_"right" \
&= w_"left" / (d_"split" - d_1) +  w_"right" / (d_N - d_"split") 
$

The determinism allows simplifying the likelihood calculation for all samples in the left split to just 

$
p_"left" (x) &=  w_"left" dot U_"left" + w_"right" dot underbrace( U_"right", = 0)\
ln(p_"left" (x)) &= ln(w_"left") - ln(d_"split" - d_1).
$
Analogously, for the right side it is 
$
ln(p_"right" (x)) &= ln(w_"right") - ln(d_N - d_"split").
$

Furthermore, it can be observed that the density is constant for every sample in the left split and constant for every sample in the right split.
Plugging it in, the likelihood for the split is given by

$
ln(L(D|W, d_1, d_"split", d_N)) &= sum_(i=1)^N ln(w_i) + ln(p(x_i))\
&=  sum_(i=1)^"left" ln(w_i) + ln(p(x_i)) + sum_(i="right")^N ln(w_i) + ln(p(x_i))\
&=  sum_(i=1)^"left" ln(w_i) + ln(w_"left" dot p_"left" (x_i)) + sum_(i="right")^N ln(w_i) + ln(w_"right" dot p_"right" (x_i))\
&=  underbrace(sum_(i=1)^"left" ln(w_i) + ln(w_"left") + ln(p_"left" (x_i)), "Left Hand Side (LHS)") + underbrace(sum_(i="right")^N ln(w_i) + ln(w_"right") + ln(p_"right" (x_i)), "Right Hand Side (RHS)")\
"LHS" &= L dot (ln(w_"left") + ln(U_"left")) + sum_(i=1)^"left" ln(w_i) \ 
"RHS" &= R dot (ln(w_"right") + ln(U_"right")) + sum_(i="right")^N ln(w_i).
$

The most likely split is selected, and the process is repeated recursively on the left and right side of the split.

If the likelihood improvement of the best split, compared to no splitting, is smaller than a given threshold, the process is terminated. The likelihood to compare against is given by the weighted log likelihood of a uniform without splitting, i.e.

$
ln(L(D | W, d_1, d_N)) = sum_(i=1)^N ln(w_i) - N ln(d_N - d_1).
$

The best threshold is given by selecting the maximum weighted likelihood improvement over all possible splits. The improvement value is given by

$
max(ln(L(D|W, d_1, d_"split", d_N))) > ln(epsilon) + ln(L(D | W, d_1, d_N)).
$

In simpler terms, the induction is terminated as soon as the likelihood does not improve by more than $epsilon$ percent anymore if a split is made. This parameter is referenced to as minimum likelihood improvement.

The algorithm is particular efficient since it essentially relies on summing ranges in a sorted array. This can be done once before the induction and then reused in every step. The pseudo code for the algorithm is depicted in @alg:learn_nyga.
A fully documented, tested and efficient implementation can be found in the python package that was implemented for this thesis. TODO REFERENCE

#figure(

    algo(
            title: [Nyga Distribution],
            parameters: ($D, W, S, epsilon$, ),
            init: (
                (
                    key: [Input],
                    val: (
                        [$D$, A set of instances],
                        [$W$, A list of weights for the instances],
                        [$S$, The minimum size of a partition],
                        [$epsilon$, The minimum likelihood improvement required to justify another split.],
                    )
                ),
                (
                    key: [Output],
                    val: ([A Nyga Distribution approximating a univariate distribution learned from T],)
                )
            )
        )[
          create a sum unit as root \
          find the best split\
          *if* the best split is below the threshold or the partition size is smaller than $S$: #i\
           create a uniform distribution over the data\
          add it to the root with weight equal to the sum of weights #d \
          *else:* #i\
          split $D$ and $W$ at $i$ and repeat from step 2 #d\
    ],
    caption: [
        #smallcaps([Nyga Distribution]): An inductive learning algorithm to learn a model free deterministic mixture approximating any univariate distributions.
    ],
    kind: "algorithm",
    supplement: [Algorithm]
)<alg:learn_nyga>


TODO EXAMPLE

=== Joint Probability Trees
<sec:jpt>

While the previous section described a way to induce a univariate continuous distribution a great challenge still persists. Most real world applications involve multiple variables the question arises on how to generalize such a concept onto multivariate, model-free distributions. 

In 2020, Daniel Nyga started to think about what happens to decision trees when you take away more and more features. @nyga2023joint A decision tree usually solves a discriminating task

$
arg max_y P(Y|X),
$
where $X = <x_1, ..., x_d>$ is some feature vector and $Y$ is a variable which value should be predicted from $X$.

Decision Trees partition the feature-space and assign the mode of Y to each partition. For a full feature vector, this kind of inference will always result in exactly on partition, where the prediction can be made. @fuernkranz2010encyclopedia @wu2008top

As soon as features are missing, multiple partitions are possible. Hence, a mixture like voting is done. The first enhancement to this voting was to weight the votes of the partitions by the marginal probability of being in such a partition. These probabilities can easily be obtained during learning by the frequencies of each partition in the training data. However, not every partition is equally likely under arbitrary values. Hence, the partitions were further enhanced by independent, univariate distributions in for each variable in each partition. For discrete variables, frequencies easily get these distributions again. The final problem was the functional form of the continuous distributions. Due to the infinite support of Gaussian distributions, these were unfeasible for finite partitions. Furthermore, not every variable is normally distributed. The flexible answer to this problem was the Nyga distribution (@sec:nyga_distribution_learning).
Without knowing it, Daniel had forged a robust, fast and scalable probabilistic circuit that is compatible with the schema of LearnSPN.

This section connects JPTs to probabilistic circuits and goes through the properties guaranteed by a them.
In PC terminology, JPTs are smooth, decomposable and deterministic circuits, enabling them to answer all queries presented in @sec:queries. 

==== Learning

The JPT learning algorithm is an inductive algorithm to create the structure and parameters of a probabilistic circuit that is similar to the C4.5 algorithm. JPTs create a mixture of fully factorized distributions.
This is done by recursively dividing the dataset into partitions where either a threshold is met that limits the number of parameters the circuit may have or where the mutual information gain is so weak that the variables can be regarded as independent. 
The created partitions are all described by axis aligned splits of the underlying space. 
The information gain given a split of the space is given by the variance for numeric variables and the Gini impurity for symbolic variables. @nyga2023joint

The JPT algorithm can be described as a variant of the LearnSPN algorithm and is shown in @alg:jpt. 
The algorithm is particular efficient due to the way the c4.5 algorthim find the best split. @sani2018computational analyzed the complexity of the c4.5 algorithm and argued that the runtime is dominated by $O(|V| dot |T| dot log_2(|T|))$. Since JPTs only alter the calculations by meauring the impurity on all variables instead of just one, the runtime is still dominated by this term. TODO VERYFY. 

#figure(
    algo(
            title: [JPT],
           parameters: ($T, V$, ),
            init: (
                (
                    key: [Input],
                    val: (
                        [$T$, A set of instances],
                        [$V$, A set of variables],
                    )
                ),
                (
                    key: [Output],
                    val: ([A JPT representing a distribution over V learned from T],)
                )
            )
        )[


find the best split from the data using C4.5\ 


*if* the best split is not reducing impurity by more than the threshold: #i\ 
*for* $v$ in $V$: #i\
  *if* $v$ is continuous: #i\
    *return* Nyga Distribution over $v$ estimated from $T[:, v]$#d \
  *else*: #i\
    *return* histogram calculated from $T[:, v]$ #d#d#d\
*else:* #i\
recurse on the subsets of the data obtained by splitting on the best split 
    ],
    caption: [
        #smallcaps([JPT]): An inductive learning algorithm to learn a model free deterministic mixture approximating any multivariate distributions.
    ],
    kind: "algorithm",
    supplement: [Algorithm]
)<alg:jpt>


An example of the result of the splitting is shown in figure @fig:jpt_example

#figure(caption: [Example of a JPT fitted on a mixture of multivariate Gaussian distributions with two components. The points represent the input data and the lines the decision criteria chosen by the learning algorithm. ])[
 #image("../images/jpt_example.png")
]<fig:jpt_example>

==== Properties

Due to the  learning algorithms schema, a JPT always results into a probabilistic circuit that has as a root a sum unit. The root has only product units as children that fully decompose. These product units have either discrete distributions or Nyga distributions as children. 
It follows, that every JPT learned over a set of variables, is structured decomposable with every other JPT over these variables. Furthermore, the partitioning of the dataset using axis aligned splits together with Nyga Distributions ensures determinism and hence enables the efficient calculations of the mode. 
Nyga Distributions are also deterministic since they rely on an inductive splitting algorithm and hence the entire circuit is guaranteed to be deterministic.
Marginal determinism is not guaranteed but can be ensured for a fixed set of variables not allowing splits dependent on the variables one wants to marginalize over. This matter especially for deterministic sequence models using the JPT learning algorithm.

Furthermore, an outstanding property of JPTs and Nyga Distributions is that they are model free abd have a log-linear training time. The way JPTs decompose makes them almost shallow. This is in contrast to deep probabilistic models like RAT-SPNs. For a JPT the shallow transformation takes only TODO time. This furthermore enables an efficient computation of the $L_1$ metric between two JPTs. 
The fact that JPTs only have one multivariate latent variable  at the root that captures the dependencies enables them to be used in a template models like dynamic bayesian networks.
TODO LATENT VARIABLE TREE OF A JPT.

JPTs have a finite support even on continous domains. Finite supports on continous domains are, to the best of my knowledge, never used in the literature so far. This is neither a disadvantage nor an advantage but a property that is worth noting. Finite support renders regions of the elementary events impossible. This affects the generality of a model. It especially complicates the comparison of JPTs using a test set. If a test set is not in the support of the JPT, the likelihood is zero and hence the test likelihood of all datapoints according to the MLE is also zero. The advantage of this is the ability to use JPTs in safety critical applications. For instance, the agent could pose a query to the model where he wants to do something dangerous, like driving into a wall and hence damaging itself. The model would then return a zero probability for that action which can be interpreted as "do not ever do that". Noteably, this feature is not unique to JPTs since every tractable model can be truncated to a finite support. However, finding a support that is ensuring the safety constraints is a non-trivial task. JPTs offer the advantage of extracting a support from the data. 

=== Layering
<sec:layering>

Modern computer architectures feature hardware components that are optimized for tensor operations such as Grahpics Processing Units (GPUs), Tensor Processing Units (TPUs) and vectorized instructions on CPUs which can be operated with Single Instruction-Multiple Data (SIMD) instructions. 

The purpose of such instructions is to apply the same operation to multiple data points at once. For instance, two sum units use the same instructions but on possible different weights and inputs. Hence, there has been some research on how to design PCs that benefit from these instructions.

The most prominent approach is the layering of a PC. @liu2024scaling, @peharz2020random
Layering is a way to group operations into layers that benefit from these SMID instructions. The layers are created by a topological sort of the nodes in the circuit. The nodes are then grouped by their depth, operation and scope. Nodes with the same depth, operation and scope are grouped into a layer. The layers are then connected by edges that describe the operation between the layers. For instance, a product layer is connected to a sum layer by a matrix that describes the connections between the nodes. This matrix is a boolean matrix where every element $(n, m)$ describes if node $n$ is connected to node $m$. For sum layers, the elements describe the weights of the edges and hence it is a float tensor. For instance, a layer that connects three sum nodes to two product nodes has an edge matrix with shape $3 times 2$.
Both @liu2024scaling and @peharz2020random implement such layers using dense matrices. Dense matrices are matrices where every element is present. This is in contrast to sparse matrices where only the non-zero elements are present. Sparse matrices are especially useful when the number of connections is small compared to the number of possible connections. This can be the case for most PCs.
Furthermore @liu2024scaling showed that this layering approach is compatible with modern computer architectures. The authers implemented a system that even goes beyond SMID instructions and uses a custom hardware kernel achieving a speed up of one to two orders of magnitude. Unfortunately, the custom hardware kernels are only applicable to a very limited set of computers, namely those which are Ubuntu 18.04 and have a Nvidia GPU with the correct version of Cuda.

=== Implementation

Before discussing different implementations it is worth taking some time to discuss the topic of requirements.
The ecosystem in which the results of this thesis are employed requires an implementation that has a python interface. 
Furthermore, all query types that are discussed in @sec:queries have to be implemented or at least an implementation of such operations has to be supported by the architecture of the system. 
Next, Gaussian, truncated Gaussian, uniform, integer and multinomial distributions have to be supported. Also structure learning algorithms such as JPT and Nyga Distributions are required. 
Finally, the implementation needs to be accessible, documented and tested and has to be time and space efficient.

In the recent years a couple of implementations appeared on GitHub with varying quality.
This thesis only discusses the implementations that have a considerable set of features. While there are many repositories that contain minor, untested and undocumented fragments of code that, most likely, describe some special forms of inferences, this chapter focusses on the major implementations.

The implementations discussed in this thesis are SPFlow, Juice, PyJuice, SPPL, LibSPN, Einsum Networks, and the newest addition cirkit.

#rotate(270deg, reflow: true)[
#figure(caption: [Quality of implementation of PCs.])[
#table(
  columns: (auto, auto, auto, auto, auto, auto, auto, auto,auto,),
  inset: 10pt,
  align: horizon,
  table.header(
    [Repository], [Test Coverage], [Documentation Coverage], [Python Interface], [Supported Query Types], [Supported Distributions], [Custom Structure Learning], [Time Efficient], [Space Efficient]), 
    [SPFlow], [TODO], [TODO], [Yes], [TODO], [TODO], [TODO] , [TODO] , [TODO],
    [Juice], [TODO], [TODO], [No], [TODO], [TODO], [TODO] , [TODO], [TODO],
    [PyJuice], [TODO], [TODO], [Yes], [TODO], [TODO], [TODO] , [TODO], [TODO],
    [SPPL], [TODO], [TODO], [Yes], [TODO], [TODO], [TODO] , [TODO], [TODO],
    [LibSPN], [TODO], [TODO], [Yes], [TODO], [TODO], [TODO] , [TODO], [TODO],
    [Einsum Networks], [TODO], [TODO], [Yes], [TODO], [TODO], [TODO] , [TODO], [TODO],
    [cirkit], [68%], [TODO], [Yes], [TODO], [TODO], [TODO] , [TODO], [TODO],
)] <table:pc-frameworks>]

The next contribution of this thesis is the implementation of probabilistic models and especially probabilistic circuits in a python implementation. The python package is called   "probabilistic_model" (PM). The implementation is open source and hosted on GitHub. It features a documentation coverage of TODO and a test coverage of (90%) TODO. 
The package supports all query types discussed in @sec:queries and can automatically check if the calculation of a query is tractable. 
Furthermore, it supports all the distributions from the requirements and is easily extensible to new distributions.
PM features an efficient implementation of the Nyga Distribution, JPTs, RAT-SPN and CSPNs TODO DESCRIBE.
It features interfaces for both deep learning compatible (layered) descriptions of circuits and circuits as DAG. Finally, it also is time and space efficient.

==== Networkx torch, jax 

During the development of the PM package all the implementations described in @table:pc-frameworks but PyJuice and cirkit where considered to build upon. 
The first version of PyJuice and cirkit were released after the development of PM was almost finished.
As soon as these packages provide an extensive documentation an interface will be created. The approach to this interface is subject to a current discussion on the GitHub page of the cirkit package.  

Recall that conditioning and marginalization and conversions from graphical models are structure changing algorithms. None of the frameworks are feasible to perform dynamic changes of the structure of a PC. Additionally, the documentation and testing coverage were too low to efficiently extend the frameworks. This does not mean that the existing frameworks are bad. They were build from a perspective of estimating the parameters using the MLE and gradient descent or EM. 
For this use case the mentioned frameworks heavily rely on PyTorch. LibSPN is an exception since it uses Tensorflow. An modern, accelerating backend like PyTorch and Tensorflow offers great speed ups in calculations using a static computational graph. This does not integrate well with structure changing transformations of circuits. 
In PM, one way to use PCs is a Networkx representation of the computational graph. NetworkX is a Python package for the creation, manipulation, and study of the structure, dynamics, and functions of complex networks. @SciPyProceedings_11
The representation that Networkx allows can be directly manipulated without worrying about the structure of a layered PC. Hence, it is perfectly suited for structure learning and manipulating algorithms. 
However, it is not a coincidence that all these frameworks decided for an acceleration backed due to speed ups around two to three order of magnitudes. PM is no exception. It offers a way to compile a Networkx PC into a layered PC using JAX as accelerating framework. @jax2018github
The JAX backend supports both sparse and dense representations of the connections between layers, which is a unique feature of the PM package.

This conversion from a Networkx circuit to a layered circuit is inspired by the architecture presented in PyJuice. @liu2024scaling.

PyJuice represented these layers using dense matrices. If sum layers are not fully connected or even only connected using 1% of the edges, it leads to a huge amount of wasted memory and calculation time. 
PM on the other side bets on sparse matrices for edge tensors and hence does not suffer from this waste. However, sparse matrices have a calculation and storage overhead. The indices and edges of a sparse matrix are stored separately and have to be accessed when calculating anything. In practice, if around 50% of an edge tensor is empty the sparse implementation is faster.

The reasoning behind PyJuices choice to always use dense tensors remains subject to speculation. A possibility however could be that PyTorch sparse tensors are not compatible with compiling when using operations that are typically required in inference such as accessing the indices and values of a sparse tensor directly.
This incomplete implementation of sparsity in PyTorch is the reason why PM uses JAX as backend.
The just-in-time (jit) compiler of JAX is able to accelerated almost all calculations needed for inference in PCs and supports the nescessary operations for sparse matrices. 
Hence, PM uses JAX as backend to get up to scale in repeated probabilistic inference. 

TODO detailed numbers.

=== Evaluation

The qualitative properties of the models used in the thesis have been discussed above. This section quantitively evaluates the models and compares them to state of the art circuits. 