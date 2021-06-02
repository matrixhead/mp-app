from django.core import exceptions
from django.core.management.base import BaseCommand, CommandError
from django.contrib.auth.management.commands import createsuperuser
from nivedhanamapp.models import Nivedhanam
from django.contrib.auth import get_user_model
from django.core import management

class Command(BaseCommand):
    
    def __init__(self):
        self.user=get_user_model()


    def handle(self,*args, **options):
        
        if(len(self.user.objects.all())==0):
            print('no user found creating a super user "admin" with password "admin"')
            self.user.objects.create_superuser('admin', 'admin@mpokottayam', 'admin')
            print("creating some mock data")
            for i in range(200):
                nivedhanam =Nivedhanam(name="applicant",address="kottayam/kerala/india",letterno=i,)
                nivedhanam.save()
        else:
            print("user found skipping ")

