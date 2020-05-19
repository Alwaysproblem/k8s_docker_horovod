mpirun \
-np 3 \
-H n-adx-recall-2:1,n-adx-recall-3:1,n-adx-recall-4:1 \
--allow-run-as-root -bind-to none \
-map-by slot -x LD_LIBRARY_PATH \
-x PATH -mca pml ob1 -mca btl ^openib python /examples/tensorflow_mnist.py