from django.contrib import admin
from .models import *



class CategoryAdmin(admin.ModelAdmin):
    exclude = ('categoryfields',)

class NivedhanamAdmin(admin.ModelAdmin):
    exclude = ('categoryfields',)

# Register your models here.
admin.site.register(Nivedhanam,NivedhanamAdmin)
admin.site.register(Scan)
admin.site.register(Category,CategoryAdmin)