#!/bin/bash
MPI_JOB_NAME=tensorflow-mnist
PODNAME=$(kubectl get pods -l mpi_job_name=${MPI_JOB_NAME},mpi_role_type=launcher -o name)
kubectl attach ${PODNAME}