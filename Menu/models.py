from django.db import models

# Create your models here.
class Categoria(models.Model):
    nombreCategoria= models.CharField(max_length=200)
    postre=models.CharField(max_length=200)

    def __str__(self):
        return self.nombreCategoria

class Plato(models.Model):
    nombre=models.CharField(max_length=200)
    precio=models.FloatField()
    descripcion=models.TextField()
    categoria=models.ForeignKey(Categoria, on_delete=models.CASCADE)

    def __str__(self):
        return self.nombre+" -- "+ self.categoria.nombreCategoria