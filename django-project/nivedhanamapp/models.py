from djongo import models

# Create your models here.
class Nivedhanam(models.Model):
    _id = models.ObjectIdField()
    SI_no = models.IntegerField(unique=True)
    name = models.CharField(max_length=200)
    address = models.TextField()
    letterno = models.IntegerField()
    date = models.DateField()
    reply_recieved = models.CharField(max_length=200)
    amount_sanctioned = models.FloatField()
    date_sanctioned = models.DateField()
    remarks = models.TextField()
    