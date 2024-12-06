= Contributions
This thesis presents my research on developing novel software components for cognitive robotics, with a particular emphasis on software quality. Throughout this work, I have prioritized principles that ensure the robustness, efficiency, and maintainability of the developed software. This commitment to software quality is crucial for real-world applications of cognitive robotics, where reliable and adaptable systems are paramount.
By prioritizing software quality, I aim to ensure that these contributions provide a solid foundation for future advancements in the field of cognitive robotics.
This section details my contributions.

== Memory Engine with Object Relational Mapper (ORM) for Robot Actions

The previous memory engine for this was based on triples from an ontology and raw TF data stored as json in a mongo db. The limitations of the previous architecture are:

- *Limited Structure:* The prior memory engine relied on triples from an ontology and raw data of robot transforms and their frames (TF)stored as JSON in a MongoDB database. This approach lacked the inherent structure of CRAM Plans. CRAM Plans provide a well-defined framework for robot actions and their parameters, making it much easier to query the memory engine in a way that directly aligns with how the robot operates.
- *Data Misalignment:* The previous system stored triples that didn't fully capture the relationships between robot actions and parameters within a CRAM Plan. This mismatch between data format and robot planning hindered efficient retrieval of relevant information.
- *Performance Bottleneck:* MongoDB, while popular, can be relatively slow for complex queries, especially when dealing with large amounts of data. This leads to performance issues as the robot interacts with its environment and the memory engine grows.
- *Indirect Linking:* The TF data was only implicitly linked to the triples, making it challenging to establish clear connections between the raw data and the robot's actions. This indirect approach hinders the effectiveness of the memory engine in reasoning and learning from past experiences.

To address the limitations of the previous memory engine, I propose a novel approach that leverages SQLAlchemy's Object-Relational Mapping (ORM) capabilities. This approach involves mapping CRAM actions to corresponding tables within a structured SQL database. By utilizing SQLAlchemy's ORM, we achieve a Pythonic interface for interacting with the database.

This offers the significant advantages:

- *Plan Engineer Abstraction:* Plan engineers can continue writing plans in the familiar CRAM syntax without needing any knowledge of the underlying SQL database schema. This simplifies the process and reduces the risk of errors.
- *Efficient Querying:* The ORM translates CRAM structures directly into SQL queries, enabling efficient retrieval of information from the database. This allows plan engineers to query the memory engine using the same constructs they used while writing the plan, promoting intuitive interaction.
- *Easy Extension:* The ORM approach facilitates the addition of new actions to the memory engine. By defining new classes that map to corresponding database tables, the system can seamlessly integrate novel functionalities without requiring major modifications to the underlying infrastructure.
- *Explicit Parameter Linking:* The structure of the ORM inherently establishes clear relationships between actions and their parameters within the database tables. This explicit linking simplifies reasoning and learning from past experiences, as the system can directly access relevant parameter values associated with each action.

=== Validation Strategy

- Performance Benchmarks:
  - *Query Speed:* Compare the query times of your ORM-based solution with the previous MongoDB setup for various types of queries relevant to robot planning. This can be done by simulating robot actions and logging them in both systems, then measuring the time it takes to retrieve specific information.
  - *Scalability:* Test how well your system handles increasing amounts of data. Simulate robot operation over extended periods and measure how query times and overall performance are affected by the growing memory.
  
- User Studies (Optional):
  - *Plan Engineer Usability:* Conduct user studies with plan engineers who are familiar with CRAM. Ask them to write plans, log them in your system, and then retrieve information using queries. Evaluate the ease of use, intuitiveness, and learning curve compared to the previous memory engine.

- Case Studies (Optional):
- *Integrate with a Robotic System:* If possible, integrate your memory solution with a physical or simulated robot. Design scenarios where the robot needs to learn from past experiences and adapt its plans based on retrieved information. Analyze the robot's performance and success rate these scenarios.

Metrics for Evaluation:

- *Query Time Reduction:* This metric measures the improvement in speed for retrieving information from the memory engine.
- *Data Accuracy:* Ensure the data stored and retrieved through your system is accurate and reflects the robot's past actions and experiences.
- *User Satisfaction (Optional):* If you conduct user studies, gather feedback from plan engineers on their experience using your memory solution.
- *Robot Performance Improvement (Optional):* In case studies with a robotic system, measure if the robot's success rate and adaptability improve with your memory solution in place.

== Learning and Reasoning Framework for Tractable Probabilistic Machine Learning

The difficulties in using traditional probabilistic machine learning frameworks for robots are:

- *Complexity of Probabilistic Learning:* Probabilistic machine learning involves complex mathematical concepts like probability distributions. This creates a barrier to entry for roboticists and engineers who may not have an extensive background in probability theory.
- *Limited User-Friendly Frameworks:* Existing frameworks for probabilistic machine learning can be cumbersome and lack user-friendliness. Ideally, the interface should be intuitive and accessible to users with a more practical engineering background.
- *Lack of Extensibility:* Existing frameworks might not be easily adaptable to new types of probabilistic models or application domains within cognitive robotics. This can hinder innovation and limit the scope of what robots can learn and reason about.

