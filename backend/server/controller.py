from datetime import datetime
import json
import random
import time
from flask import Flask, request, session
from flask_socketio import SocketIO
from py2neo import Graph, Node, NodeMatcher, Relationship
from passlib.hash import bcrypt
from flask_mail import *
app = Flask(__name__)

graph = Graph()

with open('config.json', 'r') as f:
    param = json.load(f)['param']

app.config['MAIL_SERVER'] = 'smtp.office365.com'
app.config['MAIL_PORT'] = '587'
app.config['MAIL_USERNAME'] = param['email']
app.config['MAIL_PASSWORD'] = param['password']
app.config['MAIL_USE_TLS'] = True
app.config['MAIL_USE_SSL'] = False

mail = Mail(app)

socketio = SocketIO(app)


@socketio.on('connect')
def connect():
    print("a client connected")


@app.route('/install', methods=['POST'])
def install():
    if request.method == "POST":
        print(request.json)
        mac_add = request.json["macAdd"]
        ip_add = request.json["ipAdd"]
        name = request.json["name"]
        type = request.json['moduleType']
        sensors = request.json['sensors']

        matcher = NodeMatcher(graph)
        resp = matcher.match("ESP", mac_add=mac_add).first()
        if resp is not None:
            return {'message': 'already exist'}

        esp = Node("ESP", name=name, mac_add=mac_add, ip_add=ip_add, type=type)
        graph.create(esp)
        query = """ 
            MATCH (e:ESP)
            WHERE e.mac_add=$mac_add
            SET e.esp_id=$esp_id + ID(e)       
            CREATE (e)-[r:Connected]->(s:Sensors{name:$name,detects:$detects})
            """
        for k in sensors:

            graph.run(query, mac_add=mac_add, name=k['name'],
                      detects=k['detects'], esp_id='esp-neo-')

    return {'message': 'success'}


# global mac_add
# mac_add = ''


@app.route('/get_data', methods=['POST'])
def getdata():
    v_t = time.time()

    r_t = str(v_t).split('.')[0]
    c_t = float(r_t)
    matcher = NodeMatcher(graph)
    if request.method == 'POST':
        res = request.json
        resp = matcher.match("ESP", mac_add=res['MAC']).first()
        print(resp['esp_id'])
        if res != {}:
            # session['mac'] = mac_add
            socketio.emit('msg'+res['MAC']+resp['esp_id'], {'data': res})

    # ******************************

            thres = {'CO': 200, 'CH4': 300, 'LPG': 400, 'Smoke': 800}

            # print('each hour run')

            query = """
                    MATCH (e:ESP)-[r:Connected]->(s:Sensors)
                    WHERE e.mac_add=$mac_add AND s.detects=$name
                    CREATE (s)-[d:Connected]->(g:Gas{name:$name,value:$value,time:$time_val})
                    """
            alertQuery = """
                    MATCH (e:ESP)-[r:Connected]->(s:Sensors)
                    WHERE e.mac_add=$mac_add AND s.detects=$name
                    CREATE (s)-[d:Alert]->(g:Gas{name:$name,value:$value,time:$time_val})
                    """
            for k, v in res.items():
                if k != 'MAC':
                    if (int(v) > thres[k]):
                        graph.run(alertQuery, mac_add=res['MAC'],
                                  name=k, value=v, time_val=c_t)

                if k != 'MAC':
                    graph.run(query, mac_add=res['MAC'],
                              name=k, value=v, time_val=c_t)
    # ****************************
    return {'message': 'success'}


