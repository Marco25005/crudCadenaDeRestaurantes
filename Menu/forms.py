from django import forms
from crispy_forms.helper import FormHelper
from crispy_forms.layout import Submit
from .models import Categoria
class CategoriaForm(forms.ModelForm):
    class Meta:
        model = Categoria
        fields = ['entradas', 'postre', 'platoPrincipal']

    def __init__(self, *args, **kwargs):
        super(CategoriaForm, self).__init__(*args, **kwargs)
        self.helper = FormHelper(self)
        self.helper.form_method = 'post'
        self.helper.add_input(Submit('submit', 'Guardar'))
