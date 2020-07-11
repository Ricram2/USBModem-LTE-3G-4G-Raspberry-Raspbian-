# USB_LTE-3G-4G-Raspberry-USBModem
Connecting to internet on a Raspberry Pi 3B+ (Raspbian) Via USB modem LTE/4G/3G ZTE MF821

### 1.  Install Modeswitch 
```bash
# apt-get install usb-modeswitch usb-modeswitch-data modemmanager
```

###  2. Install wvdial and minicom
```bash	
# apt-get install wvdial minicom
```
### 3. Change wvdial.conf

 on `/etc/wvdial.conf` input the following.
 
```shell	
[Dialer Defaults]
Init1 = ATZ
Init2 = ATQ0 V1 E1 S0=0 &C1 &D2 +FCLASS=0

#Replace "internet.comcel.com.co" for APN 
Init3 = AT+CGDCONT=1,"IP","internet.comcel.com.co"

#Replace for the ones specific to your carrier
Username = COMCELWAP
Password = COMCELWAP
Phone = *99#

Modem Type = Analog Modem
Stupid Mode = on
Baud = 9600
New PPPD = yes
Dial Command = ATDT

#Replace for wherever your USB STICK MODEM is mounted 
Modem = /dev/ttyUSB2
ISDN = 0
```

### Run  usbconnect.sh

Remember to change permissions
```shell
sudo chmod +x usbconnect.sh
```

Then run it. 
```shell
sudo ./usbconnect.sh
``` 

### You may need to do this after:
```shell
route add default dev ppp0
```

This sorts out the routes for internet access. 

### Run a classic ping
```shell
ping 8.8.8.8
```

---

UNDER VALIDATION 


1. find out the modem's idvendor and idProduct by running 
`$ lsusb`
	```
	i.e Bus 003 Device 003: ID 19d2:0257 ZTE WCDMA Technologies MSM
	```
Pay special atterntion to  **19d2:0257**

2. Go to `/lib/udev/rules.d/40-usb_modeswitch.rules` and add the following entry:

```
# ZTE MF821 4G LTE
ATTRS{idVendor}=="19d2", ATTRS{idProduct}=="0257", RUN+="usb_modeswitch '%b/%k'"
```
3. create file called: **19d2:0257** ({idVendor}:{idProduct}) in `/etc/usb_modeswitch.d/`  and add the following inside that file (remember to change the values for your own:

```
# ZTE LTE 4g modem
#
DefaultVendor=  0x19d2
DefaultProduct= 0x0257

TargetVendor=  0x19d2
TargetProduct= 0x0257

MessageContent="55534243123456782400000080000685000000240000000000000000000000"

CheckSuccess=20
```
4. make network manager recognize the device automatically. add this line to your `/etc/rc.local`
```
modprobe usbserial vendor=0x19d2 product=0x0257
```


DEEPLY BASED ON INFORMATION FOUND HERE:
https://ubuntuforums.org/showthread.php?t=2074518
