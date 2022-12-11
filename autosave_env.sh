declare CONTAINER
declare CONTAINER_PATH

# TODO:
# test this script
# make it so the container saves to a dotfile in the user's directory
# 

# start getting the cli args for container information
OPTIND=1

while getopts :c:p: opt; do
	case $opt in

	c)
	CONTAINER=$OPTARG
	;;
	p)
	CONTAINER_PATH=$OPTARG
	;;
	\?)
	echo "error: invalid option: -$OPTARG"
	exit 1
	;;
	:)
	echo "error: argument doesn't exist: -$OPTARG"
	exit 1
	;;
	esac
done

shift $((OPTIND-1))

# run the loop of saving the container
while [ true ]; do

	# wait until container stops again
	docker wait $CONTAINER > /dev/null
	
	# save the container
	if [ ! -f $CONTAINER_PATH/latestsnapshot.tar ]; then
		touch $CONTAINER_PATH/latestsnapshot.tar
	fi
	docker export $(docker ps -aqf name=$CONTAINER) > $CONTAINER_PATH/latestsnapshot.tar

	# wait until container starts again
	until [ "false" != $(docker inspect -f {{.State.Running}} $CONTAINER) ]; do
    		sleep 10
	done
done
