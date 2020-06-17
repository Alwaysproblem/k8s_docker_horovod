FROM tensorflow/tensorflow

RUN pip install --no-cache-dir deepctr[cpu]

COPY model.py /
ENTRYPOINT ["python", "/model.py"]
