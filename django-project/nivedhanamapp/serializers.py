from .models import Nivedhanam
from rest_framework import serializers

class NivedhanamSerializer(serializers.ModelSerializer):
    class Meta:
        model=Nivedhanam
        fields = '__all__' 