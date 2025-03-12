= Cognitive Systems


The field of artificial intelligence (AI) has been around since the 1950s providing many subfields of research.//TODO SOURCE 
AI may be realized in four different ways: systems that think like humans, systems that think rationally, systems that
act like humans, and systems that act rationally  @russell2016artificial

Cognitive architectures aim to model the human mind. This research began with the goal of creating intelligent programs. 
These programs should be able to reason, learn, adapt, and self-reflect across various domains. By studying these mechanisms, cognitive architectures contribute to cognitive science. @kotseruba2018review40yearscognitive

Cognitive architectures are developed for over 40 years now and there have been many different approaches to achieve any of the four goals of AI. Given the various approaches to human-level AI and the lack of a clear definition and general theory of cognition, each cognitive architecture is based on specific assumptions. @kotseruba2018review40yearscognitive

While the assumptions may be different, @kotseruba2018review40yearscognitive extracted components from this diverse landscape of systems that are common to most of them. These components are: perception, attention, action selection, planning, memory, learning, reasoning and metacognition.
Perception is a process that transforms raw sensory input into the system’s internal representation (belief state) for carrying out tasks. 
Attention describes the filtering of relevant information from the vast amount of information available. This is not to be confused with the attention mechanism that many modern deep learning models implement. @vaswani2023attentionneed
Action selection determines, as the name suggests, “what to do next”.
In the context of this thesis, action selection answers not only what to do next but also how to do it.
Memory is the part of the architecture that stores information about the past and present. Learning is the capability to improve its performance over time.
Reasoning is the ability to systematically and logically process information. This is not necessarily restricted to logical reasoning.
Finally, metacognition is a set of abilities that allow an agent to think about its reasoning by introspecting internal processes. This is similar to self-reflection in humans.

The topics discussed in this thesis in detail are learning, reasoning and memory. The details of learning and reasoning are layed out in @sec:sigma_algebra, @sec:probability_theory and @sec:probabilistic_models. Memory systems for cognitive architectures are discussed in @sec:memory
While the other components are touched on, they are out of scope of this thesis.

== PyCRAM
<sec:pycram>

PyCRAM is a framework for designing and deploying software on robotic architectures to achieve high levels of robot autonomy and control. @dech2024pycram
It is a Python re-implementation of CRAM (Cognitive Robot Abstract Machine) and the main subject to study the performance of the tools developed in this thesis.
PyCRAM implements many components that are typical for cognitive architectures and hence may be classified as one. @prueser2024pycrorm
It uses ROS (Robot Operating System), which comes along with certain functionality like sensor data processing and hence is useful for perception.
One of the framework’s primary features is the ”plan language”, which gives the end-user a way to implement and execute robot plans on different robots. These plans can be designed without much knowledge about PyCRAM’s architectural structure and the implementation of different components. Hence, it is a very user friendly, high level way of controlling many robots, like the PR2, HSR, Turtlebots, the IAIs Boxy and many more.

PyCRAM uses RoboKudo for visual perception. @mania2024open Furthermore, it features an internal representation of knowledge, which is referred to as the belief state. This belief state is a simulator where all gathered knowledge is manifested as physical objects. 
While the belief state may be any simulator that implements its interface, it is most often PyBullet. PyBullet is a simulator for fast and approximate physics simulation.
Multiverse is also a supported belief state. Multiverse is a simulation framework designed to integrate multiple advanced physics engines such as MuJoCo, Project Chrono, and SOFA along with various photo-realistic graphics engines like Unreal Engine and Omniverse.
Representing the belief state as simulator has the advantage of being able to mentally simulate every possible plan by executing it in the belief state. This process is referred to as prospection.
Prospection enables search algorithms based planning by trying actions in different orders to achieve a goal. The achievement of a goal can then be verified in the prospection world.

PyCRAM predefines a number of actions and motions that can be performed in simulation or on a real world robotic platform.
The actions and motions are commonly referred to as designators.
Designators also exist for locations and objects. All designators have in common that they represent some potentially under specified thing. Object designator for instance can describe the abstract specification of an object such as milk, but may still miss the position of the milk. In such a case the milk has to be searched for first.
Motions are the building blocks for actions and actions are the building blocks for entire plans. For instance, the MovAndPickUp action can be decomposed into the sequence of actions: Navigate, FaceAt, PickUp.
Actions play a major role in the scope of this thesis. 
Available actions are described in @tab:actions.


#figure(caption: [All implemented actions and motions in PyCRAM. @dech2024pycram])[
  #table(columns: (1fr, 1fr), table.header([*Action*], [*Description*]),
  [MoveTorso], [Move the torso of the robot up and down.],
  [SetGripper], [Set the gripper state of the robot.],
  [ParkArms], [Park the arms of the robot.],
  [PickUp], [Let the robot pick up an object.],
  [Place], [Places an Object at a position using an arm.],
  [Navigate], [Navigates the Robot to a position.],
  [Transport], [Transports an object to a position using an arm.],
  [LookAt], [Lets the robot look at a position.],
  [Detect], [Detects an object that fits the object description.],
  [Open], [Opens a container like object.],
  [Close], [Closes a container like object.],
  [Grasp], [Grasps an object described by the given Object Designator description.],
  [Face], [Turn the robot chassis such that is faces the pose and after that perform a look at action.],
  [MoveAndPickUp], [Navigate to a standing position, then turn towards the object and pick it up.],
)
]<tab:actions>

