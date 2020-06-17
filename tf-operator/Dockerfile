FROM tensorflow/tensorflow

RUN pip install --no-cache-dir deepctr[cpu]

COPY multi_worker_strategy-with-keras.py /
ENTRYPOINT ["python", "/multi_worker_strategy-with-keras.py", "--saved_model_dir", "/train/saved_model/", "--checkpoint_dir", "/train/checkpoint"]
