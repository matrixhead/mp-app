from django.shortcuts import render
from django.http import HttpResponse
from .models import food

# Create your views here.
def home(request):
    food1=food.objects.all()
    return render(request,'index.html',{'f':food1})

def add(request):
    valu1=int(request.POST['num1'])
    valu2=int(request.POST['num2'])
    res=valu2+valu1
    return render(request,'result.html',{'result':res})