def hourly_fun(query, m_query, mac_add, start_time, end_time):

    print(end_time)
    qres = graph.run(query, mac_add=mac_add,
                     st_time=start_time, e_time=end_time)

    data = {'CO': [], 'CH4': [], 'LPG': [], 'Smoke': []}
    arr = []
    n_res = 0
    n_data = {}
    for i in qres:
        name = i.get('g')['name']
        val = i.get('g')['value']

        res = int(val)
        for k, v in data.items():
            if (k == name):
                v.append(res)
    for a, b in data.items():
        n_data['name'] = a
        if (len(b) != 0):
            n_data['max_value'] = max(b)
            n_data['min_value'] = min(b)
            for i in range(0, 2):
                if i == 0:
                    max_t = graph.run(
                        m_query, name=a, val=str(n_data['max_value']), mac_add=mac_add,
                        st_time=start_time, e_time=end_time)
                    for t in max_t:
                        n_data['max_time'] = set_time(
                            t.get('MAX(g.time)'))['time']
                if i == 1:
                    min_t = graph.run(
                        m_query, name=a, val=str(n_data['min_value']), mac_add=mac_add,
                        st_time=start_time, e_time=end_time)
                    for t in min_t:
                        n_data['min_time'] = set_time(
                            t.get('MAX(g.time)'))['time']

        total = 0
        count = 0
        for c in b:
            count += 1
            total = total + c
            n_res = total/count
            n_data['avg'] = int(n_res)

        arr.append(n_data)
        n_data = {}

    return arr


def set_time(t):
    d = {}
    d_t = ''
    if (9 < time.localtime(t)[2] & time.localtime(t)[2] <= 31):
        h_t = time.asctime(time.localtime(t)).split(' ')[3]
    else:
        h_t = time.asctime(time.localtime(t)).split(' ')[4]
        d_t = time.asctime(time.localtime(t)).split(' ')[0]

    # new_t = time(h_t)
    new_t = datetime.strptime(h_t, "%H:%M:%S")
    # d['time'] = h_t
    d['time'] = datetime.strftime(new_t, "%I:%M %p")

    d['datetime'] = d_t + ' ' + d['time']

    return d


@app.route('/last_hour', methods=['GET'])
def last_hour():
    if request.method == 'GET':
        res = request.args

    mac_add = res['mac_add']
    v_t = time.time()

    r_t = str(v_t).split('.')[0]
    c_t = float(r_t)

    query = """
        MATCH p=(e:ESP)-[:Connected]->(s:Sensors)-[:Connected]->(g:Gas)
        WHERE e.mac_add=$mac_add AND g.time > $st_time AND g.time < $e_time
        RETURN g
        """
    max_query = """
        MATCH p=(e:ESP)-[:Connected]->(s:Sensors)-[:Connected]->(g:Gas)
        WHERE e.mac_add=$mac_add AND g.name=$name AND g.value=$val AND g.time > $st_time AND g.time < $e_time
        RETURN MAX(g.time)
        """
    val = hourly_fun(query, max_query, mac_add, c_t-3600, c_t)
    return val


@app.route('/alert', methods=['GET'])
def alert():
    if request.method == 'GET':
        res = request.args

        mac_add = res['mac_add']
        print(res)
    v_t = time.time()

    r_t = str(v_t).split('.')[0]
    c_t = float(r_t)
    query = """
        MATCH p=(e:ESP)-[:Connected]->(s:Sensors)-[:Alert]->(g:Gas)
        WHERE e.mac_add=$mac_add AND g.time > $st_time AND g.time < $e_time
        RETURN g
        """

    max_query = """
        MATCH p=(e:ESP)-[:Connected]->(s:Sensors)-[:Alert]->(g:Gas)
        WHERE e.mac_add=$mac_add AND g.name=$name AND g.value=$val AND g.time > $st_time AND g.time < $e_time
        RETURN MAX(g.time)
        """
    new_arr = []
    for i in range(0, 24):
        d = {}
        et = c_t - (i*3600)
        st = et - 3600
        res_arr = hourly_fun(query, max_query, mac_add, st, et)
        d = set_time(et)
        res_arr.append(d)

        new_arr.append(res_arr)

        res_arr = []
    print(new_arr)
    return new_arr


