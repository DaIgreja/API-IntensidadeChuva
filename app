from flask import Flask, request, jsonify
import jwt
import telnetlib
import json
import requests

app = Flask(__name__)
app.config['SECRET_KEY'] = 'sua_chave_secreta'

def authenticate(username, password):
    # Lógica de autenticação aqui
    if username == 'usuario' and password == 'senha':
        return True
    return False

def get_devices():
    token = 'seu_token_jwt_aqui'
    headers = {'Authorization': 'Bearer ' + token}
    response = requests.get('http://api.exemplo/dispositivos', headers=headers)

    if response.status_code == 200:
        devices = response.json()
        filtered_devices = [device for device in devices if device['fabricante'] == 'PredictWeather' and 'get_rainfall_intensity' in device['comandos']]
        return filtered_devices
    else:
        return None

def get_rainfall_intensity(device_ip, device_port):
    try:
        # Estabelece conexão telnet
        tn = telnetlib.Telnet(device_ip, device_port)

        # Envia comando para obter medições
        tn.write(b'get_rainfall_intensity\n')

        # Lê resposta
        response = tn.read_until(b'\n')

        # Fecha conexão telnet
        tn.close()

        return response.decode('utf-8')
    except Exception as e:
        print(f"Erro ao conectar-se ao dispositivo {device_ip}: {e}")
        return None

def get_all_rainfall_intensity(devices):
    measurements = {}
    for device in devices:
        device_ip = device['ip']
        device_port = device['porta']
        measurement = get_rainfall_intensity(device_ip, device_port)
        if measurement is not None:
            measurements[device_ip] = measurement
    return measurements

@app.route('/login', methods=['POST'])
def login():
    auth = request.authorization
    if not auth or not authenticate(auth.username, auth.password):
        return jsonify({'message': 'Falha na autenticação'}), 401

    token = jwt.encode({'user': auth.username}, app.config['SECRET_KEY'])
    return jsonify({'token': token.decode('UTF-8')})

@app.route('/medicoes_chuva', methods=['GET'])
def get_rainfall_measurements():
    auth_header = request.headers.get('Authorization')
    if not auth_header:
        return jsonify({'message': 'Token JWT ausente'}), 401

    token = auth_header.split(' ')[1]
    try:
        jwt.decode(token, app.config['SECRET_KEY'])
    except:
        return jsonify({'message': 'Token JWT inválido'}), 401

    # Obtem dispositivos filtrados
    devices = get_devices()

    if devices:
        # Obtem medições de chuva para cada dispositivo
        rainfall_measurements = get_all_rainfall_intensity(devices)
        return jsonify(rainfall_measurements), 200
    else:
        return jsonify({'message': 'Falha ao obter dispositivos'}), 500

if __name__ == '__main__':
    app.run(debug=True)
