stride=50000
max_lines=150000
for i in *.traj
do
	my_stride=$stride
	while [ $my_stride -le $max_lines ]
	do
		echo "head -n $my_stride > ${i}.${my_stride}"
		head -n $my_stride ${i} > ${i}.${my_stride}
		my_stride=$(( ${my_stride} + ${stride} ))
	done

done
