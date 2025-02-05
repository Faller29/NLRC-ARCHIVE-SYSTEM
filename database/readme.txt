Steps to Set a Static IP on Windows 10/11

Step 1: Find Your Current Network Details
Open Command Prompt (CMD):
Press Win + R, type cmd, and hit Enter.
Type the following command and press Enter:
ipconfig /all

Note down these details:
IPv4 Address (e.g., 192.168.93.3)
Subnet Mask (e.g., 255.255.255.0)
Default Gateway (e.g., 192.168.93.1)
DNS Servers (Primary & Secondary, e.g., 8.8.8.8 and 8.8.4.4 for Google DNS)

Step 2: Set a Static IP Address
Open Network Settings:
Press Win + R, type ncpa.cpl, and hit Enter.
This opens the Network Connections window.
Right-click on your active network adapter (Wi-Fi or Ethernet) and select Properties.
Scroll down and select Internet Protocol Version 4 (TCP/IPv4), then click Properties.
Select "Use the following IP address" and enter:
IP Address: 192.168.93.3 (or any unused address in your network)
Subnet Mask: 255.255.255.0
Default Gateway: 192.168.93.1
Select "Use the following DNS server addresses" and enter:
Preferred DNS: 8.8.8.8 (Google DNS)
Alternate DNS: 8.8.4.4 (Google DNS)
Click OK, then Close.

Step 3: Verify the Static IP
Open Command Prompt (CMD) again.
Type:
ipconfig

Check that your IPv4 Address is now set to 192.168.93.3 and does not change after a restart.