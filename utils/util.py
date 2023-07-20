import random
import string
from django.db.models.fields.related import ManyToOneRel,ForeignKey
from django.db.models.fields.files import ImageField,FileField
from django.db import models
import datetime

def CbxModel(model,value=None,name=None):
    list=[]
    for data in model:
        jdata={
            "value": data.pk,
            "label": str(data)
        }
        if not value is None:
            attribute_value = getattr(data, value)
            jdata.__setitem__(name,attribute_value)
        list.append(jdata)
    return list

# Generate a random string of length 10
def randomstr(length):
    random_string = ''.join(random.choices(string.ascii_lowercase, k=length))
    return random_string


def randomnum(length):
    # choose from all lowercase letter
    numbers = string.digits
    # print(numbers)
    result_str = ''.join(random.choice(numbers) for i in range(length))
    # print("Random string of length", length, "is:", result_str)
    return result_str


def calcular_meses(dias):
    # Obtener la fecha actual
    fecha_actual = datetime.date.today()

    # Calcular la fecha resultante después de la cantidad de días
    fecha_resultante = fecha_actual + datetime.timedelta(days=dias)

    # Calcular la diferencia en meses entre las fechas
    diferencia_meses = (fecha_resultante.year - fecha_actual.year) * 12 + (fecha_resultante.month - fecha_actual.month)

    return diferencia_meses

def custom_sort(objeto,key):
    return int(objeto[key])
