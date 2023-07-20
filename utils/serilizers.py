from rest_framework import serializers
from utils.util import *
from DJBase.settings import os,DIR,MEDIA_ROOT,MEDIA_URL
import os
import base64
from django.db.models import Q, Max, Sum
from django.db.models.functions import Coalesce


class ImageSerializer(serializers.Serializer):
    base64 = serializers.CharField(required=False,allow_blank=True)
    ext = serializers.CharField(required=False,allow_blank=True)
    change = serializers.BooleanField()
    def validate(self, attrs):
        if attrs.get('change'):
            message = {}
            error = False
            if attrs.get('base64') is None or attrs.get('base64') == '':
                 message['base64'] = 'la imagen es requerida'
                 error = True
            if attrs.get('ext') is None or attrs.get('ext') == '':
                 message['ext'] = 'la extencion es requerida'
                 error = True
            if error :
                raise serializers.ValidationError(message)
        return attrs

class CbxSerializers(serializers.Serializer):
    value=serializers.IntegerField()
    label=serializers.CharField()
