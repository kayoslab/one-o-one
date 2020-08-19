import tensorflow as tf
from tensorflow import keras
from keras.utils import np_utils
from keras.datasets import mnist
from PIL import Image
import matplotlib.pyplot as plt
import numpy as np
import coremltools
import os

# load data
# To load images to features and labels
def load_images_to_data(image_label, image_directory, features_data, label_data):
    list_of_files = os.listdir(image_directory)
    print('Adding .jpg files from: ' + image_directory + '.')
    print('Adding ' + str(len(list_of_files)) + ' files. This might take a while.')
    for file in list_of_files:
        image_file_name = os.path.join(image_directory, file)
        if ".jpg" in image_file_name:
            img = Image.open(image_file_name).convert("L")
            img = np.resize(img, (28,28,1))
            im2arr = np.array(img)
            im2arr = im2arr.reshape(1,28,28,1)
            features_data = np.append(features_data, im2arr, axis=0)
            label_data = np.append(label_data, [image_label], axis=0)
    return features_data, label_data

batch_size = 32
epochs = 16
number_of_classes = 10
modelGeneration = True
additionalImages = True
class_names =  ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']

if modelGeneration == True:
    (x_train, y_train), (x_test, y_test) = mnist.load_data()

    # Reshaping to format which CNN expects (batch, height, width, channels)
    x_train = x_train.reshape(
        x_train.shape[0],
        x_train.shape[1],
        x_train.shape[2],
        1
    ).astype('float32')

    x_test = x_test.reshape(
        x_test.shape[0],
        x_test.shape[1],
        x_test.shape[2],
        1
    ).astype('float32')

    if additionalImages == True:
        x_train, y_train = load_images_to_data('0', 'output/train/0', x_train, y_train)
        x_train, y_train = load_images_to_data('1', 'output/train/1', x_train, y_train)
        x_train, y_train = load_images_to_data('2', 'output/train/2', x_train, y_train)
        x_train, y_train = load_images_to_data('3', 'output/train/3', x_train, y_train)
        x_train, y_train = load_images_to_data('4', 'output/train/4', x_train, y_train)
        x_train, y_train = load_images_to_data('5', 'output/train/5', x_train, y_train)
        x_train, y_train = load_images_to_data('6', 'output/train/6', x_train, y_train)
        x_train, y_train = load_images_to_data('7', 'output/train/7', x_train, y_train)
        x_train, y_train = load_images_to_data('8', 'output/train/8', x_train, y_train)
        x_train, y_train = load_images_to_data('9', 'output/train/9', x_train, y_train)
        x_test, y_test = load_images_to_data('0', 'output/test/0', x_test, y_test)
        x_test, y_test = load_images_to_data('1', 'output/test/1', x_test, y_test)
        x_test, y_test = load_images_to_data('2', 'output/test/2', x_test, y_test)
        x_test, y_test = load_images_to_data('3', 'output/test/3', x_test, y_test)
        x_test, y_test = load_images_to_data('4', 'output/test/4', x_test, y_test)
        x_test, y_test = load_images_to_data('5', 'output/test/5', x_test, y_test)
        x_test, y_test = load_images_to_data('6', 'output/test/6', x_test, y_test)
        x_test, y_test = load_images_to_data('7', 'output/test/7', x_test, y_test)
        x_test, y_test = load_images_to_data('8', 'output/test/8', x_test, y_test)
        x_test, y_test = load_images_to_data('9', 'output/test/9', x_test, y_test)

    # normalize inputs from 0-255 to 0-1
    #x_train/=255
    #x_test/=255

    # one hot encode
    y_train = np_utils.to_categorical(y_train, number_of_classes)
    y_test = np_utils.to_categorical(y_test, number_of_classes)

    # create model
    model = tf.keras.Sequential()

    model.add(tf.keras.layers.Conv2D(32, (3, 3), input_shape=(x_train.shape[1], x_train.shape[2], 1), activation='relu'))
    model.add(tf.keras.layers.Conv2D(64, kernel_size=(3, 3), activation='relu'))
    model.add(tf.keras.layers.MaxPooling2D(pool_size=(2, 2)))
    model.add(tf.keras.layers.Dropout(0.25))

    model.add(tf.keras.layers.Conv2D(128, kernel_size=(3, 3), activation='relu'))
    model.add(tf.keras.layers.MaxPooling2D(pool_size=(2, 2)))
    model.add(tf.keras.layers.Conv2D(128, kernel_size=(3, 3), activation='relu'))
    model.add(tf.keras.layers.MaxPooling2D(pool_size=(2, 2)))
    model.add(tf.keras.layers.Dropout(0.25))

    model.add(tf.keras.layers.Flatten())
    model.add(tf.keras.layers.Dense(1024, activation='relu'))
    model.add(tf.keras.layers.Dropout(0.5))
    model.add(tf.keras.layers.Dense(10, activation='softmax'))

    model.compile(
        loss='categorical_crossentropy',
        optimizer=tf.keras.optimizers.Adam(lr=0.0001, decay=1e-6),
        metrics=['accuracy']
    )

    # Train the model
    model.fit(
        x_train,
        y_train,
        validation_data=(x_test, y_test),
        epochs=epochs,
        batch_size=batch_size,
        shuffle=True
    )

    # Evaluate the model
    scores = model.evaluate(
        x_test,
        y_test
    )
    model.summary()

    print('Loss: %.3f' % scores[0])
    print('Accuracy: %.3f' % scores[1])

    # save the keras model to disk
    model.save("MNIST.h5")
coreml_model = coremltools.converters.tensorflow.convert(
    "MNIST.h5",
    input_names=['conv2d_input'],
    output_names=['output'],
    class_labels=class_names,
    image_input_names='conv2d_input'
)
coreml_model.author = 'cr0ss'
coreml_model.short_description = 'Digit Recognition with MNIST'
coreml_model.input_description['conv2d_input'] = 'Takes as input an image'
#coreml_model.output_description['output'] = 'Prediction of Digit'

# save the Apple mlmodel to disk
coreml_model.save("MNIST.mlmodel")
