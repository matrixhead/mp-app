from django.db.models.aggregates import Sum
from .models import Nivedhanam
from .serializers import *
from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticated
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework.filters import OrderingFilter
from rest_framework.response import Response
from rest_framework.decorators import action 
from django.db.models import Count
from rest_framework import status





class NivedhanamViewSet(viewsets.ModelViewSet):
    queryset = Nivedhanam.objects.all()
    serializer_class = NivedhanamSerializer
    filter_backends = [DjangoFilterBackend, OrderingFilter]
    filterset_fields = {
        'name': ['icontains'],
        'Category':['exact']
        }
    ordering_fields = '__all__'
    permission_classes = [IsAuthenticated]

    @action(methods=['get'], detail=False)
    def overview(self, request):
        totalnivedhanams = Nivedhanam.objects.count()
        recievednivedhanam = Nivedhanam.objects.filter(status="recieved").count()
        processing = Nivedhanam.objects.filter(status="processing").count()
        approved = Nivedhanam.objects.filter(status="approved").count()
       
        data = {"totalNivedhanams":totalnivedhanams,
                "recievedNivedhanams":recievednivedhanam,
                "processing":processing,
                'approved':approved,
               
        }
        return Response(data, status=status.HTTP_200_OK)

class CategoryViewSet(viewsets.ModelViewSet):
    queryset = Category.objects.all().annotate(num_nivedhanam=Count('nivedhanam'))
    serializer_class = CategorySerializer
    # permission_classes = [IsAuthenticated]




class ScanViewSet(viewsets.ModelViewSet):
    queryset = Scan.objects.all()
    serializer_class = ScanUploadSerializer
    filter_backends = [DjangoFilterBackend, OrderingFilter]
    filterset_fields = ["SI_no"]

    def create(self, request):
        serializer_class = ScanUploadSerializer(data=request.data)
        serializer_class.is_valid()
        Scan.objects.filter(SI_no__exact=request.data['SI_no']).delete()
        serializer_class.save()
        response = "Scans upload status : Success"
        return Response(response)


# @api_view(['POST'])
# def scanupload(request):
#     if request.method == 'POST':
#         serializer_class = ScanUploadSerializer(data=request.data)
#         serializer_class.is_valid()
#         serializer_class.save()
#         response = "sucessful"
#         return Response(response)

# class ScanViewSet(viewsets.ViewSet):
#     queryset = Scan.objects.all()
#     def create(self, request):
#         serializer_class = ScanUploadSerializer(data=request.data)
#         serializer_class.is_valid()
#         serializer_class.save()
#         response = "sucessful"
#         return Response(response)




