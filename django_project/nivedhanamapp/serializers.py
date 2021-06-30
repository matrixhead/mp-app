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
    scan =  serializers.ListField(child=serializers.ImageField(),write_only=True)
    page_number = serializers.ListField(child=serializers.IntegerField(),write_only=True)
    imageurl = serializers.SerializerMethodField('get_image_url')
    page_number_read = serializers.SerializerMethodField('get_page_number')
    class Meta:
        model = Scan
        extra_kwargs = {'SI_no': {'write_only': True}}
        fields =['scan','page_number','imageurl','SI_no','page_number_read']
    def get_image_url(self, obj):
        return obj.scan.name
    def get_page_number(self, obj):
        return obj.page_number
    def create(self, validated_data):
        nivedhanam = validated_data.pop("SI_no")
        for si, pn in zip(validated_data.pop("scan"), validated_data.pop("page_number")):
            scanobj=Scan.objects.create(SI_no=nivedhanam,page_number=pn,scan=si)
        return scanobj
    

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

    


