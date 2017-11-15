import numpy as np
import os
import sys
import cntk
from cntk.layers import Convolution2D, MaxPooling, Dense, Dropout
from utils import *
import argparse
from cntk.train.distributed import Communicator, mpi_communicator

# Hyperparams
EPOCHS = 1
BATCHSIZE = 64 * 4
LR = 0.01
MOMENTUM = 0.9
N_CLASSES = 10

def create_symbol():
    # Weight initialiser from uniform distribution
    # Activation (unless states) is None
    with cntk.layers.default_options(init = cntk.glorot_uniform(), activation = cntk.relu):
        x = Convolution2D(filter_shape=(3, 3), num_filters=50, pad=True)(features)
        x = Convolution2D(filter_shape=(3, 3), num_filters=50, pad=True)(x)
        x = MaxPooling((2, 2), strides=(2, 2), pad=False)(x)
        x = Dropout(0.25)(x)

        x = Convolution2D(filter_shape=(3, 3), num_filters=100, pad=True)(x)
        x = Convolution2D(filter_shape=(3, 3), num_filters=100, pad=True)(x)
        x = MaxPooling((2, 2), strides=(2, 2), pad=False)(x)
        x = Dropout(0.25)(x)

        x = Dense(512)(x)
        x = Dropout(0.5)(x)
        x = Dense(N_CLASSES, activation=None)(x)
        return x

def init_model(m):
    progress_writers = [cntk.logging.ProgressPrinter(
        freq=int(BATCHSIZE / 2),
        rank=cntk.train.distributed.Communicator.rank(),
        num_epochs=EPOCHS)]

    # Loss (dense labels); check if support for sparse labels
    loss = cntk.cross_entropy_with_softmax(m, labels)
    # Momentum SGD
    # https://github.com/Microsoft/CNTK/blob/master/Manual/Manual_How_to_use_learners.ipynb
    # unit_gain=False: momentum_direction = momentum*old_momentum_direction + gradient
    # if unit_gain=True then ...(1-momentum)*gradient
    local_learner = cntk.momentum_sgd(m.parameters,
                                lr=cntk.learning_rate_schedule(LR, cntk.UnitType.minibatch) ,
                                momentum=cntk.momentum_schedule(MOMENTUM),
                                unit_gain=False)

    distributed_learner = cntk.train.distributed.data_parallel_distributed_learner(local_learner)

    trainer = cntk.Trainer(m, (loss, cntk.classification_error(m, labels)), [distributed_learner], progress_writers)

    return trainer, distributed_learner

parser = argparse.ArgumentParser()
parser.add_argument('--input_dir')
parser.add_argument('--output_dir')

print(sys.argv)

args = parser.parse_args()

# Data into format for library
x_train, x_test, y_train, y_test = cifar_for_library(download_dir=args.input_dir, channel_first=True, one_hot=True)
# CNTK format
y_train = y_train.astype(np.float32)
y_test = y_test.astype(np.float32)
print(x_train.shape, x_test.shape, y_train.shape, y_test.shape)
print(x_train.dtype, x_test.dtype, y_train.dtype, y_test.dtype)

# Placeholders
features = cntk.input_variable((3, 32, 32), np.float32)
labels = cntk.input_variable(N_CLASSES, np.float32)
# Load symbol
sym = create_symbol()

def save_model(model, learner, file_name):
    if learner.communicator().is_main():
        model.save(file_name)

trainer, learner = init_model(sym)

for j in range(EPOCHS):
    for data, label in yield_mb(x_train, y_train, BATCHSIZE, shuffle=True):
        trainer.train_minibatch({features: data, labels: label})
    # Log (this is just last batch in epoch, not average of batches)
    eval_error = trainer.previous_minibatch_evaluation_average
    print("Epoch %d  |  Accuracy: %.6f" % (j+1, (1-eval_error)))
    
z = cntk.softmax(sym)

save_model(sym, learner, "{}/cifar_final.model".format(args.output_dir))

n_samples = (y_test.shape[0]//BATCHSIZE)*BATCHSIZE
y_guess = np.zeros(n_samples, dtype=np.int)
y_truth = np.argmax(y_test[:n_samples], axis=-1)
c = 0
for data, label in yield_mb(x_test, y_test, BATCHSIZE):
    predicted_label_probs = z.eval({features : data})
    y_guess[c*BATCHSIZE:(c+1)*BATCHSIZE] = np.argmax(predicted_label_probs, axis=-1)
    c += 1

print("Accuracy: ", sum(y_guess == y_truth)/len(y_guess))

cntk.train.distributed.Communicator.finalize()