@app.route('/last_hour_chart', methods=['GET'])
def last_hour_chart():
    if request.method == 'GET':
        res = request.args

    mac_add = res['mac_add']
    v_t = time.time()

    r_t = str(v_t).split('.')[0]
    c_t = float(r_t)

    query = """
        MATCH p=(e:ESP)-[:Connected]->(s:Sensors)-[:Connected]->(g:Gas)
        WHERE e.mac_add=$mac_add AND g.time > $st_time AND g.time < $e_time
        RETURN g
        """

    max_query = """
        MATCH p=(e:ESP)-[:Connected]->(s:Sensors)-[:Connected]->(g:Gas)
        WHERE e.mac_add=$mac_add AND g.name=$name AND g.value=$val AND g.time > $st_time AND g.time < $e_time
        RETURN MAX(g.time)
        """
    new_arr = []
    data = {}
    d = {}

    for i in range(0, 7):
        # print(i)
        val = ''
        if i == 0:
            val = 'now'
        if i == 1:
            val = 'fifty'
        if i == 2:
            val = 'forty'
        if i == 3:
            val = 'thirty'
        if i == 4:
            val = 'twenty'
        if i == 5:
            val = 'ten'
        if i == 6:
            val = 'zero'

        et = c_t - (i*600)
        st = et - 600
        res_arr = hourly_fun(query, max_query, mac_add, st, et)
        d = set_time(et)
        res_arr.append(d)
        data[val] = res_arr
        res_arr = []
        d = {}

    new_arr.append(data)

    return new_arr


@app.route('/last_24hour_chart')
def last_24hr_chart():
    if request.method == 'GET':
        res = request.args

    mac_add = res['mac_add']
    v_t = time.time()

    r_t = str(v_t).split('.')[0]
    c_t = float(r_t)
    query = """
        MATCH p=(e:ESP)-[:Connected]->(s:Sensors)-[:Connected]->(g:Gas)
        WHERE e.mac_add=$mac_add AND g.time > $st_time AND g.time < $e_time
        RETURN g
        """

    max_query = """
        MATCH p=(e:ESP)-[:Connected]->(s:Sensors)-[:Connected]->(g:Gas)
        WHERE e.mac_add=$mac_add AND g.name=$name AND g.value=$val AND g.time > $st_time AND g.time < $e_time
        RETURN MAX(g.time)
        """
    new_arr = []
    #  new_arr = []
    data = {}
    time_c = 3600
    d = {}

    for i in range(0, 6):
        # print(i)
        val = ''
        if i == 1:
            val = 'nine'
        if i == 2:
            val = 'forteen'
        if i == 3:
            val = 'nineteen'
        if i == 4:
            val = 'twen_four'
        if i == 5:
            val = 'twen_nine'
        if (i == 0):
            val = 'four'
            et = c_t - (i*18000)
            st = c_t - ((i+1)*18000-time_c)
            res_arr = hourly_fun(query, max_query, mac_add, st, et)
            d = set_time(et)
            res_arr.append(d)
            data[val] = res_arr
            res_arr = []
            d = {}

        else:

            et = c_t - ((i*18000)-time_c)
            st = c_t - (((i+1)*18000)-time_c)
            res_arr = hourly_fun(query, max_query, mac_add, st, et)
            d = set_time(et)
            res_arr.append(d)
            data[val] = res_arr
            res_arr = []
            d = {}

    new_arr.append(data)

    return new_arr


