from django.urls import path
from . import views
urlpatterns = [
    path('a/',views.home,name='home'),
    path('b/',views.home1,name='home1')
]