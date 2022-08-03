#!/bin/bash
#run as root

cd /sys/kernel/debug/tracing

echo 0 > tracing_on
echo nop > current_tracer
echo 0 > events/enable
echo 0 > options/stacktrace

# echo 'p:enqueue_task_fair enqueue_task_fair' > kprobe_events  
# echo 1 > events/kprobes/enqueue_task_fair/enable
echo 1 > tracing_on 
echo 1 > events/irq/irq_handler_exit/enable
echo 1 > events/irq/irq_handler_entry/enable
echo 1 > options/stacktrace

cat trace_pipe
