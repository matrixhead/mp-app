from .models import Nivedhanam
from rest_framework import serializers

class NivedhanamSerializer(serializers.ModelSerializer):

    imageurl = serializers.SerializerMethodField('get_image_url')

    class Meta:
        model=Nivedhanam
        fields = '__all__' 

    def get_image_url(self, obj):
        return obj.scan.name

