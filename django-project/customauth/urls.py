from customauth.views import CustomAuthToken
from django.urls import path
from rest_framework.authtoken.views import obtain_auth_token

urlpatterns =[
    path('get-token/',CustomAuthToken.as_view()),
]