_Probabilistic Model introduction here_

The benefits of the new framework are:

- *Simplifying the Interface:* The framework will provide a user-friendly interface that abstracts away complex mathematical details behind probabilistic models. Users will be able to interact with the framework without needing in-depth knowledge of probability theory.
- *Promoting Ease of Use:* The design will prioritize user experience, making it easy to learn, use, and integrate probabilistic models into robot planning and decision-making processes.
- *Enabling Extensibility:* The framework will be designed with extensibility in mind, allowing users to incorporate new types of probabilistic models and adapt it to different robotic applications.

=== Validation Strategy

The validation of the new framework will be done by comparing the quality of implementation and the features that are implemented.

==== Software Quality Attributes:

  - *Usability:* Ease of Learning: Develop clear and concise user manuals and tutorials. Offer interactive tutorials or online guides that walk users through building and using models. Consider user studies to evaluate how quickly users can grasp the framework's functionalities.
  - *Intuitive Interface:* Design a user-friendly interface that allows users to build and interact with models without requiring extensive coding knowledge.
- Efficiency:
  - *Computational Performance:* Measure the execution time and memory usage of your framework for various model complexities and data sizes. Optimize algorithms and data structures within the framework to ensure efficient learning and reasoning processes.
  - *Scalability:* Test how the framework performs with increasing amounts of data. Simulate scenarios with large datasets and evaluate the impact on training time and memory usage.
- Maintainability:
  - *Modular Design:* Structure your framework with well-defined modules for different functionalities (e.g., model building, inference, visualization). This promotes code reusability and simplifies future maintenance and extension.
  - *Code Readability:* Write clean, well-commented code that adheres to best practices and coding standards. This improves readability and maintainability for yourself and other developers who might work on the framework in the future.
- Extensibility:
  - *Modular Design (as mentioned above):* A modular architecture facilitates the addition of new functionalities through the creation of new modules.
  - *Open Interfaces:* Define clear and documented interfaces for interacting with the framework. This allows developers to create custom modules or integrate the framework with other tools and libraries.

==== Features Implemented
Supported Probabilistic Models: List the specific types of probabilistic models your framework can handle (e.g., Gaussian Mixture Models, Hidden Markov Models).
Learning Algorithms: Describe the learning algorithms implemented within the framework for training probabilistic models from data.
Inference Methods: Explain the methods your framework provides for making predictions and reasoning using the learned models.
Visualization Tools (Optional): If your framework includes functionalities for visualizing learned models or their outputs, highlight this as a feature.

Validation through Testing:

Unit Tests: Develop unit tests that focus on the functionality of individual modules within your framework.
Integration Tests: Implement tests that verify how different modules interact and work together seamlessly.
Benchmarking: Compare your framework's performance with existing solutions on established benchmark datasets for probabilistic learning tasks.


== Integration of Tractable Models into Robot Plans:

Challenge: Briefly discuss the gap between learned models and their practical use in robot plans.
Your Integration Method: Explain your approach for incorporating tractable models seamlessly into robot plans. (e.g., how models inform action selection, plan adaptation).

Incomplete Information: Robots often operate in environments where information is incomplete. Sensors might have limited range, and the world can be dynamic and unpredictable.
Uncertainty: Sensor data itself can be uncertain due to noise or limitations in sensor accuracy. This uncertainty needs to be factored into planning decisions.
Non-Determinism: The outcome of robot actions can be non-deterministic, meaning there's a chance of unexpected results.
Mixed Information: Cognitive Robots deal with a mix of symbolic information (e.g., object types) and numeric information (e.g., sensor readings). A successful planning approach needs to handle both effectively.

These challenges demand the use of probability distributions that can efficiently handle:

Uncertainty Quantification: The probability distribution should represent the likelihood of different outcomes for robot actions, considering sensor noise and incomplete information.
Non-Deterministic Effects: The model should account for the possibility of unexpected events and how they might affect plan execution.
Symbolic and Numeric Data Fusion: The chosen probability distribution should be able to integrate both symbolic and numeric information from the robot's sensors and environment.

By incorporating tractable models that address these complexities, I enable robots to:

Make Robust Decisions: Reason about the likelihood of various outcomes and plan accordingly, increasing the success rate in uncertain environments.
Handle Incomplete Data: Effectively utilize available information, even when it's incomplete, to make informed decisions.
Adapt to Dynamic Environments: Continuously update plans based on new information and sensor readings, allowing for greater flexibility and robustness.

This integration of tractable models empowers robots to operate more effectively in real-world scenarios characterized by uncertainty and incomplete information.

=== Validation Strategy

*- Simulated Studies:* Perform a huge amount of  plans (>5000) in randomized environments from different household layouts and different simulators using all robots we support. 
*- Reality Studies:* Perform a small amount of plans in the real world using real robots.

Evaluation: Evaluate the results looking at the following aspects:
- *Success Rate:* The primary metric. Track how often each planning approach (default and probabilistic) leads to successful completion of the task in each randomly generated environment.
- *Efficiency:* Measure the number of actions required by the robot to complete the task in each scenario (lower is better)

