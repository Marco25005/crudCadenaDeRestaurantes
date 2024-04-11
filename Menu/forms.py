from django.forms import ModelForm
from .models import Categoria

# Crear la clase del formulario
class CategoriaForm(ModelForm):
    class Meta:
        model = Categoria
        fields = ['entradas', 'postre', 'platoPrincipal']

