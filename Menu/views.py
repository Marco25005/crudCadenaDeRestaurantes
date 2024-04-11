from django.shortcuts import render, redirect, get_object_or_404
from django.http import HttpResponse, JsonResponse
from .models import Categoria
from django.contrib import messages
from .forms import CategoriaForm
# Create your views here.

def categoria(request):
    categoria=Categoria.objects.all()
    return render(request,"menu.html",{'categorias':categoria} )

def home(request):
    return render(request,"index.html")

def agregarCategoria(request):
    if request.method == 'POST':
        form = CategoriaForm(request.POST)
        if form.is_valid():
            form.save()
            messages.success(request, '¡Categoría agregada con éxito!')
            return redirect('categoria')  
    else:
        form = CategoriaForm()

    return render(request, 'formulario.html', {'form': form})    

def eliminar(request,id):
    categoria=Categoria.objects.get(id)
    categoria.delete()