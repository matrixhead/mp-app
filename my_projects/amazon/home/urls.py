from django.urls import path
from . import views

urlpatterns = [
    path('a/',views.home,name='home'),
    path('a/add',views.add,name='add')

]