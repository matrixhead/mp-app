from django.core import exceptions
from django.core.management.base import BaseCommand, CommandError
from django.contrib.auth.management.commands import createsuperuser
from nivedhanamapp.models import Nivedhanam
from django.contrib.auth import get_user_model
from django.core import management
from datetime import date
from pymongo.mongo_client import MongoClient
from mpdjango import settings

class Command(BaseCommand):
    
    def __init__(self):
        self.user=get_user_model()


    def handle(self,*args, **options):        
        if(len(self.user.objects.all())==0):
            print('no user found creating a super user "admin" with password "admin"')
            self.user.objects.create_superuser('admin', 'admin@mpokottayam', 'admin')
            print("creating some mock data")
            for i in range(20):
                nivedhanam =Nivedhanam(name="applicant{}".format(i),address="kottayam/kerala/india",letterno=i,date=date.today(),amount_sanctioned=i+1000,date_sanctioned=date.today(),remarks="lalala",pincode=680001,mobile=8129029020+i)
                nivedhanam.save()
        else:
            print("user found skipping ")

