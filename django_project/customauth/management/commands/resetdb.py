from django.core.management.base import BaseCommand
from django.core import management
from pymongo.mongo_client import MongoClient
from mpdjango import settings

class Command(BaseCommand):

    def handle(self,*args, **options):
        # management.call_command('flush', verbosity=0, interactive=False)
        client = MongoClient(host=settings.DATABASES['default']['CLIENT']['host'])
        client.drop_database(settings.DATABASES['default']['NAME'])