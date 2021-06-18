import uuid
import sys
from djongo import models
from djongo.storage import GridFSStorage
from PIL import Image
from io import BytesIO
from django.core.files.uploadedfile import InMemoryUploadedFile

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
    

class Scan(models.Model):
     SI_no = models.ForeignKey(Nivedhanam,on_delete=models.CASCADE)
     page_number=models.IntegerField()
     scan = models.ImageField(upload_to='scan_collection', storage=grid_fs_storage)
     def save(self, *args, **kwargs):
          if not self.id:
            self.scan = self.compressImage(self.scan)
          super(Scan, self).save(*args, **kwargs)

     def compressImage(self,scannedImage):
        imageTemproary = Image.open(scannedImage)
        outputIoStream = BytesIO()
        imageTemproary.save(outputIoStream , format='JPEG', quality=10)
        outputIoStream.seek(0)
        scannedImage = InMemoryUploadedFile(outputIoStream,'scan', "%s.jpg" % scannedImage.name.split('.')[0], 'image/jpeg', sys.getsizeof(outputIoStream), None)
        return scannedImage
     