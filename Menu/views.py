from django.shortcuts import render, redirect, get_object_or_404
from django.http import HttpResponse, JsonResponse
from .models import Categoria
from .forms import CrearFormulario
# Create your views here.

def categoria(request):
    categoria=Categoria.objects.all()
    return render(request,"menu.html",{'categorias':categoria} )

def home(request):
    return render(request,"index.html")

def agregarCategoria(request):
    if request.method=="GET":
        return render(request,"formulario.html",{"form":CrearFormulario()})
    else:
        categoria=request.POST["nombreCategoria"]
        postre=request.POST["postre"] 
        Categoria.objects.create(nombreCategoria=categoria,postre=postre)
        return redirect("categoria")

    

def eliminar(request,id):
    categoria=Categoria.objects.get(id)
    categoria.delete()