from rest_framework.decorators import api_view
from rest_framework.serializers import Serializer
from .models import Nivedhanam
from .serializers import *
from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticated
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework.filters import OrderingFilter
from rest_framework.response import Response
from django.core.files.uploadedfile import InMemoryUploadedFile




class NivedhanamViewSet(viewsets.ModelViewSet):
    queryset = Nivedhanam.objects.all()
    serializer_class = NivedhanamSerializer
    filter_backends = [DjangoFilterBackend, OrderingFilter]
    # filterset_fields = '__all__'
    # ordering_fields = '__all__'
    permission_classes = [IsAuthenticated]




class ScanViewSet(viewsets.ModelViewSet):
    queryset = Scan.objects.all()
    serializer_class = ScanUploadSerializer
    filter_backends = [DjangoFilterBackend, OrderingFilter]
    filterset_fields = ["SI_no"]


# @api_view(['POST'])
# def scanupload(request):
#     serializer_class = ScanUploadSerializer
#     if request.method == 'POST':
#         serializer_class = ScanUploadSerializer(data=request.data)
#         serializer_class.is_valid()
#         serializer_class.save()
#         response = "sucessful"
#         return Response(response)




