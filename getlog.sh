#!/bin/bash
#run as root
echo 0 > /sys/kernel/debug/tracing/tracing_on
echo 0 > /sys/kernel/debug/tracing/events/enable
echo 0 > /sys/kernel/debug/tracing/options/stacktrace

cp  /sys/kernel/debug/tracing/trace ftrace.log
