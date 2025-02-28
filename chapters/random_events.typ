#import "@preview/ctheorems:1.1.2": *
#show: thmrules
#import "../thesis-imports.typ": *
#import "@preview/fletcher:0.5.1" as fletcher: diagram, node, edge


= The Product Sigma Algebra: Motivation, Applications, and Construction
<sec:sigma_algebra>

// TODO unstructured vs structured information und so
// TODO picture where in math we are?

Cognitive systems often operate with incomplete information.
This is particularly evident in the core function of a cognitive agent: determining the appropriate action from an abstract and underdetermined description. In essence, this involves selecting an element from a set of possible actions based on the given context.
These sets of possible actions often exist due to a lack of information.
Information incompleteness can manifest in various forms. Sets provide a useful framework for representing and manipulating this information. Set operations, such as union, intersection, and complement, define how to combine existing knowledge with new information. 

Furthermore, one of the main objectives of probabilistic models, is to reason about sets. The system of sets that probabilistic models can deal with is formalized in a sigma algebra. A sigma algebra ensures that the probability-measure behaves consistently under operations like unions, intersections, and complements of these measurable sets.

Research has shown that events that are described by independent constraints (rules) are the only events where probability estimation is tractable. @choi2020probabilistic
Spaces that are constructed by independent constraints are called product spaces. Understanding theese events is a key competence to building tractable probabilistic models.

This chapter describes the development and application of a specific sigma algebra, the *product sigma algebra* tailored for the specific needs of probabilistic robot plans. The product sigma algebra is the sigma algebra constructed from investigating the set operations of product spaces.

The chapter begins by formally introducing the sigma algebra.
Subsequently, the vocabulary and concepts used for this thesis is explained.
Next, the product algebra is defined. Then, important operations that are, to the best of my knowledge, nowhere found in the literature are developed. After that, examples are explored.
Then, the product sigma algebra is discussed from a viewpoint of computational geometry and it is shown, that
the results of the theoretical part of this chapter enable efficient reasoning about the world.
This chapter concludes with a discussion on the implementation and the limitations.

For those seeking a more practical, hands-on approach to the product sigma algebra, a complementary online resource is available. This resource presents the core concepts and functionalities in a concise and user-friendly format, making it accessible to a broader audience by utilizing Jupyter Books. @schierenbeck2024re


== Sigma Algebra

A sigma algebra ($sigma$-algebra) is a set of sets that contains all set-differences that can be constructed by combining arbitrary subsets of said set. Furthermore, it contains all countable unions of sets and all infinite intersection of the set.

#definition([Sigma Algebra  #cite(<kolmogoroff1933grundbegriffe>)])[
Let $E$ be a space of elementary events. Consider the powerset $2^E$ and let $Im$ be a set of subsets of $2^E$. Elements of $Im$ are called random events. If $Im$ satisfies the following properties,it is called a $sigma$ algebra.

+ $E in Im$
+ $(A, B) in Im => A without B in Im$
+ $(A_1, A_2, ... in Im) => (union.big_(i=1)^NN A_i in Im and sect.big_(i=1)^infinity A_i in Im)$

The tuple $(E, Im)$ is called a measurable space.
]<def:sigma_algebra>

A minimal example of such a set of sets is the following

$
E &= {a, b, c}, \
Im = 2^E &= {emptyset, {a}, {b}, {c}, {a, b}, {a, c}, {b, c}, {a,b,c}}, \
&"and" (E, 2^E) "as measurable space."
$

It is easy to see, that $(E, 2^E)$ is always a trivial choice for the measurable space and in most applications, it is the chosen measurable space. However, the direct manipulation of power sets for large sample spaces becomes computationally intractable due to the exponential growth in size with respect to the cardinality of the underlying set. To address the limitations of power sets, I introduce the concept of product sigma algebras.

Product sigma algebras are constructed by taking the Cartesian product of sets and then constructing the sigma algebra on the resulting set. In this thesis, I generate product algebras from a viewpoint of classical machine learning. Machine learning tasks often involve reasoning about a collection of variables that jointly influence the outcome of interest.

== Variables
<sec:variables>

A variable can be thought of as a part of an equation that can take different terms. 
In this thesis I use the taxonomy of variables described in #ref(<fig:variables_taxonomy>).


