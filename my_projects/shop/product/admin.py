from django.contrib import admin
from .models import product

class productAdmin(admin.ModelAdmin):
    list_dispaly=('name','count')
# Register your models here.
admin.site.register(product,productAdmin),