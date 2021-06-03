from django.shortcuts import render
from .models import Nivedhanam
from .serializers import NivedhanamSerializer
from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticated
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework.filters import OrderingFilter






# Create your views here.
class NivedhanamViewSet(viewsets.ModelViewSet):
    queryset=Nivedhanam.objects.all().order_by('name')
    serializer_class=NivedhanamSerializer
    filter_backends = [DjangoFilterBackend,OrderingFilter]
    filterset_fields = '__all__'
    ordering_fields = '__all__'
    permission_classes =[IsAuthenticated]
