#!/usr/bin/env python
# coding: utf-8

# In[ ]:


import tensorflow as tf
from sklearn.model_selection import train_test_split
import pandas as pd
from keras.models import Sequential
from keras.layers import Dropout, Activation, Dense, Flatten
from keras.callbacks import ModelCheckpoint
import numpy as np
'''Call function Pred()to predict the chance of getting stroke
    sample input:pred([76,0,75,175,100,-1,0,1,0,1])
    which stands for Age	Gender	Weight	Height	Pulse	Numbness	Double_vision	Trouble_seeing	Dizziness'''
def pre(inp):
    #Age Modification#
    if inp[0]>70:
        inp[0]=1
    elif inp[0]<=70 and inp[0]>60:
        inp[0]=0.8
    elif inp[0]<=60 and inp[0]>50:
        inp[0]=0.4
    else:
        df.iloc[i,0]=0.2
    
    #weight Modification#
    if inp[2]>90:
        inp[2]=1
    elif inp[2]<=90 and inp[2]>80:
        inp[2]=0.8
    elif inp[2]<=80 and inp[2]>65:
        inp[2]=0.4
    else:
        inp[2]=0.2
    
    inp[3]=0.9
    if inp[4]>85:
        inp[4]=1
    else:
        inp[4]=0.7
    return np.array([inp])
def pred(inp):
    inp=pre(inp)
    model = Sequential()
    df=pd.read_csv('Stroke_fake.csv')
    df.set_index('Index',inplace=True)
    label=df.iloc[:,-1].values
    fea=df.iloc[:,0:-1].values
    X_train, X_test, y_train, y_test = train_test_split(fea, label, test_size=0.3, random_state=10)
    activation = 'relu'
    model.add(Dense(units=10,activation='relu')) #30 units(neurons) because X_train has 30 parameters
    model.add(Dense(units=8,activation='relu')) #15 units(neurons) because we can pick a number of our discretion
    model.add(Dense(units=8,activation='relu'))
    model.add(Dense(units=4,activation='relu'))
    model.add(Dense(units=1, activation='relu'))
    model.compile(loss='mean_absolute_error', optimizer='adam', metrics=['mean_absolute_error'])
    model.fit(X_train, y_train, epochs=1, validation_split = 0.2,validation_data=(X_test, y_test))
    weights='15Check-802--0.05875.hdf5'
    model.load_weights(weights)
    return ('The chance of having stroke is {}%'.format("%.2f" % (model.predict(inp)[0][0]*100)))

