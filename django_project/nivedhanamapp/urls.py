from django.urls import include,path
from rest_framework import routers
from rest_framework.authtoken.views import obtain_auth_token
from . import views

router = routers.DefaultRouter()
router.register(r'nivedhanams', views.NivedhanamViewSet)
router.register(r'scans', views.ScanViewSet)
router.register(r'category', views.CategoryViewSet)




urlpatterns =[
    path('',include(router.urls)),
    # path('scanupload/',views.scanupload),
]