When specifying an action it is very rare that one can specify all required parameters ahead of time. Hence, actions undergo a process that fills in missing information. The filling of missing information is usually done with heuristics or by picking a solution that fits a set of logical constraints. Furthermore, the current belief state is taken into account to filter out impossible solutions.
Internally, PyCRAM uses a tree-like structure to represent and manage actions and motions triggered by plans. This structure is called Tasktree. The Tasktree consists of nodes which are instantiated whenever an action or motion designator is performed. Every node in the Tasktree holds a reference to the performed designator and additionally adds information about the status and duration of a task. If the designator failed at execution the reason for it is also stored. 
The children of a node in the Tasktree are the designators that were called while executing the node. An example of such a structure is shown in EXAMPLE TODO. 
Many cognitive architectures contain some form of execution sequence tracking. @prueser2024pycrorm

Before the contributions of this thesis, the main memory component of CRAM was a Narrative Enabled Episodic Memory (NEEM).
NEEMs have proven themself in various tasks and are used by multiple frameworks, especially within the Everyday Activity Science & Engineering Collaborative Research Center (EASE CRC) context. @beetz2024neem
NEEMs are formally represented using an ontology. An ontology is a collection of logical axioms in description logic. The axioms are then combined with instances of classes to enable reasoning about them.
NEEMs are technically represented using MongoDB. MongoDB is a document-orientated NoSQL database management system which can manage collections of JSON-like documents.

Learning the parameters of actions in (Py)CRAM has been investigated with limited scope. 
In @koralewski2019learning the authors presented an approach to extract parameters of actions from experience data and parameterize a joint probability distribution over those actions from the data.
The authors used a Markov Logic Network as representation of the joint distribution wich does not scale well. 
When executing new actions, the distribution is queried for a plausible parametrization of the action.
The distribution was used to infer three parameters.
In @kazhoyan2021learning the previously described approach was extended by using seven parameters and also extracting data from human demonstrations. 
So far, this is the only related work for learning parametrizations in (Py)CRAM.
@bass2024sql predicts the next action in a sequence of actions by taking into account the previous action and their execution status and the parent action.  // TODO cite bass
This is primarily a mechanism to recover from failures and come up with novel routines that achieve the goal of the parent task.
These articles all have one thing in common: probability distributions as knowledge representation of uncertain information.
This common ground already indicates that probability theory plays a big role in cognitive architectures. 
As cognitive architectures aim to model the human mind, this result may seem unsurprising if looked at in the light of James Clerk Maxwells words.

#quote(attribution: [James Clerk Maxwell @maxwell1881letter], block: true)[
They say that Understanding ought to work by the rules of right reason. These rules are, or
ought to be, contained in Logic; but the actual science of Logic is conversant at present only with things either
certain, impossible, or entirely doubtful, none of which (fortunately) we have to reason on. Therefore the true Logic
for this world is the Calculus of Probabilities, which takes account of the magnitude of the probability (which is, or
which ought to be in a reasonable man's mind). 
This branch of Math., which is generally thought to favour
gambling, dicing, and wagering, and therefore highly immoral, is the only “Mathematics for Practical Men,” as we ought to be.
]

Furthermore, the use of probability distributions to lay out the details of the behavior of cognitive agents is also suggested in @beetz2023cramcognitivearchitecturerobot. While remaining only on the conceptual level, the authors state that (Py)CRAM can be viewed as a generative model for action parametrization. This model, essentially a joint probability distribution, links motion plan parameters with their corresponding physical effects. Underdetermined actions trigger a sampling process within this distribution, aiming to identify the most likely motion parameters for achieving the desired outcome. CRAM realizes this generative model through logic based knowledge representation and reasoning, leveraging both symbolic and sub-symbolic knowledge but not through distributions yet. @beetz2023cramcognitivearchitecturerobot
While not using a distribution yet, @beetz2023cramcognitivearchitecturerobot already identified qualitative needs for a distribution that is useful in cognitive architectures and hence point to a direction that is shaping the tools that are developed in this thesis. 

#quote(attribution: [Michael Beetz and Gayane Kazhoyan and David Vernon @beetz2023cramcognitivearchitecturerobot], block: true)[
The joint probability distribution allows us to conceptualize what we seek in the knowledgebased contextualization process: to maximize the utility of the selected motion parameter values, i.e. to maximize the likelihood of the action being successful. This corresponds to a probability distribution that has low entropy and is highly informative: one that exhibits sharp peaks across the probability distribution, indicating motion parameter values that have a high probability of achieving the desired outcome.
]

A further common characteristic of cognitive architectures is to have extensive learning capabilities. As part of this thesis contributions a joint probability distribution learning component is delivered that is highly modular, efficient and integrated well into the PyCRAM architecture. This contribution splits up in the creation of a memory component that enables quick and extensive retrieval of relevant information (@sec:moment-query).
The second part is a machine learning framework for the creation of tractable joint probability distributions that enable the efficient parametrization of actions while taking information from the belief state into account (//@sec:probabilistic_models). 
Lastly, these components are integrated into PyCRAM to close the loop between action execution and performance improvements. Section TODO)




