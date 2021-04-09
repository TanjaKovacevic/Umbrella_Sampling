for h in *.hist
do
./process_hist.py $h > $h.proc
done
./combine_hist.py *.proc > totalcount.tot
