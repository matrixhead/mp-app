from customauth import models
from .models import *
from rest_framework import serializers

class NivedhanamSerializer(serializers.ModelSerializer):

    imageurl = serializers.SerializerMethodField('get_image_url')

    class Meta:
        model=Nivedhanam
        fields = '__all__' 

    def get_image_url(self, obj):
        return obj.scan.name

class ScanUploadSerializer(serializers.ModelSerializer):
    class Meta:
        model=Scan
        fields = '__all__'

    
