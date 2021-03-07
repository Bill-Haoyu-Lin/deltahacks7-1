from flask import Flask, jsonify,request
import Diabetes, Stroke


app = Flask(__name__)
@app.route("/", methods=['POST'])
def response():
    if request.method == "POST":
        #request get format should be {'ans' : [76,0,75,175,100,-1,0,1,1] }
        chance = ""
        sym = ""
        query = (request.get_json()["ans"][1:-1]).split(",")
        query = [int(num) for num in query]
        if len(query) == 9:
            chance = Diabetes.pred(query)
            sym = "diabetes"
        elif len(query) == 10:
            chance = Stroke.pred(query)
            sym = "stroke"
        #return json format as [chance, symptom]
        return jsonify({"response" : [chance, sym]})

if __name__=="__main__":
    app.run(host='0.0.0.0',debug=True)

# print(Diabetes.pred([76,0,75,175,100,-1,0,1,1]))
# print(Stroke.pred([76,0,75,175,100,-1,0,1,0,1]))
