import uuid
import sys
from djongo import models
from djongo.storage import GridFSStorage
from PIL import Image
from io import BytesIO
from django.core.files.uploadedfile import InMemoryUploadedFile

grid_fs_storage = GridFSStorage(collection='scan_collection', base_url='scan_collection/')



class Category(models.Model):
     category_name = models.CharField(primary_key=True,max_length=100)
     categoryfields = models.JSONField(default={})
     objects = models.DjongoManager()


class Nivedhanam(models.Model):
    _id = models.UUIDField(
         unique=True,
         default = uuid.uuid4,
         editable = False)
    SI_no = models.AutoField(primary_key=True)
    name = models.CharField(max_length=200)
    address = models.TextField(null=True)
    pincode = models.IntegerField(null=True)
    letterno = models.IntegerField()
    date = models.DateField()
    mobile = models.TextField(null=True)
    reply_recieved = models.BooleanField()
    amount_sanctioned = models.FloatField()
    date_sanctioned = models.DateField(null=True)
    remarks = models.TextField(null=True)
    Category = models.ForeignKey(Category,on_delete=models.PROTECT,null=True)
    categoryfields = models.JSONField(default={},null=True)


    

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
     