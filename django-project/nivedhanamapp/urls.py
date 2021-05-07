from django.urls import include,path
from rest_framework import routers
from django.views.static import serve
import os
from rest_framework.authtoken.views import obtain_auth_token
from . import views

router = routers.DefaultRouter()
router.register(r'nivedhanams', views.NivedhanamViewSet)

BASE_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
FLUTTER_WEB_APP = os.path.join(BASE_DIR, 'flutter-project/build/web')

def flutter_redirect(request, resource):
    return serve(request, resource, FLUTTER_WEB_APP)


urlpatterns =[
    path('api/',include(router.urls)),
    path('get-token/',obtain_auth_token),

    path('', lambda r: flutter_redirect(r, 'index.html')),
    path('<path:resource>', flutter_redirect),
]