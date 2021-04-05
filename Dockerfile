FROM python:3.6
ENV PYTHONUNBUFFERED 1
#RUN mkdir -p /my_projects/shop/
ADD my_projects /
WORKDIR /my_projects/test_project
ADD requirements.txt /my_projects/test_project/
RUN pip install --upgrade pip && pip install -r requirements.txt
