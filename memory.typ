= Memory
<sec:memory>

This section goes through the development of a new memory component for the PyCRAM architecture. Before investigating a new architecture it is important to discuss memory in PyCRAM as a general concept. After that details of the old, NEEM bases, architecture are layed out. Finally, the new component is discussed in detail.

Memory is a key aspect of human intelligence and hence of cognitive architectures. 
Since PyCRAM is a cognitive architecture it also features a memory component. This component was designed to serve as a ontological knowledge base.
Therefore engineering needs where not taken into concern while designing the specifics of such a component. In general, memory enables the storage of intermediate results, adaption to changing environments and learning. 
There is no general blueprint that dictates the domain independent design of memory components. The concrete implementations strongly depend on the application in mind and conceptual limitations such as programming languages, frameworks or biological plausibility. @kotseruba2018review40yearscognitive 
Memory can be abstracted into two general categories, the long-term memory (LTM) and short-term memory (STM). Note that this division is not necessarily reflected in the implementation of a cognitive architecture since it is motivated by psychology and the studies of the human mind itself. @perner2011action
Nevertheless, PyCRAM distinguishes between LTM and STM. Everything that is in the current working memory of the PyCRAM process is STM. Everything that gets explicitly written to a permanent storage is LTM.
STM further divides into sensory memory and working memory. 
Sensory or perceptual memory is a very short-term buffer that stores several recent percepts. In PyCRAM it is realized using ROS topics.
Working memory is a temporary storage for percepts that also contains other items related to the current task and is frequently associated with the current focus of attention. @kotseruba2018review40yearscognitive While PyCRAM does not implement an explicit attention module, attention is realized by accessing the information that is needed to perform a task. This information usually originates from the belief state.

LTM further devides into procedural memory and declarative memeory. The purpose of LTM is to store information for a very long time.
Procedural memory stores implicit behaviour without conscious awareness of these previous experiences. In PyCRAM this corresponds to the set of pre-defined plans. For instance, the impelementation of the MoveAndPickUp plan can be thought of as the storage of the procedural memory on how to achieve a MoveAndPickUp task.
Declarative memory refers to memories for facts and events that can be consciously brought to mind and “declared”. @cohen1980preserved It is furthermore subdivided in semantic and episodic memory. Semantic memory stores facts about the objects and relationships between them. In PyCRAM a URDF file is used to store such information. In some studies, the URDF file is annotated with ontological concepts to enrich the scope of the narrow URDF description to real world scale. These concepts often originate from some variant of the  Socio-physical Model of Activities (SOMA) ontology. TODO SOURCE
Episodic memory stores specific instances of past experiences. 
These can later be reused if a similar situation arises and is the most common resource for machine learning. @beetz2023cramcognitivearchitecturerobot
The taxonomy of memory systems is visualized in @fig:memory_taxonomy.

#figure(caption: [Taxonomy of memory in cognitive architectures. @prueser2024pycrorm])[
  #image("images/memory_taxonomy.png")
]<fig:memory_taxonomy>

== Narrative Enabled Episodic Memories

The current memory engine of (Py)CRAM are the Narrative Enabled Episodic Memories (NEEMs). The name suggests that NEEms are episodic memory. According to the characteristics outlined of memory outlined in @kotseruba2018review40yearscognitive, NEEMs belong in the general category of declarative memory, since they also realize a semantic component. 
A NEEM consists of the NEEM experience and the NEEM narrative.
The NEEM experience represents the episodic memory. It contains every transform that was published on the transform (tf2) topic in ROS. Understanding what that really means requires the understanding of the tf2 topic in ROS. 
A robotic system typically has many 3D coordinate frames that change over time.  The tf2 topic maintains the relationship between coordinate frames in a tree structure buffered in time, and lets the user transform points, vectors, etc between any two coordinate frames at any desired point in time. @stanford2024ros
This enables the agent to answer questions like
- Where was the head frame relative to the world frame, 5 seconds ago?
- What is the pose of the object in my gripper relative to my base?
- What is the current pose of the base frame in the map frame? @ros2013tf

