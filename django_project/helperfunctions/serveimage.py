from pymongo.mongo_client import MongoClient
from mpdjango import settings
from django.http import StreamingHttpResponse
from wsgiref.util import FileWrapper
import gridfs


def test_image_server(request, filename):
    client = MongoClient(host=settings.DATABASES['default']['CLIENT']['host'])
    db = client[settings.DATABASES['default']['NAME']]
    fs = gridfs.GridFS(db, collection='scan_collection.scan_collection')
    file = fs.get_last_version(filename)
    response = StreamingHttpResponse(
        FileWrapper(file), content_type="application/pdf")
    file.close
    return response
