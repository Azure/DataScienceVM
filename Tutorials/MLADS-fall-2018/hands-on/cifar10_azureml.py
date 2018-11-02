# from https://raw.githubusercontent.com/keras-team/keras/master/examples/cifar10_cnn.py

from __future__ import print_function

# basic imports
import h5py
import numpy as np
import os
import pickle as pc

from azureml.core import Run

# configure TensorFlow to use 10% of the total GPU memory. TensorFlow will, by default, eagerly
# allocate all GPU memory for itslef. Limiting it to 10% is necessary in the hands-on lab because 
# multiple users share a VM with a single GPU. If we don't set this limit, the first TensorFlow
# process, from the first user, will allocate all GPU memory, and processes from other users
# will be unable to allocate memory.
#
# This code must run before we import Keras, or Keras will not properly load our session.
import tensorflow as tf
from keras.backend.tensorflow_backend import set_session
config = tf.ConfigProto()
config.gpu_options.per_process_gpu_memory_fraction = 0.1
set_session(tf.Session(config=config))

import keras
from keras.datasets import cifar10
from keras.preprocessing.image import ImageDataGenerator
from keras.models import Sequential
from keras.layers import Conv2D, Dense, Dropout, Activation, Flatten, MaxPooling2D


# A callback for Keras to log metrics to AzureML
class LogEpochStats(keras.callbacks.Callback):
    def __init__(self, run):
        super(LogEpochStats, self).__init__()
        self.run = run
        
    def on_epoch_end(self, epoch, logs={}):
        # log accuracies
        self.run.log('training_acc', np.float(logs['acc']))
        self.run.log('validation_acc', np.float(logs['val_acc']))
        print('got {0} {1}'.format(np.float(logs['acc'], np.float(logs['val_acc']))

             
parser = argparse.ArgumentParser()
parser.add_argument('--data-folder', type=str, dest='data_folder', default='data', help='data folder mounting point')
parser.add_argument('--batch-size', type=int, dest='batch_size', default=50, help='mini batch size for training')
parser.add_argument('--epochs', type=int, dest='epochs', default=5, help='the number of epochs')
parser.add_argument('--learning-rate', type=float, dest='learning_rate', default=0.0001, help='learning rate')
parser.add_argument('--decay', type=float, dest='decay', default=1e-6, help='decay')
args = parser.parse_args()

data_folder = os.path.join(args.data_folder, 'cifar10')
with open(os.path.join(data_folder, 'x_train'), 'rb') as f:
    x_train = pc.load(f)
with open(os.path.join(data_folder, 'y_train'), 'rb') as f:
    y_train = pc.load(f)
with open(os.path.join(data_folder, 'x_test'), 'rb') as f:
    x_test = pc.load(f)
with open(os.path.join(data_folder, 'y_test'), 'rb') as f:
    y_test = pc.load(f)

print('x_train shape:', x_train.shape)
print(x_train.shape[0], 'train samples')
print(x_test.shape[0], 'test samples')

# Convert class vectors to binary class matrices.
num_classes = 10
y_train = keras.utils.to_categorical(y_train, num_classes)
y_test = keras.utils.to_categorical(y_test, num_classes)

x_train = x_train.astype('float32')
x_test = x_test.astype('float32')
x_train /= 255
x_test /= 255

batch_size = args.batch_size

epochs = args.epochs

model = Sequential()
model.add(Conv2D(32, (3, 3), padding='same',
                 input_shape=x_train.shape[1:]))
model.add(Activation('relu'))
model.add(Conv2D(32, (3, 3)))
model.add(Activation('relu'))
model.add(MaxPooling2D(pool_size=(2, 2)))
model.add(Dropout(0.25))

model.add(Conv2D(64, (3, 3), padding='same'))
model.add(Activation('relu'))
model.add(Conv2D(64, (3, 3)))
model.add(Activation('relu'))
model.add(MaxPooling2D(pool_size=(2, 2)))
model.add(Dropout(0.25))

model.add(Flatten())
model.add(Dense(512))
model.add(Activation('relu'))
model.add(Dropout(0.5))
model.add(Dense(num_classes))
model.add(Activation('softmax'))

# initiate RMSprop optimizer
opt = keras.optimizers.rmsprop(lr=args.learning_rate, decay=args.decay)

# Let's train the model using RMSprop
model.compile(loss='categorical_crossentropy',
              optimizer=opt,
              metrics=['accuracy'])

# start an Azure ML run
run = Run.get_context()

model.fit(x_train, y_train,
          batch_size=batch_size,
          epochs=epochs,
          validation_data=(x_test, y_test),
          shuffle=True,
          callbacks = [LogEpochStats(run)])

score = model.evaluate(x_train, y_train, verbose=0)
print(score)
final_acc = score[1]
run.log('final_acc', np.float(final_acc))

os.makedirs('./outputs/model', exist_ok=True)
# files saved in the "./outputs" folder are automatically uploaded into run history
model.save('./outputs/model/cifar10-keras.model')