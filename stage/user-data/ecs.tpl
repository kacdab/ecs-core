#!/bin/bash
cluster="${ecs_cluster}"
echo ECS_CLUSTER=$cluster > /etc/ecs/ecs.config
echo ECS_AVAILABLE_LOGGING_DRIVERS='["json-file","awslogs"]' >> /etc/ecs/ecs.config
start ecs