@app.route('/last_24_hour', methods=['GET'])
def last_24_route():
    if request.method == 'GET':
        res = request.args

    mac_add = res['mac_add']
    v_t = time.time()

    r_t = str(v_t).split('.')[0]
    c_t = float(r_t)

    query = """
        MATCH p=(e:ESP)-[:Connected]->(s:Sensors)-[:Connected]->(g:Gas)
        WHERE e.mac_add=$mac_add AND g.time > $st_time AND g.time < $e_time
        RETURN g
        """

    max_query = """
        MATCH p=(e:ESP)-[:Connected]->(s:Sensors)-[:Connected]->(g:Gas)
        WHERE e.mac_add=$mac_add AND g.name=$name AND g.value=$val AND g.time > $st_time AND g.time < $e_time
        RETURN MAX(g.time)
        """
    new_arr = []

    for i in range(0, 24):
        d = {}
        et = c_t - (i*3600)
        st = c_t - (i+1)*3600
        res_arr = hourly_fun(query, max_query, mac_add, st, et)
        d = set_time(et)
        res_arr.append(d)

        new_arr.append(res_arr)

        res_arr = []

    return new_arr


@app.route('/each_hour', methods=['GET'])
def eachhour():

    v_t = time.time()

    r_t = str(v_t).split('.')[0]
    c_t = float(r_t)

    query = """
        MATCH p=(e:ESP)-[:Connected]->(s:Sensors)-[:Connected]->(g:Gas)
        WHERE e.mac_add=$mac_add AND g.time > $st_time AND g.time < $e_time
        DETACH DELETE p
        """

    alertquery = """
        MATCH p=(e:ESP)-[:Connected]->(s:Sensors)-[:Alert]->(g:Gas)
        WHERE e.mac_add=$mac_add AND g.time > $st_time AND g.time < $e_time
        DETACH DELETE p
        """

    print('each hour run')

    graph.run(query, st_time=c_t-90000, end_time=c_t-86400)
    graph.run(alertquery, st_time=c_t-90000, end_time=c_t-86400)

    return {'message': 'success'}


@app.route('/each_min', methods=['GET'])
def eachmin():
    if request.method == 'GET':
        mac_add = request.args['mac_add']
    v_t = time.time()

# convert time into string and remove floating point
    r_t = str(v_t).split('.')[0]

# again convrt string time value to float
    c_t = float(r_t)

    query = """
        MATCH p=(e:ESP)-[:Connected]->(s:Sensors)-[:Connected]->(g:Gas)
        WHERE e.mac_add=$mac_add AND g.time > $st_time AND g.time < $e_time
        RETURN g
        """

    qres = graph.run(query, mac_add=mac_add, st_time=c_t-30, e_time=c_t)

    data = {'CO': [], 'CH4': [], 'LPG': [], 'Smoke': []}
    max_val = {}
    if qres:
        for i in qres:
            val = i.get('g')['value']
            name = i.get('g')['name']
            res = int(val)
            for k, v in data.items():
                if (k == name):
                    v.append(res)

        for a, b in data.items():
            if (len(b) != 0):
                max_val[a] = max(b)
    print(max_val)
    return {'data': max_val}


@app.route("/update_user", methods=['POST'])
def update():

    if request.method == "POST":
        fname = request.json["fname"]
        lname = request.json["lname"]
        email = request.json["email"]
        phone_num = request.json["phoneNum"]
        address = request.json["address"]
        city = request.json["city"]
        mac_add = request.json["macAdd"]
        ip_add = request.json["ipAdd"]
        gender = request.json['gender']

    query = """
        MATCH (n:User)
        WHERE n.email=$email
        SET n.fname=$fname
        SET n.lname=$lname
        SET n.phone_num=$phone_num
        SET n.address=$address
        SET n.city=$city
        SET n.mac_add=$mac_add
        SET n.ip_add=$ip_add
        SET n.gender=$gender

        RETURN n
        """
    print('update run')
    graph.run(query, fname=fname, lname=lname, phone_num=phone_num, address=address,
              city=city, ip_add=ip_add, mac_add=mac_add, email=email, gender=gender)

    return {'message': 'success'}


@app.route('/get_user')
def get_user():
    if request.method == "GET":
        res = request.args
    email = res["email"]
    matcher = NodeMatcher(graph)
    print(session.get('mac'))

    user = matcher.match("User", email=email).first()
    data = {'fname': user['fname'], 'lname': user['lname'], 'city': user['city'], 'mac_add': user['mac_add'],
            'ip_add': user['ip_add'], 'phone_num': user['phone_num'], 'gender': user['gender'],
            'email': user['email'], 'address': user['address']}

    return data


