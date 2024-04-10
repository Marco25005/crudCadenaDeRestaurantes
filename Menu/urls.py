from django.urls import path
from . import views
urlpatterns=[
    path("",views.home),
    path("platos/", views.plato),
    path("categorias/",views.categorias),
    path("prueba/",views.prueba),
    path("eliminar/",views.eliminar)
]