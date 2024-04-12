from django.shortcuts import render, redirect, get_object_or_404
from django.http import HttpResponse, JsonResponse
from .models import Categoria
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
            return redirect('categoria')  
    else:
        form = CategoriaForm()

    return render(request, 'formulario.html', {'form': form})    

def eliminar(request,id):
    categoria=Categoria.objects.get(categoriaID=id)
    categoria.delete()
    return redirect('categoria')

def editarCategoria(request, id):
    categoria = get_object_or_404(Categoria, categoriaID=id)
    template = 'formulario.html'
    
    if request.method == 'POST':
        form = CategoriaForm(request.POST, instance=categoria)
        if form.is_valid():
            form.save()
            return redirect('categoria')
        else:
            return render(request, template, {'form': form})
    else:
        # Si la solicitud no es de tipo POST, simplemente mostrar el formulario con los datos actuales del producto
        form = CategoriaForm(instance=categoria)
        return render(request, template, {'form': form})