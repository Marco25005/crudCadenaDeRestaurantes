from django import forms

class CrearFormulario(forms.Form):
    nombreCategoria= forms.CharField(label="Nombre", max_length=200)
    platoPrincipal= forms.CharField(label="Plato Principal", max_length=200)
    postre= forms.FloatField(label="Precio")
   
