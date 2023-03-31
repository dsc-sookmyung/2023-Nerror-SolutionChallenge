from flask_restful import reqparse
from flask import Flask, jsonify,request

import numpy as np
import pickle as p
import json
import joblib
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression

app = Flask(__name__)

@app.route('/predict/', methods=['POST'])
def predict():
    if request.method == 'POST':
        df=pd.read_csv('./maildataset.csv',encoding='latin-1')
        
        df1=df.where(pd.notnull(df),'')
        df1["v1"].replace('ham',1,inplace=True)
        df1["v1"].replace('spam',0,inplace=True)

        x=df1["v2"]
        y=df1["v1"]

        x_train,x_test,y_train,y_test=train_test_split(x,y,train_size=0.8,random_state=0)

        feature_extraction= TfidfVectorizer(min_df=1,stop_words='english',lowercase= True)
        x_train_feature=feature_extraction.fit_transform(x_train)
        x_test_feature=feature_extraction.transform(x_test)

        y_train=y_train.astype('int')
        y_test=y_test.astype('int')

        model_from_joblib = joblib.load('./mail_model.pkl')
        model_from_joblib.fit(x_train_feature,y_train)

        # 메일 내용 -> 모델 예측 요청
        parser=reqparse.RequestParser()
        parser.add_argument('msg',type=str)

        input_mail=[]
        args=parser.parse_args()
        input_mail.append(args['msg'])
        print(input_mail)

        # 벡터로 변환
        input_data_features = feature_extraction.transform(input_mail)

        # 예측
        prediction = model_from_joblib.predict(input_data_features)
        print(prediction)

        if (prediction[0]==1):
            result='Ham mail'
        else:
            result='Spam mail'

    return jsonify(result), 200

if __name__=="__app__":
    app.run(debug=True)