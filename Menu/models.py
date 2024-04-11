from django.db import models

# Create your models here.
class Categoria(models.Model):
    entradas= models.CharField(max_length=200)
    postre=models.CharField(max_length=200)
    platoPrincipal=models.CharField(max_length=200)