#figure(diagram(node-defocus: 0,
	spacing: (1cm, 2cm),
	edge-stroke: 1pt,
	crossing-thickness: 5,
	mark-scale: 70%,
	node-fill: luma(97%),
	node-outset: 3pt,
	node((0,0), "Variable"),
	node((1,1), "Discrete"),
	node(( -1,1), "Continuous"),
	node((2,2), "Integer"),
   node((0,2), "Symbolic"),
  edge((0, 0), (-1, 1), "->"),
   edge((0, 0), (1, 1), "->"),
   edge((1, 1), (2, 2), "->"),
   edge((1, 1), (0, 2), "->")
  ),caption: [Taxonomy of variables.]) <fig:variables_taxonomy>

Variables, in the context of this thesis, consist of a name and a domain. The name is a unique identifier and the domain is the set of elementary events. The measurable space constructed for a variable is always $("domain", 2^"domain")$.
Variables are either continuous or discrete. Continuous variables have the real line $RR$ as domain. For this thesis, it is sufficient to say that random Events on $RR$ are half open intervals.
Discrete variables further split up into integer and symbolic variables. Integer variables have the integer numbers $ZZ$ as domain. Symbols have a finite set as domain, as in the example above.

== Product Sigma Algebra
<sec:product-sigma-algebra>

Real-world applications frequently necessitate reasoning about interactions between multiple variables. To address this challenge, I seek to develop computationally efficient representations of events occurring within the joint space formed by the domains of multiple random variables. Here, the key tool is the product sigma algebra.

#definition([Product Sigma Algebra @hunter2011notes])[
Suppose that $(X, A)$ and $(Y, B)$ are measurable spaces. 
The product sigma algebra $A  times.circle B$ is the sigma algebra on $X times Y$ generated by the collection of all measurable rectangles,
$
A times.circle B = sigma({A times B : A in A, B in B}).
$
The product of $(X, A)$ and $(Y, B)$ is the measurable space $(X times Y, A  times.circle B)$.
] <def:product_sigma_algebra>
An example of this product algebra is the combination of the following.

$
E_1 = &{a, b, c} \
E_2 = &{1, 2, 3} \
E_1 times E_2 = &{(a, 1), (a, 2), (a, 3), \ 
& (b, 1), (b, 2), (b, 3), \
& (c, 1), (c, 2), (c, 3)}
$

However, for even a small product set of $3 dot 3 = 9$ elementary events, the powerset would contain a massive $2^9 = 512$ elements. This exponential growth in size with respect to the number of variables renders the powerset computationally intractable for practical applications. Therefore, a more manageable representation of relevant subsets within the powerset is crucial.

This is where the concept of independent constraints becomes essential. Independent constraints are random events that are defined per variable, allowing us to define meaningful subsets of the powerset. 

The example above exemplifies the key advantage of representing events using the Cartesian product within a product sigma-algebra. Compared to the exhaustive enumeration of all possible combinations in the powerset, this approach offers a significantly more compact representation.

=== Operations 

While the Cartesian product provides a compact representation for atomic events involving single variable assignments, it is often necessary to combine these atomic events to describe more complex random events within the product sigma-algebra. To achieve this, I introduce two fundamental operations: union and complement. Before describing these operations, it is necessary to introduce a more compact vocabulary and notation.

*Vocabulary:*

- *Simple Set* A simple set refers to a set that can be described by a datastructure that has fields of fixed size.
- *Composite Set:* A composite set is a union of simple sets.

$
  overbrace(underbrace(A, "Simple Set") union underbrace(B, "Simple Set"), "Composite Set")
$

*Notation:*

The assignment of a variable $X$ to an event $E$ is denoted as $X in E$.  For example, $"X" in {1, 3}$ represents the event where the variable $X$ takes on the value one or three. In the product algebra, multiple variable assignments are written by

$
  \{&\
    &X in {A, B}, \
    &Y in {D, C} \
  \}&
$

Forming the union of two simple sets results in a composite sets containing both simple sets. Consider the following variable definitions.

$
"Utensil" in {"Bowl", "Cup", "Spoon"} \
"Color" in {"Blue", "Green", "Red"}
$
Now the union of the events
+ $
  \{&\
    &"Color" in \{"Red", "Blue" \} \
    &"Utensil" in \{"Bowl"\} \
  \}&
