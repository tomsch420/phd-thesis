#import "@preview/ctheorems:1.1.3": *
#show: thmrules
#set quote(block: true)

= Introduction

The industrial revolution is an event that fundamentally changed the way the world works. Entire societies shifted from an agrarian economy to a manufacturing one, with products being made by machines rather than by hand. 
The industrial revolution provided many benefits to humanity, such as a better accessibility and affordability of goods, advancements in medicine.
Furthermore, the wealth and quality of life of the average person increased. 
TODO SOURCE AND REAL DATA THAT MEASURES IMPORVEMENTS.
Unfortunately, all these new centralized production capabilities also had unwanted side effects, such as overflowing cities and drastic environmental pollution. 

This way of automating the manufacturing process can also be seen in todays age, where robots are replacing factory workers more and more. TODO ACTUAL NUMBERS
While all these achievments provide prosperty in a never before seen quantity, a new tool emerged that goes beyond the mechanization of physical labor: Artificial Intelligence (AI). AI is greatly motivated by a mechanization of reasoning and hence offers potential to further increases of the quality of human live, just like the mechanical automation.

Applying automated mechanization together with automated reasoning  is a challenge that troubles many sectors today.
Much economical power has been realized through robots, which are the most prominent realization of this wonderful combination.
TODO ACTUAL NUMBERS AND EXAMPLES HERE.

While these inventions are marvelous, they are all limited to the scope of their domain. Since the 1950s, many researcher are aiming to generalize the scope of an AI agent to the entire world through cognitive architectures. 





- Automation is a driving force for the economy and society
- Robots are the embodiment of automation
- Programming robots is very difficult
- Even modern production facilities rely on hard coded robot plans and suffer from the inflexibility of their agents

Automation has become a cornerstone of modern economies, driving efficiency and productivity across various industries.
Automation has revolutionized manufacturing processes, enabling increased production rates, reduced costs, and improved product quality. 
It has also led to the development of new industries and job opportunities, solidifying its position as a driving force for economic growth.

Robots, as the physical embodiment of automation, have played a pivotal role in this transformation. 
However, the programming and deployment of robots often present significant challenges, hindering their widespread adoption and limiting their full potential.
Robots are versatile machines capable of performing a wide range of tasks, from assembly line operations to complex surgical procedures. @intuitive2024davinci
// TODO CITE MERCEDES AND DAVINCI
Their ability to work tirelessly and precisely has made them indispensable in many sectors, including manufacturing, healthcare, and logistics.

Programming robots is a highly specialized task that requires a deep understanding of computer science, engineering, and the specific application domain. The complexity of robot kinematics, dynamics, and control algorithms can make it a time-consuming and error-prone process.
Many modern production facilities rely on hard-coded robot plans, which are inflexible and difficult to modify. This can lead to significant downtime and inefficiencies, especially when faced with changes in production requirements or unexpected events.
// TODO perhaps study of mercedes work incidents due to robotics


- Environments have to be adapted to robot and not vice versa
- Robots are unsafe and lack interpretability
- Cognitive robotics tackles these problems by TODO
- Cognitive robotics can be enhanced using machine learning
- Cognitive architectures are an engineering effort and hence also subject to software engineering concerns
- Quote from antonio how modern ML is ironic
#quote(attribution: [YooJung Choi, Antonio Vergari, Guy Van den Broeck], block: true)[
Ironically, as our models get closer to fitting the true distribution with high fidelity, we are also getting further away from our goal of solving problems by probabilistic reasoning, to some extent nullifying the very purpose of probabilistic modeling and learning.
]

- Probability distributions as means to tackle the challenges
- Motivation why tractable inference


== Hypothesis

This thesis addresses the following research question:

“Compared to traditional planning methods, incorporating tractable joint distributions over plan parameters in cognitive robotics will significantly (by X%) increase the success probability of task planning and execution in dynamic environments.”


One key insight we share in this book is that software engineering can be thought of as “programming integrated over time.” (Software engineering at google.)


== Micheals Introduction

=== Instructions
- Do not jump to solutions too quickly
- Stay very general

- Make objectives  that are Specific, Measurable, Achievable, Relevant and time bound (by the end of this thesis)
- The contributions should be sharp, clear, concise, and to the point
- It needs to be objectively evaluable if the objectives are met
- It should be quantifiable
- Make an evaluation plan for the contributions
- The contributions need to be very precisely worked out

- The scope of the readers are intelligent computer scientists without knowledge of the specific area
- The readers should be convinced that the results from this thesis are valuable

- The introduction should be like a pleading
- For non computer scientists if should be cler after the introduction that this thesis makes a substantial and original scientific contribution
- The introduction has to be without technical  details



=== Content
- We are interested in how robots can complete tasks in the EASE Context.
- One key question is how to get from vague instructions to motion control programs
- Make a concrete example on setting the table for breakfeast and analyze the uncertainty in the task
- Discuss that the task is also dependent on how the sutation develops
- Generalize that new situations can arise with new uncertainties and missing information
- Conclude that part of controlling a robot is managing the uncertainty
- Introduce the core problem of designing a robot program that is general and has an enormous scope
- Add that each execution of the robot control program is spanning a big space of possibilities
- The problem that is now interesting for me consists of introducing a conceptual framework of influences und relations and constructing a machine which solves this problem by utilizing probabilities.   
- Furthermore the conceptual framework can be used to create recordings of the robots executions that can be learned from.
- Example: Transport one object to another object in the kitchen using different robots, objects, kitchens, target locations and source locations. Executing this 1000 times per combination should yield a dataset that can be used to improve the robot behavior
- TODO solve cool new problems on the basis of this data
- Are there problems that one robot solves but another doesnt?
- Can one judge if a dataset generated by the PR2 is feasible for the Fetch robot?
- Which high impact questions can we solve using probability theory as a tool?
- Making a the reader be astonished
- Close the example section

- Now turning towards the contributions of this thesis
- Now reiterate on why such a system in general is important
- What is the gain in knowledge is the problem is solved
- Scientifc work is validating theories by experiments
- Validate the experiments in the distribution of possibilities
- Distributions are a tool to solve such things
- Why is the topic hard?
- Lots of data
- Many dimensions
- Memory consumption can be high
- learning is a difficult task 
- Contrast with modern GenAI which can only predict/generate samples
- Contrast that this work focuses on answering a wide variety of queries

- The Hypothesis should be something like this:
- With the computation resources and data of a household robot, is it possible to improve functionality?

- Now go through my concrete contributions
- Make the 4 contributions:
  - Object relational mapper for pycram
  - conceptualization of tractable Random events and SOLID implementation
  - Probabilistic Model framework and SOLID implementation
  - Probabilistic actions and their evaluation in pycram


