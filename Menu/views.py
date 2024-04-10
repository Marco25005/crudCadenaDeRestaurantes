from django.shortcuts import render, redirect, get_object_or_404
from django.http import HttpResponse, JsonResponse
from .models import Categoria, Plato
from .forms import CrearFormulario
# Create your views here.

def plato(request):
    platos=Categoria.objects.all()
    return render(request,"menu.html",{'platos':platos} )

def categorias(request):
    return HttpResponse("categorias")

def home(request):
    return render(request,"index.html")

def prueba(request):
    if request.method=="GET":
        return render(request,"prueba.html",{"form":CrearFormulario()})
    else:
        categoria=request.POST["nombreCategoria"]
        postre=request.POST["postre"] 
        Categoria.objects.create(nombreCategoria=categoria,postre=postre)
        return redirect("/platos/")

    

def eliminar(request,id):
    platos=Plato.objects.get(id)
    platos.delete()