$
+ 
$
\{& \
   &"Color" in \{"Green"\},\
   &"Utensil" in \{ "Spoon" \}\
\}&
$
cannot be expressed as a simple event and hence is written as
$
  \{& \
    &"Color" in \{"Blue", "Red"\}, \
    &"Utensil" in \{"Bowl"\}\
\}& union \{ \
    &"Color" in {"Green"}, \
    &"Utensil" in {"Spoon"} \
\}
$
which is a composite set containing two simple sets.

#theorem([Intersection of Product Sets @hunter2011notes])[
  
  The intersection of two simple events is given by the variable-wise intersections
  $
  (A times B) sect (C times D) = (A sect C) times (B sect D).
  $
]

#theorem([Complement of a Product Set @hunter2011notes])[
  
  The complement of a measurable rectangle is a finite union of measurable rectangles
  $
  (A times B)^c = (A^c times B) union (A times B^c) union (A^c times B^c).
  $
]<theo:complement_product_algebra>

Unfortunately, the complement presented in @theo:complement_product_algebra is exponential big in the number of variables. Bluntly speaking, the complement is created by treating the variable assignments in the original complement as boolean variables, constructing the entire truth table about it (with $2 ^ (|"variables"|)$) and removing the column that corresponds to the original event. This is exponential hard to do.

Hence, a complement of linear size (in the number of variables) is introduced as contribution of this thesis in @theo:proof_complement_product_algebra. This theorem enables a faster reasoning than originally assumed by the literature.

#theorem([Complement of a Product Set @hunter2011notes])[

  Let
  $
  AA = A union A^c \
  BB = B union B^c\
  CC = C union C^c.
  $
  
  
  The complement of a measurable rectangle is a finite, disjoint union of measurable rectangles
  $
    (A times B)^c = (A^c times BB) union (A times B^c).
  $

  Proof by Induction.
  
  *Induction assumption*
  $
    (A times B)^c &= (A^c times B) union (A times B^c) union (A^c times B^c) & #text([@theo:complement_product_algebra]) \
    &= (A^c times B) union (A^c times B^c) union (A times B^c)& "rearranged terms" \
    &= (A^c times (B union B^c)) union (A times B^c) & "distributive law"\
    &= (A^c times BB) union (A times B^c) & qed
  $

  *Induction Step*
  $
  (A times B times C)^c &= (A^c times BB times CC) union (A times B^c times CC) union (A times B times C^c) \
  $
  Proof
  $
  (A times B times C)^c &= (A^c times B times C) union (A times B^c times C) union (A times B times C^c) \
  & union (A^c times B^c times C) union (A^c times B times C^c) union (A times B^c times C^c) \
  & union (A^c times B^c times C^c) & #text([@theo:complement_product_algebra]) \
  &= (C times (A^c times B) union (A times B^c) union (A^c times B^c)) \
  & union (C^c times (A^c times B) union (A times B^c) union (A^c times B^c)) \
  &union (A times B times C^c) & "distributibe law" \
  &= (C times (A^c times BB) union (A times B^c) \
& union (C^c times (A^c times BB) union (A times B^c)) union 
(A times B times C^c) & "Induction Assumption" \
  &= (A^c times BB times CC) union (A times B^c times CC) union (A times B times C^c) &qed
  $
]<theo:proof_complement_product_algebra>

Finally, for probabilistic reasoning it is very important that the union contained in a composite set is disjoint. 
@alg:make_disjoint and @alg:split_into_disjoint_and_non_disjoint, as another contribution of this thesis, show how to create a disjoint union of simple sets from a union of simple sets. This pair of algorithms is not limited to the product sigma algebra. It works for any sigma algebra as long as the difference of a composite set and a simple set is a disjoint union of simple set.