All these question play a major role in cognitive architectures since they transform raw sensory information to a more meaningful representation. For instance, to perform a pick up task, it is not useful to know about the global position of an object and the robotic gripper. Hence, the agent transforms the global positions of the object into the relative coordinate system of the gripper and hence can easily make sense of that information. 
The data structures communicated in the tf2 topic are the so called "TransformStamped Messages". The details of these messages are shown in @tab:transform_stamped. 

#figure(caption: [Definition of the "TransformStamped" Message in ROS. @ros2013tf 
This message is used to communicate orientated poses in different coordinate frames between processes. 
The message consists of a header that keeps track of metadata, a frame that describes to what this pose relates and a transformation that described the translation and rotation of the pose w. r. t. the frame.])[
#table(
  columns: (auto, auto, auto),
  align: left,
  stroke: none,
  table.header(
    [*Field*], [*Type*], [*Description*]
  ),
  [header], [], [],
  [#h(2em) seq], [int], [A consecutively increasing ID.],
  [#h(2em) stamp], [time], [],
  [#h(2em) frame_id], [string], [The Frame this data is associated with.],
  [child_frame_id], [string], [The frame id of the child frame.],
  [transform], [], [],
  [#h(2em) translation], [],  [],
  [#h(4em) x], [float64],  [The translation in x direction.],
  [#h(4em) y], [float64],  [The translation in y direction.],
  [#h(4em) z], [float64],  [The translation in z direction.],
  [#h(2em) rotation], [],  [],
  [#h(4em) x], [float64],  [The x component of the rotation quaternion.],
  [#h(4em) y], [float64],  [The y component of the rotation quaternion.],
  [#h(4em) z], [float64],  [The z component of the rotation quaternion.],
  [#h(4em) w], [float64],  [The normalization constant of the quaternion.],
)
]<tab:transform_stamped>


The NEEM experience for robotic experiments consists of a collection of these transform messages.
The collection is implemented using a JSON-like format and MongoDB. MongoDB is a document based database that stores information in JSON like documents. It does not require a specified model in some data definition language (DDL). Everything in a MongoDB is essentially a key-value pair, where the key describes the name of the attribute and the value describes its content. For nested objects, such as the tf2 messages, the nested parts are just represented as a dictionary containing the nested values. This nesting makes MongoDB very easy to use for one to many relationships and tree-like data structures. @kleppmann2019designing 
When it comes to many to one or many to many relationships MongoDB starts to struggle. The burden of handling such relations is transferred to the users, who has to do manual ID management or store copies of the data.
Furthermore, the absence of a DDL starkly limits the optimizations that MongoDB can do automatically. 
The NEEM experience can potentially be enhance with other sensory data such as images and audio.  
However, the raw sensory information of a robot shows an incomplete picture. It is of uttermost importance to annotate this information with semantic information. 
For this purpose NEEMs implement the narrative part.

#quote(block:true, attribution: [Michael Beetz et al. @beetz2024neem])[
  The vision is that a library of contextualized motions and interactions will help to uncover models underlying everyday activities. With contextualized we mean that each motion and interaction is associated to the context of its occurrence. That is the environment where it occurred, objects that were involved, the goals and plans of agents, their behavior etc.
]

Technically, the narrative part of a NEEM consists of triples that originate from an ontology. These triples describe actions and objects that appeared throughout the episode. For instance, certain time stamps may be annotated with 
$
"TODO EXAMPLE"
$

These triples are again stored in a JSON like document inside the MongoDB. 
In summary NEEMs are a valuable tool for a use-case independent data storage. The modularity of the experience and narrative part is a great concept if one gathers experiment data and later annotates it. The document database as back-end is wise choice if no information about the data structures can be provided pre-recording. @kleppmann2019designing

// TODO complete example of two neem documents

However, in PyCRAM the situation is the other way around. The agent executes actions while knowing what he wants to achieve with them. Furthermore, the agent has a rigorously defined language that represents what he is doing. This language already transforms information into the relevant representation such that it can be directly used for execution.
Hence, a memory component designed for PyCRAM directly should integrate with well with this representation. 


== PyCRORM

Under my supervision, a student identified further requirements for an episodic memory component tailored for PyCRAM. @prueser2024pycrorm

The requirements for a well designed memory component can be realized using an Object Relational Mapping (ORM). @kleppmann2019designing
An ORM represents a method of associating user-defined classes in a program with database tables, and instances of those classes (objects) with rows in their corresponding tables. 
The SQLAlchemy ORM includes a system that transparently synchronizes all changes in state between objects and their related rows, as well as a system for expressing database queries in terms of the user defined classes and their defined relationships between each other. @sqlalchemy

*Requirement 1* Designator Mapping and Tracking: The episodic memory system shall maintain comprehensive mapping and tracking of all utilized designators within the environment, including action designators, motion designators, and object designators. This mapping must reflect the dynamic state of the environment and support real-time updates.

Since designators of any kind are rigorously represented in classes in PyCRAM it is possible to directly map those classes to SQL tables. Hence, the first requirement can be realized using an ORM.


*Requirement 2* Incremental Memory Updates: Any modification or execution of designators must trigger internal, incremental updates to the episodic memory, preserving the history of previous states and changes. This ensures a chronological and historical perspective of the system’s operations, enabling analysis of past episodes and analysis of decision-making.

The SQLAlchemy ORM also keeps track of changes of the objects of interest during runtime and hence is capable of updating the database. However, as object and PyCRAM are sometimes changed in-place it is necessary to do some manual tracking here. For instance, the transporting of an object changes the objects state. If the object is inserted into the database at the end of the plan, it is not correctly reflecting the information that was available pre execution. Hence, every state-changing action in PyCRAM stores all the information pre and post execution. The ORM than links the state of the object at that time with the action the object occurred in. Insertions into the database can be triggered at any given time and thus incremental updates are supported. Hence, the second requirement is met.

*Requirement 3* User-Friendliness and Accessibility: The system must provide an intuitive and accessible interface for end-users, eliminating the necessity for specialized knowledge of database structures or query languages such as SQL. It should prioritize ease of access and user interaction.

SQLAlchemy features a querying language that utilizes the reflected class definitions. It hides the details of SQL from the user and only requires the user to know about the basic SQL operations, selecting, filtering and joining. The user does not have to know about the layout of the table that is accessed or how to join two tables together. These details are layed out by the classes written in python and hence never repeated during querying. The leads to the user not having to learn the difference between the instances of classes used in a plan and their reflections in the database, fulfilling this requirement. 

*Requirement 4* Relationship Mapping: The episodic memory system shall capture and represent relationships between entities within the environment, enabling a relational understanding of interactions and dependencies. This relational mapping is crucial for the cognitive architecture’s reasoning and decision-making processes.

Since relations between entities in a plan cannot be realized using only one to many relationships it is necessary to flexible link those things together. While any database theoretically can do so, the performance of such linking (joining) is important. Document based databases, such as MongoDB, cannot do that efficiently and hence are unfeasible to represent relational data. Furthermore, querying such relations shifts the burden from the database API to the user in NoSQL databases and is hence costly to maintain. SQLAlchemy supports SQL databases as engine fulfilling this requirement. Note that in most situations a MariaDB is used as an open-source free SQL database solution.


*Requirement 5*  Scalable Data Storage: The system must offer scalable data storage solutions capable of accommodating an indefinite number of plans and designators. The architecture should provide efficient handling of extensive datasets without compromising performance or responsiveness.

Accumulating huge amounts of data in a single system can lead to performance problems even if access in linear time is guaranteed.
Databases usually implement some index mechanism to get sub-linear accessing speed. @kleppmann2019designing 
Due to the absence of a DDL, NoSQL databases can not arbitrary lay indices on documents. For speed improvements on frequently accessed data it is necessarily to support indexing for such columns.
It is noteworthy, that document driven databases usually circumvent such needs by having related information already locally stored. For instance, the objects used in an action are usually directly available as it is a field stored in the tree-like structure of an action. However, as it is often required to access multiple episodes at a time, it is insufficient to guarantee this local property.
A second dimension to this requirement is the distribution of databases to multiple nodes in case of a too heavy load for a single system.
Due to the tremendous amount of data needed this requirement is hard to test against. It can be looked at in the light of a database specification. Most databases support distributed nodes and so does MongoDB and MariaDB. The engine object of SQLAlchemy hides the specific architecture of a database and also supports distributed databases. 
SQLAlchemies ORM satisfies the two dimensions of the fifth requirement. 


*Requirement 6* Efficient Data Querying for Machine Learning Purposes: The episodic memory must support efficient querying mechanisms to provide fast access to stored data, particularly for machine learning applications requiring substantial amounts of data for training and testing. While the robotic agent’s access to its long-term memory does not need to be instantaneous, the architecture must support timely retrieval.

As already discussed in the fifth requirement, querying over multiple episodes is of uttermost importance, especially for machine learning. Having strongly nested data structures implies a convoluted, un optimized access and will not scale to the needs of machine learning. Furthermore, machine learning always needs data in a tabular form. No matter if it is propositional, relational or temporal learning, at some point in the learning process the data has to take a tabular form. Hence, it is necessary for the memory component to be able to answer in this tabular format.
Furthermore, it is beneficial to have the memory component handle the preprocessing (transformation) of the tables. Usually databases have efficient transformation routines such that the user does not have to be bothered by it. 
NEEMs feature transformations of the read data by utilizing the Hadoop framework, however it has to be aggregated in an inefficient and difficult process from the MongoDB. @beetz2024neem 


*Requirement 7* Consistency and Integrity Assurance: Mechanisms shall be implemented to ensure data consistency and integrity, preventing corruption or inconsistency during concurrent accesses or updates. This is essential for maintaining the reliability of the episodic memory system.
 
Almost all databases follow the ACID principle and hence ensure that the elements that are commanded by the program to enter the database actually enter the database. @kleppmann2019designing
However, this is not the only concern of this requirement.
The validation of correctness of the format and content of memory episodes requires close integration and collaboration between the memory and PyCRAM engineers. Due to the PyCRAM independent definition that the NEEMs use there is a frequent mismatch between those components. A memory component tailored to PyCRAM has to be modifiable for a PyCRAM developer and always be faithful to the data structures of PyCRAM.
PyCRORM ensures this by directly mapping the data structures of PyCRAM in a modular fashion.

// TODO REPHRASE requirements?

Finally, the memory component should not hinder rapid development of new functionality. New ideas are frequently realized in PyCRAM and memory is not the first concern of such ideas. While everything has to be mapped in the mid-term perspective, it is not required to be done immediately.
PyCRORM enables the rapid development by defining a basic mapping for all superclasses in a separated python package. The user is not troubled with defining a conversion of data structures by automatically mapping the same named columns. Temporal dependent data is also automatically annotated and stored. 
PyCRORM runs silently in the background and maps what can be mapped and warns about things that cannot be mapped. Furthermore, many features are provided as classes in a "Mixin" pattern, omitting the need to repeat frequently occurring definitions. @sqlalchemy 

Under my supervision the memory component PyCRORM has been implemented and reviewed using SQLAlchemy in PyCRAM. @prueser2024pycrorm @sqlalchemy 
As of the date of writing this thesis, all object, motion and action designators that are available in PyCRAM are mapped in a MariaDB through PyCRORM. 
A visualization of the database structure is provided in FIGURE TODO.

The requirement analysis provided in this chapter is tailored for the use case of generating data from the perspective of a cognitive architecture. I want to emphasis at this point that this data structure based approach is not well suited for human-demonstrating applications. In such situations a raw data storage that annotates using ontological knowledge is a good choice.

On a side note, the entries in the database regarding certain actions can be thought of as samples from the real distribution executed on the robot. Hence, for a big enough dataset, it sometimes suffices to treat the database probabilistically using the Monte Carlo approximation of probabilistic inference. However, as the measured spaces get smaller, the number of samples that fit the query reduces and hence the variance of the entire estimator increases drastically. For some situations it may be sufficient to repeat answers from the database, for others it is insufficient.


- TODO Benchmarks