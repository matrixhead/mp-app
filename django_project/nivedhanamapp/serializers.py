from .models import *
from rest_framework import serializers




# class ScanUploadSerializer(serializers.Serializer):
#     scan =  serializers.ListField(child=serializers.ImageField())
#     page_number = serializers.ListField(child=serializers.IntegerField())
#     SI_no = serializers.PrimaryKeyRelatedField(queryset=Nivedhanam.objects.all())

#     def create(self, validated_data):
#         nivedhanam = validated_data.pop("SI_no")
#         for si, pn in zip(validated_data.pop("scan"), validated_data.pop("page_number")):
#             scanobj=Scan.objects.create(SI_no=nivedhanam,page_number=pn,scan=si)
#         return scanobj



class ScanUploadSerializer(serializers.ModelSerializer):
    pdfurl = serializers.SerializerMethodField('get_pdf_url')
    class Meta:
        model = Scan
        extra_kwargs = {'SI_no': {'write_only': True}}
        fields =['scan','pdfurl','SI_no',]
    def get_pdf_url(self, obj):
        return obj.scan.name
   
    

class NivedhanamSerializer(serializers.ModelSerializer):
    categoryfields=serializers.JSONField(required=False)
    class Meta:
        model = Nivedhanam
        fields = '__all__'

class CategorySerializer(serializers.ModelSerializer):
    categoryfields=serializers.JSONField()
    num_nivedhanam=serializers.IntegerField(read_only=True)
    class Meta:
        model = Category
        fields = '__all__'

    


