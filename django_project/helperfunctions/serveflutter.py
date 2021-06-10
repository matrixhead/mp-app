import os
from django.views.static import serve

BASE_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
FLUTTER_WEB_APP = os.path.join(BASE_DIR, 'flutter_project/build/web')

def flutter_redirect(request, resource):
    return serve(request, resource, FLUTTER_WEB_APP)