#figure(

    algo(
            title: "make disjoint",
            parameters: ($S$, ),
            init: (
                (
                    key: [Input],
                    val: (
                        [$S$, A union of sets $S = union.big_(i=1)^N s_i$, that is not necessarily disjoint],
                    )
                ),
                (
                    key: [Output],
                    val: ([A disjoint union of sets $S^*$ such that $S^* = S$],)
                )
            )
        )[
$S^*, S^'  arrow.l$ #smallcaps([split into disjoint and non disjoint($S$)]) \
*While* $S^' != emptyset:$ #i
    \ $S_"disjoint", S^' arrow.l$ #smallcaps([split into disjoint and non disjoint($S^'$)])
    \  $S^* arrow.l S^* union S_"disjoint"$ #d\
  *Return* $S^*$

    ],
    caption: [
        #smallcaps([Make Disjoint]): The algorithm to convert a union of sets into a disjoint union of sets.
    ],
    kind: "algorithm",
    supplement: [Algorithm]
)<alg:make_disjoint>

#figure(

    algo(
            title: "split into disjoint and non disjoint",
            parameters: ($S$, ),
            init: (
                (
                    key: [Input],
                    val: (
                        [$S$, A union of sets $S = union.big_(i=1)^N s_i$, that is not necessarily disjoint],
                    )
                ),
                (
                    key: [Output],
                    val: ([$A$, a disjoint union of sets ],
                          [$B$, a non-disjoint union of sets such that $A union B = S$ and $A sect B = emptyset$],)
                )
            )
        )[
  $A arrow.l emptyset$ \
  $B arrow.l emptyset$ \
  *for* $s_i in S$: #i\
  $A arrow.l A union (s_i without {s_j | s_j in S "if" i != j})$ \
  $B arrow.l B union (union.big_(j!=i) s_i sect s_h)$ #d \
  *Return* $A, B$
    ],
    caption: [
        #smallcaps([split into disjoint and non disjoint]): The algorithm to split a union of sets $S$ into a disjoint union of sets $A$ and a non-disjoint union of sets $B$ such that $A union B = S$ and $A sect B = emptyset$.
        It works as long as the complement of a simple set can be expressed as a disjoint union of sets.
    ],
    kind: "algorithm",
    supplement: [Algorithm]
)<alg:split_into_disjoint_and_non_disjoint>



//   For(cond: $s_i in S$,
//   {
//     Assign[$A$][$A union (s_i without {s_j | s_j in S "if" i != j})$]
//     Assign[$B$][$B union (union.big_(j!=i) s_i sect s_h)$]
//   })
//   Cmt[Return a disjoint union of sets $A$
//  and a non disjoint union of sets $B$
//  such that $A union B = S$ and $A sect B = emptyset$]
//   Return[$A, B$]
// ])<alg:split_into_disjoint_and_non_disjoint>


=== Connections to Logic

It is beneficial to establish a common ground in understanding random events before delving further into the concept of product sigma algebras. In the context of computer science, events can be viewed as logical propositions. Assigning a variable to a set can be rephrased as defining a boolean variable. For instance, the variable "Utensil" could take a value of True if the item belongs to the set {bowl, cup}. Consequently, the union operation on sets translates to a logical OR operation between these boolean variables.

$
("Utensil"_({"bowl"}) and "Color"_({"blue"})) or ("Utensil"_({"cup"}) and "Color"_({"red"}))
$

This logical statement, expressed in disjunctive normal form (DNF), represents the event where a utensil is either a blue bowl or a red cup. In general, composite events can be constructed as disjunctions (OR) of conjunctions (AND) of simple events, corresponding to the DNF form in propositional logic.


=== Continuous Domains

Hybrid cognitive architectures have to reason about both symbolic and sub-symbolic (continuous) information.
Describing sets of continuous values is often done via intervals.

#definition([Intervals])[
An interval is a subset of $RR$ that contains all real numbers lying between any two numbers $a, b$ of the subset with $a <= b$. Intervals are notated either
- *Open*: $(a, b) = {x in RR | a < x < b}$
- *Half Open*: $[a, b) = {x in RR | a <= x < b}$
- *Half Closed*: $(a, b] = {x in RR | a < x <= b}$
- *Closed*: $[a, b] = {x in RR | a <= x <= b}$
]<def:interval>

The four interval definitions denoted in @def:interval form a sigma algebra, the so called *Borel* sigma algebra. @hunter2011notes 

Since @alg:make_disjoint has no assumptions over the simple and composite sets used in it, one can convert any union of intervals to a disjoint union of intervals using the same procedure. 

Consider the 3-dimensional Cartesian space constructed by these three variables for the rest of the chapter.
+ $x in RR$
+ $y in RR$
+ $z in RR$

