#let day_time = datetime.today()

#set page(numbering: none)

#v(10%)
#align(text("PhD Proposal", size: 16pt, weight: "bold" ), center)
#v(-2%)
#align(text([Enhancing Cognitive Robot Plans with Tractable Joint Probability Distributions] , size: 28pt, weight: "bold" ), center)

#set align(left)
#v(5%)
#set text(size: 16pt)
Tom Schierenbeck


#text( [#datetime.today().display("[day].[month].[year]")], size: 12pt)
#v(20%)
#set text(size: 14pt)

#pagebreak()

#set page(
  header: [#text(size: 10pt)[#grid(
  columns: (1fr, 1fr, 1fr),
  [
    PhD Proposal \
    Tom Schierenbeck
  ],
  [
  #align(center)[AICOR Institute for \ Artificial Intelligence]
  ],
  [#align(right)[#image("images/logo_uni-bremen.png", width: 40%)]],
  )] 
  #line(length: 100%)
  ],
  numbering: "1",
  )

#counter(page).update(1)


= Introduction
The advent of autonomous robots revolutionized several industries such as agriculture, manufacturing, retail, transportation, and warehousing. The consistent further development of intelligent systems towards cognitive agents also enables the use of robots in accommodation, food services, healthcare, and social assistance. The increasingly complex robot systems face new challenges in their decision-making processes, such as unreliable sensor readings, extensive impact on the environment they are acting in and complex interactions of different robot parts. One of the most significant challenges is the uncertainty inherent in many tasks, such as perception, planning and control. Probabilistic reasoning provides a powerful tool to address this challenge and enable robots to make more informed decisions.

Enhancing robot control programs with tractable distributions is a critical area of research that aims to make these machines faster and more reliable while remaining explainable. 
Furthermore, the software engineering framework for this thesis must be robust and methodologically sound, ensuring reproducibility, scalability, and extensibility to facilitate and support subsequent investigations in this field.
It is essential to ensure that robots can operate optimally and efficiently throughout their lifespan, i. e. maximizing return while minimizing cost.
This thesis focuses on enhancing cognitive robot plans for household activities such as setting the table by leveraging tractable joint probability distributions. The central hypothesis is that by integrating Probabilistic Circuits (PCs) within the Cognitive Robot Abstract Machine (CRAM) framework, and by utilizing a semantically-rich data model derived from CRAM’s cognitive representation, robust, explainable, and adaptable robot control programs can be created, compared to existing heuristic-based or less scalable probabilistic approaches.
The core problem addressed is the lack of a scalable and semantically grounded method for handling uncertainty in the sequential and interactive task of setting the table. Current approaches often rely on brittle heuristics or probabilistic models that struggle with the complexity and relational aspects of everyday manipulation. This thesis aims to bridge this gap by developing a novel integration of tractable probabilistic reasoning with a cognitive robotics framework, using setting the table as a concrete and consistent benchmark.
The software engineering framework will be built with a focus on reproducibility and extensibility, allowing for future investigations in other household activities. The data model will be designed to directly reflect the semantic understanding inherent in CRAM, ensuring that learned probabilistic relationships are grounded in the robot’s cognitive representation of the task. Ultimately, this research contributes to the development of cognitive robots that can perform household tasks with greater autonomy and robustness, learning from experience in a semantically meaningful way.


= State of the art

Probabilistic circuits @choi2020probabilistic are a type of computational graph that encodes probability distributions. They are a powerful modeling framework that allows for exact and tractable probabilistic inference, meaning these circuits can efficiently compute the probabilities of different outcomes given the model's parameters and observed data. PCs represent a unifying framework for tractable probabilistic models, and have been the subject of extensive research in recent years. PCs have been shown to be very expressive while remaining tractable. Combining probability theory with robotics creates many benefits. For example, robots are able to reason about the (uncertain) consequences of their actions. However, the application of PCs in robotics is still subject to research.

Joint probability distributions are essential for modeling the inherent uncertainty in robot actions and the environment. In the context of setting the table, this includes the uncertainty in object poses, the outcomes of grasp and placement actions, and the relationships between different objects (e.g., a plate needing to be placed before cutlery). Markov Decision Processes provide a mathematical framework for modeling such stochastic environments. However, effectively representing the high-dimensional state and action spaces, and learning the underlying joint probability distributions in a semantically meaningful way for tasks like setting the table, remains a significant challenge.

