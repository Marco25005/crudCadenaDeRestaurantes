from django.urls import path
from . import views
urlpatterns=[
    path("",views.home, name='inicio'),
    path("categorias/", views.categoria, name="categoria"),
    path("agregar/",views.agregarCategoria, name="agregar_plato"),
    path("eliminar/",views.eliminar, name="eliminar_plato")
]