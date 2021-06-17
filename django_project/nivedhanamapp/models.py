import uuid
from djongo import models
from django.conf import settings
from djongo.storage import GridFSStorage

grid_fs_storage = GridFSStorage(collection='scan_collection', base_url='scan_collection/')

# Create your models here.
class Nivedhanam(models.Model):
    _id = models.UUIDField(
         unique=True,
         default = uuid.uuid4,
         editable = False)
    SI_no = models.AutoField(primary_key=True)
    name = models.CharField(max_length=200)
    address = models.TextField()
    letterno = models.IntegerField()
    date = models.DateField()
    reply_recieved = models.BooleanField()
    amount_sanctioned = models.FloatField()
    date_sanctioned = models.DateField()
    remarks = models.TextField()
    scan = models.ImageField(upload_to='scan_collection', storage=grid_fs_storage)


