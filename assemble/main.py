from flask import Flask, jsonify,request
import Diabetes, Stroke

app = Flask(__name__)
@app.route("/", methods=['POST'])
def response():
    if request.method == "POST":
        #request get format should be {'ans' : [76,0,75,175,100,-1,0,1,1]}
        chance, sym, suggestion = "", "", ""
        query = (request.get_json()["ans"][1:-1]).split(",")
        query = [int(num) for num in query]
        age, gender, weight, height = query[0], query[1], query[2], query[3]
        ideal_weight, over_rate = "", ""
        if gender == 0:
            ideal_weight = (height - 70) * 0.6
        elif gender == 1:
            ideal_weight = (height - 80) * 0.7
        over_rate = ((weight - ideal_weight) / ideal_weight) * 100

        if over_rate >= 20:
            suggestion += "You are over weight!! Try to loss weight if needed.\n"
        elif over_rate < 20:
            suggestion += "You need more protein in your diet, remember to adopt a healthy diet low in sodium and rich in potassiumn.\n"
        else:
            suggestion +=  "Your weight is close to ideal weight, keep healthy habits! Remember to dopt a healthy diet low in sodium and rich in potassium.\n"

        if len(query) == 9:
            if float(Diabetes.pred(query)) <= 0.3:
                chance = "low"
            elif float(Diabetes.pred(query)) > 0.3 and float(Diabetes.pred(query)) < 0.6:
                chance = "moderate"
            elif float(Diabetes.pred(query)) >= 0.6:
                chance = "high"
            sym = "diabetes"

            if query[8]>0 or query[5]>0:
                suggestion+='Limit takeaway and processed food, decrease beverage intake \n'
            if query[7]>0:
                suggestion+='Check your doctor more frequently \n Try more exercises \n'
            if query[6]>0:
                suggestion+='Eat balance and healthy diet, try to decrease the fats intake \n'

        elif len(query) == 10:
            if float(Stroke.pred(query)) <= 0.3:
                chance = "low"
            elif float(Stroke.pred(query)) > 0.3 and float(Stroke.pred(query)) < 0.6:
                chance = "moderate"
            elif float(Stroke.pred(query)) >= 0.6:
                chance = "high"
            sym = "stroke"

 

            if query[8]>0 or query[6]>0:
                suggestion +='•Know and control your blood pressure \n'
            if query[7]>0:
                suggestion +='•Identify and manage atrial fibrillation \n'
            if query[5]>0:
                suggestion +='•Know and control your blood sugar and cholesterol\n'
            if query[9]>0:
                suggestion +='•If you drink alcohol, do so in moderation \n'

        #return json format as [chance, symptom]
        return jsonify({"response" : [chance, sym, suggestion]})

if __name__=="__main__":
    app.run(host='0.0.0.0',debug=True)

# print(Diabetes.pred([76,0,75,175,100,-1,0,1,1]))
# print(Stroke.pred([76,0,75,175,100,-1,0,1,0,1]))

#Those are the warnning sign of Stroke, please be aware of them.