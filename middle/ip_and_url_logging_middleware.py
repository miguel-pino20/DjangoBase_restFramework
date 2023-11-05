# myapp/middleware/ip_and_url_logging_middleware.py
from datetime import datetime

from DJBase.settings import BASE_DIR, os

class IPAndURLLoggingMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        date= datetime.now().date()
        start_time = datetime.now()  # Hora de inicio
        client_ip = request.META.get('REMOTE_ADDR', 'Desconocida')
        request_url = request.get_full_path()
        request_method = request.method
        port = request.META.get("SERVER_PORT")
        #request_statu=request.status
        #response = self.get_response(request)
        #status_code = response.status_code
        # Ruta al archivo donde se guardará la dirección IP y la URL
        file_path = f'{BASE_DIR}/logs/ip_and_url_{date}.log'
        if not os.path.exists(f"{BASE_DIR}/logs"):
            os.makedirs(f"{BASE_DIR}/logs")

        response = self.get_response(request)
        end_time = datetime.now()  # Hora de finalización
        execution_time = end_time - start_time  # Tiempo total de ejecución
        with open(file_path, 'a') as file:
            file.write(f'{start_time} | Status code: {response.status_code} | Client IP: {client_ip} | Port: {port} | Request URL: {request_url} | Request Method: {request_method} | Execution Time: {execution_time} \n ')
        return response
