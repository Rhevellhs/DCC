FROM python:3.12-alpine as builder

WORKDIR /app


RUN apk add --no-cache --virtual .build-deps gcc musl-dev

COPY requirements.txt .

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir --prefix=/install -r requirements.txt && \
    apk del .build-deps

FROM python:3.12-alpine

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV DJANGO_SETTINGS_MODULE=onxp.settings

WORKDIR /app


RUN addgroup -S appuser && adduser -S -G appuser appuser


COPY --from=builder /install /usr/local


COPY --chown=appuser:appuser . .


RUN mkdir -p /app/staticfiles /app/mediafiles && \
    chown -R appuser:appuser /app


USER appuser


EXPOSE 8000


HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8000/ || exit 1

CMD ["gunicorn", "onxp.wsgi:application", "--bind", "0.0.0.0:8000"]