A simple event of the product sigma algebra can now be described as a rectangle, for example
the event $x in [2, 3) times y in [10, 15)$ is visualized as the following rectangle.

#figure(image("../images/rectangle_event_2d.png")
,caption: [Simple rectangle event described by $x in [2, 3) times y in [10, 15)$.]) <fig:rectangle_event_2d>

It can be observed that the event described by the Cartesian product corresponds to a rectangle in the two-dimensional plane (x-y plane). Notably, for higher dimensions, events constructed through Cartesian products will always manifest as hyper-rectangles. Shapes such as triangles or circles are not expressible in this manner due to their inherent dependence between variable constraints. For instance, a circle with radius r cannot be represented solely by a product of constraints, as exemplified by the equation $x^2 + y^2 <= r^2$, which embodies a non-independent relationship between the variables x and y.

However, it is possible to define more complex simple events. Considers the simple event $x in [2,3] union [4,5] union [6,7] times y in [10,15] union [25,27]$. The visualization of said event is depicted in #ref(<fig:complex_rectangle_event_2d>). Furthermore, the three dimensional generalization by expanding the event with $z in [1, 3] union [4, 4.5] union [10, 11.5]$ is depicted in #ref(<fig:complex_rectangle_event_3d>).

#figure(image("../images/complex_rectangle_event_2d.png")
,caption: [Simple rectangle event described by $x in [2,3] union [4,5] union [6,7] times y in [10,15] union [25,27]$.]) <fig:complex_rectangle_event_2d>

#figure(image("../images/complex_rectangle_event_3d.png")
,caption: [Simple rectangle event described by $x in [2,3] union [4,5] union [6,7] times y in [10,15] union [25,27] times z in [1, 3] union [4, 4.5] union [10, 11.5]$.]) <fig:complex_rectangle_event_3d>

Visualizing events defined by Cartesian products in dimensions exceeding three becomes increasingly challenging. However, the fundamental properties of these events remain consistent across higher dimensions. The introduction of new constraints simply results in the addition of another axis to the hyper-rectangle representing the event. Furthermore, the patterns observed in constructing events using multiple intervals generalize seamlessly to higher dimensions, analogous to the transition from two to three dimensions.

Next, an intuition on complements of the product sigma algebra is presented. Consider the unit rectangle $x in [0,1] times y in [0,1]$. The complement of the unit rectangle is a random event with two elements, described by
$
\{&\
    &x in (-inf, 0.0) union (1.0, inf),\
    &y in (-inf, inf)\
\}& union \{\
    &x in [0.0, 1.0],\
    &y in (-inf, 0.0) union (1.0, inf)\
\}&
$
Since an infinite event can not be visualized, the complement of the unit rectangle intersected with $x in [-1,2] times y in [-1,2]$ is depicted in #ref(<fig:complement_2d>).

