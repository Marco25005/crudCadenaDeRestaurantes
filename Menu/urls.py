from django.urls import path
from . import views
urlpatterns=[
    path("",views.home, name='inicio'),
    path("categorias/", views.categoria, name="categoria"),
    path("categorias/agregar/",views.agregarCategoria, name="agregar_plato"),
    path("categorias/<int:id>/eliminar/",views.eliminar, name="eliminar_plato"),
    path("categorias/<int:id>/editar/",views.editarCategoria, name="editar_plato")
]