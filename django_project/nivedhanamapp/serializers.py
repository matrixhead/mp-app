from .models import *
from rest_framework import serializers


class ScanUploadSerializer(serializers.ModelSerializer):
    imageurl = serializers.SerializerMethodField('get_image_url')
    class Meta:
        model = Scan
        extra_kwargs = {'scan': {'write_only': True},'SI_no': {'write_only': True}}
        fields ='__all__'
    def get_image_url(self, obj):
        return obj.scan.name

class NivedhanamSerializer(serializers.ModelSerializer):
    class Meta:
        model = Nivedhanam
        fields = '__all__'