#figure(image("../images/complement_2d.png"),
caption: [Rectangle event described by #linebreak() $(x in [0,1] times y in [0,1])^C sect (x in [-1,2] times y in [-1,2])$.]) <fig:complement_2d>

Consider the complement of the unit cube $x_([0,1]) times y_([0,1]) times z_([0,1])$ intersected with $x_([-1,2]) times y_([-1,2]) times z_([-1,2])$. This event can be visualized as a solid object resembling a cube on the exterior, with the interior corresponding to the removed unit cube. While figures (e.g., #ref(<fig:complement_3d>) and #ref(<fig:cut_complement_3d>)) can aid in visualizing such events in lower dimensions, the mathematical description remains paramount for generalizability to higher dimensions.

#figure(image("../images/complement_3d.png"),
caption: [Rectangle event described by #linebreak() $(x_([0,1]) times y_([0,1]) times z_([0, 1]))^C sect x_([-1,2]) times y_([-1,2]) times z_([-1,2]) $.]) <fig:complement_3d>

#figure(image("../images/cut_complement_3d.png"),
caption: [Cut open rectangle event described by #linebreak() $(x_([0,1]) times y_([0,1]) times z_([0, 1]))^C sect x_([-1,2]) times y_([-1, 0.75]) times z_([-1,2]) $ (described in #ref(<fig:complement_3d>)).]) <fig:cut_complement_3d>

=== Applications

Hybrid cognitive architectures like PyCRAM have to reason about symbolic and continuous quantities at the same time. This section describes an end to end use case, where the belief of a robot is represented as a composite set of the product sigma algebra.  

Consider the laboratory apartment designed for the research of everyday activities in the Institute of Artificial Intelligence at the university of Bremen as shown in @fig:costmap_kitchen (hereinafter referred to as the "apartment lab"). The objective is to define the set of permissible locations within this environment where a robot can safely stand. Naturally, these permissible locations exclude areas occupied by obstacles such as cabinets, tables, and other furniture. By employing product sigma-algebras, one can formally represent the set of possible standing locations as a random event.

#figure([
 #grid(columns: 2,
      gutter: 2mm,
   image("../images/kitchen_bulletworld.png"),
   image("../images/ktichen_top_down_bullet.png"))
   #figure(image("../images/costmap_kitchen.png"))],
 caption: [
The kitchen of the apartment lab from a frontal (left) and top down (right) perspective. The bottom picture shows the space for the PR2 robot to fit in the kitchen as a composite event of the product algebra.]
)<fig:costmap_kitchen>




=== Relations to Computation Geometry

Representing geometric constraints as set has already extensively been explored in the field of computational geometry. Computational geometry is however not mainly interested in the product sigma algebra but into more complex structures like polytopes and computer graphics. Furthermore, the study of discrete information is limited. 
Boxes (hyper-rectangles) on the other hand are a well studied objects in computational geometry. @preparata2012computational
Since the reasoning provided in this thesis is based on algebraic boxes, it is sometimes necessary to approximate a complex shape, like polytopes or spheres, using a set of boxes, i. e. an element of the product sigma algebra. 
This problem has already been solved in computational geometry. @bemporad2004inner
This thesis sometimes will refer to the inner/outer box approximation. For the inner box approximation the algorithm proposed in @bemporad2004inner fits a single maximum inner box into a polytope and then splits the not covered area to repeat the process recursively.
For the outer box, a minimal bounding box is fitted that contains the entire polytope. This bounding box is split along the longest side and then the process is recursed into.
In an applied context these approximations are suitable for getting points that are definitely inside a polytope or definitely not.
Consider a hexagonal table that as not placed in an axis aligned manner. Usually, PyCRAM creates a bounding box for it by a single outer box approximation. This creates a relevant mismatch between the real table and the representation of it. If the robot now approaches the table to a position that is not inside the table, it frequently appears that the robot is too far away from the table to reach a position that is on the table. With the improved approach of an inner/outer box approximation the robot is now able to have a better belief about the collision. 

#figure([#image("../images/hexagon_table.png")], 
caption: [The surface of a not axis aligned hexagon shaped table.])<fig:hexagon_table>

#figure([
  #grid(columns: 2, rows: 2,
  image("../images/outer_box_approximation/4.0.png"),
  image("../images/outer_box_approximation/0.5.png"),
  image("../images/outer_box_approximation/0.1.png"),
  image("../images/outer_box_approximation/0.01.png")
)
], caption: [Outer box approximation of a hexagon for different tolerances of volume errors.])<fig:outer_box_approximation>
#figure([
  #grid(columns: 2, rows: 2,
  image("../images/inner_box_approximation/2.0.png"),
  image("../images/inner_box_approximation/0.1.png"),
  image("../images/inner_box_approximation/0.01.png"),
  image("../images/inner_box_approximation/0.001.png")
)
], caption: [Inner box approximation of a hexagon for different tolerances of volume errors.])<fig:inner_box_approximation>

Naturally, the question arises why one should not always represent information as a polytope or even more flexible sets. The answer is that algebraic operations on polytopes, such as complement and difference have an exponential worst-case complexity in the number of faces due to the possible combinatorial nature of the decomposition.

// TODO REWRITE THIS TO A MORE CONSISTENT ARGUMENT FOR BOXES

Computational geometry is concerned with efficient representations of geometric sets and algorithms that can quickly calculate properties of such sets. A popular way to represent those algorithms is linear programming. 
Linear programming has the same constraints as convex polytopes and hence more complex set descriptions are not well studied.
Furthermore, this thesis is mainly concerned about probabilistic reasoning. For probabilistic reasoning algebraic boxes are the events that are computationally feasible. Sets that are more complex are destroying properties in integration and hence allow no exact conclusions. This topic is further discussed in TODO.  

