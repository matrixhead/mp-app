from customauth import models
from .models import *
from rest_framework import serializers
from PIL import Image
import io


class NivedhanamSerializer(serializers.ModelSerializer):

    imageurl = serializers.SerializerMethodField('get_image_url')

    class Meta:
        model = Nivedhanam
        fields = '__all__'

    def get_image_url(self, obj):
        return obj.scan.name


class ScanUploadSerializer(serializers.ModelSerializer):

    # def create(self, validated_data):
    #     image = validated_data['scan']
    #     buffer = io.BytesIO()
    #     i = Image.open(image)
    #     i.save(buffer, "JPEG", quality=10)
    #     return Scan(**validated_data)
        

    class Meta:
        model = Scan
        fields = '__all__'
