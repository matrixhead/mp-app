# Generated by Django 3.0.5 on 2021-06-27 13:43

from django.db import migrations, models
import django.db.models.deletion
import djongo.models.fields
import djongo.storage
import uuid


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Category',
            fields=[
                ('category_name', models.CharField(max_length=100, primary_key=True, serialize=False)),
                ('categoryfields', djongo.models.fields.JSONField(default={})),
            ],
        ),
        migrations.CreateModel(
            name='Nivedhanam',
            fields=[
                ('_id', models.UUIDField(default=uuid.uuid4, editable=False, unique=True)),
                ('SI_no', models.AutoField(primary_key=True, serialize=False)),
                ('name', models.CharField(max_length=200)),
                ('address', models.TextField(null=True)),
                ('pincode', models.IntegerField(null=True)),
                ('letterno', models.IntegerField()),
                ('date', models.DateField()),
                ('mobile', models.TextField(null=True)),
                ('reply_recieved', models.BooleanField()),
                ('amount_sanctioned', models.FloatField()),
                ('date_sanctioned', models.DateField(null=True)),
                ('remarks', models.TextField(null=True)),
                ('categoryfields', djongo.models.fields.JSONField(default={}, null=True)),
                ('Category', models.ForeignKey(null=True, on_delete=django.db.models.deletion.PROTECT, to='nivedhanamapp.Category')),
            ],
        ),
        migrations.CreateModel(
            name='Scan',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('page_number', models.IntegerField()),
                ('scan', models.ImageField(storage=djongo.storage.GridFSStorage(base_url='scan_collection/', collection='scan_collection'), upload_to='scan_collection')),
                ('SI_no', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='nivedhanamapp.Nivedhanam')),
            ],
        ),
    ]
