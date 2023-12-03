"""
    random search optimizer performs random search.
    the code is only for example demonstration.
    ``` 
        python random-search-optimizer.py \
            -o [your experiment outputs directory] \
            -q [the number of your queries]
    ```
    you can specify more options to test your optimizer. please use
    ```
        python random-search-optimizer.py -h
    ```
    to check.
"""


import torch
import numpy as np
from iccad_contest.abstract_optimizer import AbstractOptimizer
from iccad_contest.design_space_exploration import experiment
from iccad_contest.functions.problem import get_pareto_frontier


class RandomSearchWEarlyStoppingOptimizer(AbstractOptimizer):
    primary_import = "iccad_contest"

    def __init__(self, design_space):
        """
            build a wrapper class for an optimizer.

            parameters
            ----------
            design_space: <class "MicroarchitectureDesignSpace">
        """
        AbstractOptimizer.__init__(self, design_space)
        self.n_suggestions = 1
        self.x = []
        self.y = []
        self.threshold = 5

    def suggest(self):
        """
            get a suggestion from the optimizer.

            returns
            -------
            next_guess: <list> of <list>
                list of `self.n_suggestions` suggestion(s).
                each suggestion is a microarchitecture embedding.
        """
        x_guess = np.random.choice(
            range(1, self.design_space.size + 1),
            size=self.n_suggestions
        )
        return [
            self.design_space.vec_to_microarchitecture_embedding(
                self.design_space.idx_to_vec(_x_guess)
            ) for _x_guess in x_guess
        ]

    def observe(self, x, y):
        """
            send an observation of a suggestion back to the optimizer.

            parameters
            ----------
            x: <list> of <list>
                the output of `suggest`.
            y: <list> of <list>
                corresponding values where each `x` is mapped to.
        """
        for _x in x:
            self.x.append(_x)
        for _y in y:
            self.y.append(_y)
        # NOTICE: `self.early_stopping` can be modified to support the early stopping criterion.
        # we only use a very naive way to implement the early stopping criterion just for demonstration only.
        if get_pareto_frontier(torch.Tensor(self.y)).shape[0] > self.threshold:
            self.early_stopping = True



if __name__ == "__main__":
    experiment(RandomSearchWEarlyStoppingOptimizer)