Cognitive agents that are applicable in everyday activities can be programmed in various ways. A largely used framework for cognitive modelling is CRAM. CRAM is a framework for implementing cognitive high-level robot control programs @beetz2023cramcognitivearchitecturerobot. It allows autonomous robots to equip lightweight reasoning mechanisms that can infer control decisions rather than relying solely on pre-programmed decisions. CRAM provides a toolbox for designing, implementing, and deploying software on autonomous robots, enabling robotic agents to execute their tasks with high-level cognitive abilities. CRAM is designed to be lightweight and scalable, and it can be combined with machine learning methods and other cognitive architectures to further enhance its capabilities

@kazhoyan2021learning handled uncertainty in everyday household activities by using heuristics for action parametrization and failure handling in the CRAM. The CRAM mostly uses heuristics to infer plan parameters. Hence the robustness of planning and failure recovery can be improved by machine learning based on gathered robot experience.

First steps into integrating probabilistic models into the CRAM were successfully done by @koralewski2019learning. However, both choices of model and logging mechanism suffer from limited scalability and adaptability. PCs and state of the art logging mechanisms provide scalable solutions.
This work builds upon these foundations by proposing a tight integration of tractable probabilistic models with the semantic representation in CRAM, specifically focusing on the task of setting the table. This thesis moves beyond heuristic-based uncertainty handling and addresses the limitations of purely kinematic data logging by focusing on a data model that reflects CRAM’s cognitive understanding of the task.
@nyga2017prac introduced Probabilistic Action Cores (PRACs) using Markov Logic Networks (MLNs) for integrating machine learning into robot control programs. While this work highlighted the importance of semantic annotations, the computational intractability of inference and learning in MLNs poses significant scalability challenges, especially for complex tasks like setting the table involving multiple objects and sequential actions. Our approach, utilizing tractable PCs, aims to overcome this intractability while still leveraging the semantic richness of CRAM.


= Focus of research
This research focuses on enhancing the robustness and adaptability of a cognitive robot performing everyday activities, like setting the table by integrating tractable joint probability distributions within the CRAM framework. Hence, CRAM is part of the foundational work of this thesis. This involves a combination of theoretical development and experimental evaluation in both simulated and real-world environments.
Specifically, the research will address the following key questions:

*Research Question 1:* How can PCs be effectively integrated into the CRAM framework to model the joint probability distribution over the states and actions involved in everyday activities, capturing the inherent uncertainties in perception and manipulation?

*Research Question 2:* How can the semantic knowledge encoded in CRAM be leveraged to structure and constrain the learning of these probabilistic models, ensuring that the learned distributions are grounded in the robot’s understanding of objects, their properties, and the actions involved in everyday activities like setting the table (e.g., the relationship between a plate and cutlery)?

*Research Question 3:* How can a semantically-rich data logging mechanism, directly reflecting CRAM’s cognitive representation of activities, be developed to efficiently collect robot experience for learning and refining the probabilistic models? This will extend purely kinematic data logging, extending the scope to the objects manipulated, the actions performed, and their outcomes, including semantic information.

*Research Question 4:* How does the integration of tractable PCs within CRAM improve the robot’s ability to plan and recover from failures during everyday activities? This will be evaluated in terms of task completion rate, efficiency and complexity of the robot’s actions.

The research involves:
- Developing Probabilistic Models: Designing and implementing PC-based models to represent the joint probability distribution over relevant variables in everyday activities, such as object poses, grasp success probabilities, placement accuracy, and the sequence of actions.

- Semantic Integration with CRAM: Developing mechanisms to seamlessly integrate these PC models within the CRAM framework, leveraging CRAM semantic annotations to define the structure and parameters of the probabilistic models and to condition inference on the robot’s semantic understanding of the scene.

- Semantically-Rich Experience Logging: Designing and implementing a data logging system that captures robot experience at both the symbolic and sub-symbolic level, reflecting CRAM’s internal representation of objects, actions, and their outcomes. This will involve serializing relevant information from CRAM into a structured database.

- Evaluation in Simulation and Real-World Experiments: Conducting experiments in both simulated and real-world environments to evaluate the performance of the integrated framework in everyday activities, primarily the "setting the table" task. This will involve comparing the approach against baseline methods in terms of robustness to uncertainty, task completion rate, efficiency, and failure recovery.


