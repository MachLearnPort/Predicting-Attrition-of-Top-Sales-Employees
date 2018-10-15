# Predicting turn over of top Sales employees

## Overview

This model was developed based on several layers of supervised and unsupervised machine learning (ML) models. 
This POC has a 3-faceted objective:

1.	Identify high risk employees;
2.	generate retention strategies for high risk employees; and,
3.	optimize the allocation of incentive resources

Firstly, the model munges historical and current sales employee data (i.e. employee attrition/retention, workforce analytics, performance evaluations, sales generation, etc.). 
This data is then fed into a gradient boost algorithm, which identifies the most influential variables associated with attrition. 
The data is then passed to trained NN models, which predict the probability of attrition for current employees. 
This prediction is then combined with an economic model to assess the risk of each employee (R-score). 
The R-score identifies which employees pose the greatest risk to an organization’s bottom line (i.e revenue generation and profitability). 
The data of the top 20% high risk employees are then fed into step 5, where a genetic algorithm modifies the highest influential control variables to generate a retention strategy, tailored to that individual. 