# Generated by Django 5.0.3 on 2024-04-11 05:20

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Categoria',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('entradas', models.CharField(max_length=200)),
                ('postre', models.CharField(max_length=200)),
                ('platoPrincipal', models.CharField(max_length=200)),
            ],
        ),
    ]
