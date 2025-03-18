#let day_time = datetime.today()

#v(10%)
#align(text("PhD Proposal", size: 16pt, weight: "bold" ), center)
#v(-2%)
#align(text([Enhancing Cognitive Robot Plans with Tractable Joint Probability Distributions] , size: 28pt, weight: "bold" ), center)

#set align(center)
#v(5%)
#set text(size: 16pt)
Tom Schierenbeck


#text( [#datetime.today().display("[day].[month].[year]")], size: 12pt)
#v(20%)
#set text(size: 14pt)

= Introduction
The advent of autonomous robots revolutionized several industries such as agriculture, manufacturing, retail, transportation, and warehousing. The consistent further development of intelligent systems towards cognitive agents also enables the use of robots in accommodation, food services, healthcare, and social assistance. The increasingly complex robot systems face new challenges in their decision-making processes. such as unreliable sensor readings, extensive impact on the environment they are acting in and complex interactions of different robot parts. One of the most significant challenges is the uncertainty inherent in many tasks, such as perception, planning, and control. Probabilistic reasoning provides a powerful tool to address this challenge and enable robots to make more informed decisions.

Enhancing robot control programs with tractable distributions is a critical area of research that aims to make these machines faster and more reliable while remaining explainable. 
Furthermore, the software engineering framework for this thesis must be robust and methodologically sound, ensuring reproducibility, scalability, and extensibility to facilitate and support subsequent investigations in this field.
It is essential to ensure that robots can operate optimally and efficiently throughout their lifespan, i. e. maximizing return while minimizing cost, contributing to sustainable manufacturing processes.

This thesis addresses the problem of enhancing robot control programs by utilizing probabilistic reasoning and building stable software that lasts a lifetime. The construction of this software framework is informed by a thorough review of existing literature and best practices in software engineering, integrating proven methodologies to ensure robustness, scalability, and adaptability. The proposed solutions include the use of the probabilistic circuits framework to tackle uncertainty and scalable technology to handle the vast amount of data generated. The thesis's contribution includes joint probability trees and close integration of probabilistic reasoning and data acquisition through robot experience logging into PyCRAM. The research-field of cognitive agents for perception, plan and control will benefit from the ideas presented here.
State of the Art

Probabilistic circuits (PCs) are a type of computational graph that encodes probability distributions @choi2020probabilistic. They are a powerful modeling framework that allows for exact and tractable probabilistic inference, meaning these circuits can efficiently compute the probabilities of different outcomes given the model's parameters and observed data. PCs represent a unifying framework for tractable probabilistic models, and have been the subject of extensive research in recent years. PCs have been shown to be very expressive while remaining tractable. Combining probability theory with robotics creates many benefits. For example, robots are able to reason about the (uncertain) consequences of their actions. However, the application of PCs in robotics is still subject to research.

Furthermore, joint probability distributions can be used in machine learning to model the uncertainty and randomness inherent in many real-world environments. Specifically, joint probability distributions can be used to represent the probabilities of different states and actions in a given environment. One way to model the environment is to use a Markov decision process (MDP), which is a mathematical framework that models decision-making in stochastic environments. In an MDP, the joint probability distribution over states and actions is called the state-action distribution. This distribution describes the probability of being in a particular state and taking a particular action. The state-action distribution can be used to compute various quantities that are important in reinforcement learning, such as the expected value of the reward function under a particular policy. This expected value can be used to evaluate the quality of a policy and to guide the agent's learning process. Similar to PCs, the use of all advantages of full joint probability distributions has not yet been comprehensively researched @choi2020probabilistic. 

Cognitive agents that are applicable in  learning can be programmed in various ways. A largely used framework for cognitive modelling is the Cognitive Robot Abstract Machine (CRAM). The CRAM is a framework for implementing cognitive high-level robot control programs @beetz2023cramcognitivearchitecturerobot. It allows autonomous robots to equip lightweight reasoning mechanisms that can infer control decisions rather than relying solely on pre programmed decisions. CRAM provides a toolbox for designing, implementing, and deploying software on autonomous robots, enabling robotic agents to execute their tasks with high-level cognitive abilities. CRAM is designed to be lightweight and scalable, and it can be combined with machine learning methods and other cognitive architectures to further enhance its capabilities

@kazhoyan2021learning handled uncertainty in everyday household activities by using heuristics for action parametrization and failure handling in the CRAM. The CRAM mostly uses heuristics to infer plan parameters. Hence the robustness of planning and failure recovery can be improved by machine learning based on gathered robot experience.

