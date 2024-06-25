# # Append a timestamp and always write a new file
# #LOGFILE=/var/log/my_setup_log_file.$(date +%Y%h%d_%H.%M).log
# # Same log, growing and appending - make sure its a one time deal or that you have a log rotating utility running.
# LOGFILE=${PWD}/log_file_$(date +'%d%m%y.%H%M%S').log
# touch "${LOGFILE}"
# TAIL_PID=$!
# # [Un]comment the following line to control display of this script for the tty in real time.  All other commands should be passed to task.
# tail -f "${LOGFILE}" &
# # logging function - called task to make main section more readable...prepend it to commands, or group commands in a function and prepend the call.
# task() {
#     echo "===================================================================================================="
#     echo "$(date):$(printf ' %q' "$@")"
#     echo "===================================================================================================="
#     start=$(date +%s)
#     "$@" 2>&1
#     end=$(date +%s)
#     runtime=$((end-start))
#     echo "Elapsed time for command was $runtime seconds."
#     echo ""
# } >> "${LOGFILE}"

# ### FUNCTION DEFS...

# ### Main exectuion

# task my_operational_step_1
# task my_operational_step_2
# kill ${TAIL_PID}
# exit 0


LOGFILE=${PWD}/log_file_$(date +'%d%m%y.%H%M%S').log
touch "${LOGFILE}"
TAIL_PID=$!
tail -f "${LOGFILE}" &
{
    echo "=================================================="
    echo "$(date):$(printf ' %q' "$@")"
    echo "Elapsed time for command was $runtime seconds."
    echo "${TAIL_PID}"
    echo "=================================================="
} >> "${LOGFILE}"

kill ${TAIL_PID}
exit 0