@app.route('/get_sensors', methods=['GET'])
def get_sensors():

    if request.method == "GET":
        res = request.args

    query = """
            MATCH (e:ESP)-[r:Connected]->(s:Sensors)
            WHERE e.mac_add=$mac_add AND e.type=$type AND e.esp_id=$esp_id
            RETURN s
           """

    data = graph.run(
        query, mac_add=res['mac_add'], type=res['type'], esp_id=res['esp_id'])

    sensor = []
    sens_data = {}

    for i in data:
        name = i.get('s')['name']
        detects = i.get('s')['detects']
        # pin = i.get('s')['pin']

        sens_data['name'] = name
        sens_data['detects'] = detects
        # sens_data['pin'] = pin

        sensor.append(sens_data)
        sens_data = {}

        print(sensor)
    if sensor == []:
        return {'response': 'No Sensor'}

    return {'response': sensor}


@app.route('/get_esp', methods=['GET'])
def get_esp():

    if request.method == "GET":
        email = request.args['email']
    # print(res)
    matcher = NodeMatcher(graph)
    user = matcher.match("User", email=email).first()

    esp = matcher.match("ESP", mac_add=user['mac_add']).first()
    if not esp:
        return {'message': 'failed'}
    data = {'esp': esp, 'user': user}
    # print(esp)
    return data


@app.route('/verify_old', methods=['POST'])
def verifyOld():

    if request.method == "POST":
        email = request.json["email"]
        otp = request.json['otp']
        password = request.json['password']

    matcher = NodeMatcher(graph)
    user = matcher.match("User", email=email).first()

    if user['otp'] != int(otp):
        return {'message': 'invalid otp'}

    if user['otp'] == int(otp):
        query1 = """
                MATCH (u:User)
                WHERE u.user_id=$user_id AND u.email=$email
                SET u.password=$password
                REMOVE u.otp
                """
        graph.run(query1, user_id=user['user_id'],
                  email=email, password=bcrypt.encrypt(password))

    return {'message': 'success'}


@app.route('/verify_user', methods=['POST'])
def verify():

    if request.method == "POST":
        otp = request.json['otp']
        email = request.json["email"]
        attempt = request.json['attempt']
    matcher = NodeMatcher(graph)
    user = matcher.match("User", otp=int(otp)).first()

    if user == None:
        query = """
            MATCH (u:User)
            WHERE u.email=$email
            DELETE u
            """
        if attempt == 3:
            graph.run(query, email=email)
        return {'message': 'invalid otp'}

    esp = matcher.match("ESP", mac_add=user['mac_add']).first()

    if not esp:
        print('no esp')
        return {'message': 'invalid esp'}

    query1 = """
            MATCH (u:User)
            WHERE u.user_id=$user_id AND u.email=$email
            SET u.status=$status
            REMOVE u.otp
            """
    graph.run(query1, user_id=user['user_id'], email=email, status=True)
    rel = Relationship(user, "Connected", esp)
    graph.create(rel)
    return {'message': 'success'}


@app.route('/resend_email', methods=['GET'])
def resend():
    if request.method == "GET":
        email = request.args["email"]

    matcher = NodeMatcher(graph)
    user = matcher.match("User", email=email).first()

    otp = random.randint(100000, 999999)
    query1 = """
            MATCH (u:User)
            WHERE u.user_id=$user_id
            SET u.otp=$otp
            """
    graph.run(query1, user_id=user['user_id'], otp=otp)
    msg = Message('App Verification Email', sender="", recipients=[
                  email],
                  body='Hi, ' + user['fname'] + ' Please Enter the One Time Password(OTP) in your app to verify your email' +
                  '\nYour OTP is '+str(otp))

    mail.send(msg)

    return {'message': 'success'}


