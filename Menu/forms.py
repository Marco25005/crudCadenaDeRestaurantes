from django import forms

class CrearFormulario(forms.Form):
    nombreCategoria= forms.CharField(label="Nombre", max_length=200)
    postre= forms.FloatField(label="Precio")
   
