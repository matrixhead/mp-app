from django.shortcuts import render
from .models import Nivedhanam
from .serializers import NivedhanamSerializer
from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticated



# Create your views here.
class NivedhanamViewSet(viewsets.ModelViewSet):
    queryset=Nivedhanam.objects.all().order_by('name')
    serializer_class=NivedhanamSerializer
    permission_classes =[IsAuthenticated]