@app.route("/forget_pass", methods=['POST'])
def forgetPass():
    if request.method == "POST":
        email = request.json["email"]

    otp = random.randint(100000, 999999)
    matcher = NodeMatcher(graph)
    user = matcher.match("User", email=email).first()

    query1 = """
            MATCH (u:User)
            WHERE u.user_id=$user_id
            SET u.otp=$otp
            """
    graph.run(query1, user_id=user['user_id'], otp=otp)

    msg = Message('App Verification Email', sender="", recipients=[
                  email],
                  body='Hi, ' + user['fname'] +
                  ' Please Enter the One Time Password(OTP) in your app to verify your email' +
                  '\nYour OTP is '+str(otp))

    mail.send(msg)

    return {'message': 'success',
            'data': {'email': user['email'], 'user_id': user['user_id']}}


@app.route("/change_pass", methods=['POST'])
def changePass():
    if request.method == "POST":
        email = request.json["email"]
        old_pass = request.json["oldPass"]
        new_pass = request.json["newPass"]

    matcher = NodeMatcher(graph)
    user = matcher.match("User", email=email).first()

    valid = bcrypt.verify(old_pass, user["password"])
    if not valid:
        return {'message': 'invalid password'}

    query = """
            MATCH (u:User)
            WHERE u.user_id=$user_id
            SET u.password=$password
            """
    graph.run(query, user_id=user['user_id'],
              password=bcrypt.encrypt(new_pass))

    return {'message': 'success',
            'data': {'email': user['email'], 'user_id': user['user_id'],
                     'mac_add': user['mac_add']}}


@app.route("/login", methods=['POST'])
def login():
    if request.method == "POST":
        email = request.json["email"]
        password = request.json["password"]

    matcher = NodeMatcher(graph)
    user = matcher.match("User", email=email).first()

    print(user)
    if user is None:
        return {'message': 'invalid email'}

    if user['status'] == False:
        return {'message': 'invalid user',
                'data': {'email': user['email']}}

    valid = bcrypt.verify(password, user["password"])
    if not valid:
        return {'message': 'invalid password'}

    return {'message': 'success',
            'data': {'email': user['email'], 'user_id': user['user_id'],
                     'mac_add': user['mac_add']}}


@app.route('/register', methods=['POST'])
def register():
    if request.method == "POST":
        print(request.json)
        fname = request.json["fname"]
        lname = request.json["lname"]
        email = request.json["email"]
        phone_num = request.json["phoneNum"]
        address = request.json["address"]
        city = request.json["city"]
        mac_add = request.json["macAdd"]
        ip_add = request.json["ipAdd"]
        gender = request.json["gender"]
        password = request.json["password"]
        enc_pass = bcrypt.encrypt(password)

    matcher = NodeMatcher(graph)
    esp = matcher.match("ESP", mac_add=mac_add).first()
    user = matcher.match("User", email=email).first()

    if user:
        return {'message': 'already exists'}

    if not esp:
        print('no esp')
        return {'message': 'invalid esp'}
    otp = random.randint(100000, 999999)

    user = Node("User", fname=fname, lname=lname, email=email, phone_num=phone_num, address=address,
                city=city, ip_add=ip_add, mac_add=mac_add, otp=otp, status=False, gender=gender,
                password=enc_pass)
    graph.create(user)

    query = """
            MATCH (u:User)
            WHERE u.email=$email
            SET u.user_id=$user_id + ID(u)
            """
    graph.run(query, email=email, user_id='usr-neo-')

    msg = Message('App Verification Email', sender="",
                  recipients=[email],
                  body='Hi, ' + user['fname'] +
                  ' Please Enter the One Time Password(OTP) in your app to verify your email' +
                  '\n Your OTP is '+str(otp))
    mail.send(msg)

    return {'message': 'success', 'data': {'email': email, 'mac_add': mac_add}}