== Graphs of Convex Sets with Applications to Motion Planning

Another application of the product algebra is in motion planning. Motion planning is a fundamental challenge in robotics, aiming to determine a collision-free path for a robot to navigate from a start to a goal configuration.  
The state of the art in motion planning divides into two approaches. The first one is sampling based motion planning. Instead of meticulously analyzing the entire configuration space (all possible robot positions and orientations), it takes a shortcut by randomly sampling points within that space. These samples are then checked for collisions, and the collision-free ones are used to build a roadmap or a tree that guides the robot towards its goal. Sampling based motion planning has the advantage of being able to handle high-dimensional configuration spaces and complex robot geometries. However, it can be computationally expensive and may not always find a solution. @cohn2023non @marcucci2024graphs

The second approach is trajectory optimization-based motion planning. Trajectory optimization-based motion planning is a sophisticated approach that aims to find the best possible path for a robot, not just any collision-free path. It works by formulating the motion planning problem as an optimization problem, where the goal is to minimize a cost function that takes into account factors like path length, smoothness, energy consumption, and proximity to obstacles. The optimization problem is then solved using numerical optimization techniques like gradient descent or nonlinear programming. Trajectory optimization-based motion planning is computationally intensive but can produce high-quality paths that are smooth, energy-efficient, and safe. However, it is limited to only find solutions in convex sets.@cohn2023non
@marcucci2024graphs

#definition([Convex Set @boyd2004convex])[
A set $C$ is convex if the line segment between any two points in $C$, i.e., if for any $x_1, x_2 in C$ and any $theta$ with $0 <= theta <= 1$, we have
$
  theta x_1 + (1 - theta) x_2 in C.
$
]<def:convex_set>

It is easy to see that every simple set of the product sigma algebra is a convex set iff the cardinality of the intervals is 1. As proven in @theo:proof_complement_product_algebra the complement of a simple element of this product sigma algebra is computable in linear time.
It follows, that if the collision space of a robot is represented as a general element of the product algebra, the free space (complement of collision space) is a disjoint union of convex sets that is easily computable.
The union of these convex sets however may not be convex. 
Hence, optimization based motion planning can be applied inside the convex simple sets.
@marcucci2024graphs proposed a method to represent the free space as a graph of convex sets. This graph is an undirected graph where the nodes are the convex sets and the edges represent adjacency of the convex sets. 
This means that connected nodes can be reached from each other.
The problem of optimization-based motion planning can then be restated as finding a path in this graph and calculating the guarantee collision-free paths inside the convex sets.
@marcucci2024graphs used polytopes inside the convex sets to represent the free space. However, as the polytopes are generated as an approximation of the complement of other polytopes (meshes), the computational effort involved is enormous.

=== Product Algebra for Motion Control

This section presents examples of the product algebra in motion control. The first example is the representation of the free space of a robot as a product algebra. The second example is the representation of the free space as a graph of convex sets.

TODO Images und so

It is impressive that the presented algorithms can be used to calculate the graph of convex sets of the free space in less then a second for the entire belief state of the robot. 
Furthermore, it is impressive that this approximation of the belief state of the robot is sufficient to calculate an entire collision-free path using the Giskard tool for optimization-based motion planning.


== Implementation

As of the time of writing, there is no implementation of the product sigma algebra or sigma algebra in general on GitHub. 
However, plenty of lecture notes and proof assistant files are available.  

As part of the contribution, this thesis provides a python implementation of the product sigma algebra, intervals and sets.
The implementation is available in the python package *random_events* at https://github.com/tomsch420/random-events. 

The python package features flexible variable definitions and the following operations for intervals, sets and the product sigma algebra:
- union
- intersection
- complement
- difference
- make disjoint
- inner/outer box approximation of polytopes.
Since most of the logic is abstracted one can add a new sigma algebra by defining a simple set, its intersection with another simple set and its complement as disjoint union of simple sets.

The package has a test coverage of 91% and a documentation coverage of TODO%. Furthermore, the package features a complete user guide. 

Furthermore, the package features a C++ backend, which improves the speed from a pure python implementation by two orders of magnitude. The C++ backend is connected to the python package via pybind11, enabling high usability and performance.

The architectural diagram of the package is shown in figure TODO.