First steps into integrating probabilistic models into the CRAM were successfully done by @koralewski2019learning, both choices of model and logging mechanism suffer from limited scalability and adaptability. PCs and state of the art logging mechanisms provide scalable solutions.

 integrated machine learning into robot control programs by introducing probabilistic action cores (prac). @nyga2017prac uses Markov logic networks (MLNs) to encode semantic networks over natural language and robot control programs. However, inference and learning in MLNs is computationally intractable such that scalability of prac models remains challenging. Hence, the integration of tractable distributions offers a great improvement to prac. Tackling relational modelling and tractable distributions is even more difficult than propositional distributions and hence of large interest.

= Focus of research

This research will involve a combination of theoretical and experimental approaches to advance the integration of probabilistic reasoning models, specifically PCs, into the CRAM framework.

I will develop and evaluate probabilistic reasoning models for planning and robot control tasks, leveraging the strengths of PCs in providing exact and tractable probabilistic inference. The developed models will be integrated into a lifelong learning framework. The evaluation will involve simulations and real-world experiments, comparing the performance of the models with existing approaches to identify the strengths and weaknesses of each technique. Additionally, a close integration of the models into the CRAM framework will be developed, enabling autonomous robots to equip lightweight reasoning mechanisms that can infer control decisions rather than relying solely on pre programmed decisions. Based on the results of the evaluation, I will propose novel methods for improving the performance of autonomous robots through the application of these techniques. These methods will focus on enhancing the scalability of probabilistic reasoning models and improving planning and failure recovery in real-world environments. Overall, this research aims to advance the state of the art in probabilistic reasoning and enhance the capabilities of autonomous robots for a range of tasks.

= Proposed Architecture

The current state of the art in robot experience recording are the narrative enabled episodic memories (NEEMs) @beetz2024neem. NEEMs record all kinematic aspects of a robot, e. g. their joint states, pose data and annotate it with facts from the CRAM ontology @olivares2019review. The NEEMs are stored in MongoDB. The structure of the data varies strongly among the instances. Since traditional machine learning tasks need data in a structured, table-like format it is unfeasible to generate these tables from the structurally heterogeneous data of the NEEMs Additionally, MongoDB does not store relations between instances in the database. Restoring these relations is computationally expensive and requires expert knowledge. Furthermore, the recorded (kinematic) data does not correspond to the cognitive model in the CRAM. Since the CRAM implements a thoughtful abstraction level of general robot plans, it is more sound to reflect this abstraction level in the data model. The data structures in the CRAM are general enough to be reused for a vast amount of everyday activities and hence, provide a feasible solution for a data model. Part of the contributions of this thesis is the integration of an object relational mapper (ORM) into the CRAM framework. The ORM enables the programmer to serialize everything the robot thought into an efficient database with a minimal overhead. ORMs are easily integrated with the structured querying language (SQL) and therefore enable the joining of heterogeneous data into a table-like structure. These structures are suitable inputs for a vast amount of machine learning systems. Additionally, modern database management systems provide solutions for distributed data clusters and therefore enabling efficient and robust data management for millions of robots executing everyday activities @kleppmann2019designing. Finally, map-reduce frameworks, like Apache Spark, accelerate machine learning over such distributed data clusters, achieving learning and reasoning that exceeds the capabilities of a single machine @spark2018apache.

= Conclusion

In conclusion, the integration of probabilistic reasoning models, specifically PCs, into the Cognitive Robot Abstract Machine (CRAM) framework has the potential to enhance the performance of autonomous robots in various industries. The use of PCs in modeling uncertainty can lead to faster, more reliable, and explainable decision-making processes. The proposed research will involve a combination of theoretical and experimental approaches to advance the integration of PCs into the CRAM framework. The developed models will be integrated into a lifelong learning framework. The evaluation will involve simulations and real-world experiments, and based on the results, novel methods will be proposed for improving the performance of autonomous robots. The integration of probabilistic models into the CRAM will benefit the entire cram-based robotics community, and the proposed techniques can be applied to other fields as well.


#pagebreak()

= Statement of Commitment

This proposal of research was discussed and deemed valid by the proposed supervisor, Prof. Michael Beetz, PhD.

Bremen, #datetime.today().display("[day].[month].[year]")

#linebreak()

#table(
  columns: (4fr, 2fr, 4fr),
  stroke: none,
  [\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_], [], [\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_],
  [Tom Schierenbeck], [], [ Prof. Michael Beetz]
)


#pagebreak()

#bibliography("references.bib")