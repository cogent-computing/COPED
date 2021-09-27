## COMPILE ##

FROM python:3.9-slim-bullseye as compile-image

RUN apt-get update
RUN apt-get install -y --no-install-recommends build-essential gcc

WORKDIR /app

RUN pip install --user --upgrade pip
COPY ./requirements.txt .
RUN pip install --user -r requirements.txt

## USE ##

FROM python:3.9-slim-bullseye as runtime-image

COPY --from=compile-image /app/.local /app/.local
ENV PATH=/app/.local/bin:$PATH

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

COPY ./entrypoint.sh /app

ENTRYPOINT ["/app/entrypoint.sh"]