= Proposed Architecture

The current state of the art in robot experience recording are the narrative enabled episodic memories (NEEMs) @beetz2024neem. NEEMs record all kinematic aspects of a robot, e. g. their joint states, pose data and annotate it with facts from the CRAM ontology (see @olivares2019review). The NEEMs are stored in MongoDB. The structure of the data varies strongly among the instances. Since traditional machine learning tasks need data in a structured, table-like format it is unfeasible to generate these tables from the structurally heterogeneous data of the NEEMs Additionally, MongoDB does not store relations between instances in the database. Restoring these relations is computationally expensive and requires expert knowledge. Furthermore, the recorded (kinematic) data does not correspond to the cognitive model in CRAM. Since CRAM implements a thoughtful abstraction level of general robot plans, it is more sound to reflect this abstraction level in the data model. The data structures in the CRAM are general enough to be reused for a vast amount of everyday activities and hence, provide a feasible solution for a data model. Part of the contributions of this thesis is the integration of an object relational mapper (ORM) into the CRAM framework. The ORM enables the programmer to serialize everything the robot thought into an efficient database with a minimal overhead. ORMs are easily integrated with the structured querying language (SQL) and therefore enable the joining of heterogeneous data into a table-like structure. These structures are suitable inputs for a vast amount of machine learning systems. Additionally, modern database management systems provide solutions for distributed data clusters and therefore enabling efficient and robust data management for millions of robots executing everyday activities @kleppmann2019designing. Finally, map-reduce frameworks, like Apache Spark, accelerate machine learning over such distributed data clusters, achieving learning and reasoning that exceeds the capabilities of a single machine (cf. @spark2018apache).
The proposed architecture centers around a tight integration between the CRAM framework and PCs, facilitated by a semantically-rich data model.

*Contribution 1:* Semantically Grounded Data Model: Instead of relying on purely kinematic data, a data model that directly reflects CRAM’s cognitive representation is developed. This involves defining database schemas that capture information about the objects involved (e.g., plate, fork, knife), their properties (e.g., type, location), the actions performed (e.g., grasp, place), and their outcomes (e.g., success, failure) at both symbolic and subsymbolic levels. This model leverages an Object-Relational Mapper (ORM) integrated into the CRAM architecture, enabling the efficient serialization of CRAM’s internal state into a structured database (e.g., MySQL). This approach ensures that the data used for learning probabilistic models is directly aligned with the robot’s semantic understanding of the task.

*Contribution 2:* Integration of Probabilistic Circuits within CRAM: This thesis develops CRAM plans and skills that utilize PC-based models for decision-making under uncertainty. This involves:
Representing the joint probability distribution over relevant variables defined by CRAMs semantic annotations using PCs.
Developing queries that directly calculate all the required information for CRAM plans in probabilistic meaningful ways.
Using these probabilistic estimates to inform planning decisions, such as selecting the most likely grasp pose or predicting the outcome of a placement action.
Implementing mechanisms for updating the parameters of the PC models based on the robot’s experience, leveraging the semantically-rich logged data.

*Contribution 3:* Learning from Experience: The semantically grounded data logged from the robot’s experiences is used to learn and refine the parameters of the PC models. This learning process is tightly integrated with the CRAM framework, allowing the robot to continuously improve its performance based on its interactions with the environment.

*Contribution 4:* Failure Recovery: The probabilistic models are crucial for enabling more robust failure recovery. By reasoning about the likelihood of different failure causes, the robot can make more informed decisions about how to replan or execute recovery actions. For example, if a grasp action has a low probability of success based on past experience with a particular object, the robot can proactively choose an alternative grasp strategy or a suitable alternative for the object altogether.


= Conclusion

This thesis proposes a novel approach to enhance the cognitive abilities of robots performing household tasks, specifically setting the table, by integrating tractable joint probability distributions within the CRAM framework. By focusing on a semantically-rich data model derived from CRAM’s cognitive representation and leveraging the efficient inference capabilities of Probabilistic Circuits, this research aims to overcome the limitations of existing heuristic and less scalable probabilistic methods. The successful integration of these techniques will lead to more robust, adaptable, and explainable robot behavior in everyday environments, contributing significantly to the advancement of cognitive robotics for household applications. The consistent use of the "setting the table" scenario throughout the research provides a clear and measurable benchmark for evaluating the proposed methods and their impact.


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