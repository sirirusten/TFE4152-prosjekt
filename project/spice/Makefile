
plt=python3 ../../py/plot.py

pixSens:
	${MAKE} ngspice	 TB=pixelSensor_tb

ngspice:
	ngspice -a ${TB}.cir

aim:
	-rm ${TB}.log
	-rm ${TB}.csv
	aimspice ${TB}.cir -o csv | tee ${TB}.sim
	@cat ${TB}.sim | perl -ne "if(m/error/i){system('cat ${TB}.log'); exit 1;}"