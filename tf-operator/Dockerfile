FROM tensorflow/tensorflow

RUN pip install tensorflow_datasets

COPY multi_worker_strategy-with-keras.py /
ENTRYPOINT ["python", "/multi_worker_strategy-with-keras.py", "--saved_model_dir", "/train/saved_model/", "--checkpoint_dir", "/train/checkpoint"]
