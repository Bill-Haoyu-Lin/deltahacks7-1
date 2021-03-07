from flask import Flask, jsonify,request
import time
import Diabetes, Stroke


# app = Flask(__name__)
# @app.route("/bot", methods=["POST"])
# def response():
#     query = dict(request.form)['query']
#     res = query + " " + time.ctime()
#     return jsonify({"response" : res})

# if __name__=="__main__":
#     app.run(host=True)

Diabetes.pred([76,0,75,175,100,-1,0,1,1])